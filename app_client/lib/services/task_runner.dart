import 'dart:io';

import 'package:logger/logger.dart';

import '../core/logging/app_logger.dart';
import '../data/repositories/task_repository.dart';
import '../shared/models/task_models.dart';
import '../shared/models/tool_models.dart';
import 'command_builder.dart';
import 'media_service.dart';

/// 编排一次任务请求的本地处理生命周期。
///
/// 边界：
/// - controller 通过 runner 发起开始、取消、重试等动作。
/// - runner 负责协调命令构建、FFmpeg 执行和任务记录。
/// - 它应通过 `TaskRepository` 输出任务状态，而不是直接修改 UI 状态。
class TaskRunner {
  TaskRunner({
    required this.mediaService,
    required this.taskRepository,
    required this.commandBuilder,
    Logger? logger,
  }) : _logger = logger ?? appLogger;

  final MediaService mediaService;
  final TaskRepository taskRepository;
  final CommandBuilder commandBuilder;
  final Logger _logger;
  static final Set<String> _activeTaskIds = <String>{};

  Future<void> startTasks(Iterable<TaskRequest> requests) async {
    for (final request in requests) {
      await startTask(request);
    }
  }

  Future<void> startTask(TaskRequest request) async {
    final startedAt = DateTime.now();
    _activeTaskIds.add(request.id);
    _logger.i(
      'task.start taskId=${request.id} toolId=${request.toolId} '
      'inputPath=${request.input.path ?? '-'} outputPath=${request.outputPath}',
    );
    await taskRepository.saveTask(
      TaskRecord(
        id: request.id,
        toolId: request.toolId,
        status: TaskStatus.queued,
        progress: 0,
        inputName: request.input.displayName,
        inputPath: request.input.path,
        outputPath: request.outputPath,
        outputMimeType: _guessOutputMimeType(request.outputPath),
        createdAt: request.createdAt,
        startedAt: startedAt,
      ),
    );

    try {
      final command = commandBuilder.build(request);
      _logger.d(
        'task.commandBuilt taskId=${request.id} command=${_joinCommand(command)}',
      );
      await for (final progress in mediaService.execute(command)) {
        final normalizedProgress = _normalizeProgress(progress.progress);
        _logTaskProgress(request.id, progress, normalizedProgress);
        await taskRepository.saveTask(
          TaskRecord(
            id: request.id,
            toolId: request.toolId,
            status: progress.status,
            progress: normalizedProgress,
            inputName: request.input.displayName,
            inputPath: request.input.path,
            outputPath: request.outputPath,
            outputMimeType: _guessOutputMimeType(request.outputPath),
            outputSizeBytes: await _loadOutputSizeBytes(request.outputPath),
            errorCode: _mapErrorCode(progress.status),
            errorMessage: progress.status == TaskStatus.failed
                ? progress.message
                : null,
            logSummary: progress.message,
            createdAt: request.createdAt,
            startedAt: startedAt,
            completedAt: _isTerminal(progress.status) ? DateTime.now() : null,
          ),
        );
      }
    } catch (error, stackTrace) {
      _logger.e(
        'task.failure taskId=${request.id} toolId=${request.toolId}',
        error: error,
        stackTrace: stackTrace,
      );
      await taskRepository.saveTask(
        TaskRecord(
          id: request.id,
          toolId: request.toolId,
          status: TaskStatus.failed,
          progress: 0,
          inputName: request.input.displayName,
          inputPath: request.input.path,
          outputPath: request.outputPath,
          outputMimeType: _guessOutputMimeType(request.outputPath),
          errorCode: TaskErrorCode.ffmpegFailed.name,
          errorMessage: error.toString(),
          logSummary: error.toString(),
          createdAt: request.createdAt,
          startedAt: startedAt,
          completedAt: DateTime.now(),
        ),
      );
    } finally {
      _activeTaskIds.remove(request.id);
    }
  }

  Future<void> cancelTask(String taskId) async {
    if (!_activeTaskIds.contains(taskId)) {
      _logger.w('task.cancel.ignored taskId=$taskId');
      return;
    }
    _logger.w('task.cancel taskId=$taskId');
    await mediaService.cancelTask(taskId);
  }

  int _normalizeProgress(double progress) {
    return (progress * 100).round().clamp(0, 100);
  }

  void _logTaskProgress(
    String taskId,
    TaskProgress progress,
    int normalizedProgress,
  ) {
    final message =
        'task.progress taskId=$taskId status=${progress.status.name} '
        'progress=$normalizedProgress message=${_sanitizeMessage(progress.message)}';
    switch (progress.status) {
      case TaskStatus.queued:
        _logger.t(message);
      case TaskStatus.running:
        _logger.d(message);
      case TaskStatus.succeeded:
        _logger.i(message);
      case TaskStatus.cancelled:
        _logger.w(message);
      case TaskStatus.failed:
        _logger.e(message);
    }
  }

  bool _isTerminal(TaskStatus status) {
    return switch (status) {
      TaskStatus.succeeded || TaskStatus.failed || TaskStatus.cancelled => true,
      TaskStatus.queued || TaskStatus.running => false,
    };
  }

  String? _mapErrorCode(TaskStatus status) {
    return switch (status) {
      TaskStatus.failed => TaskErrorCode.ffmpegFailed.name,
      TaskStatus.cancelled => TaskErrorCode.cancelled.name,
      TaskStatus.queued || TaskStatus.running || TaskStatus.succeeded => null,
    };
  }

  String? _guessOutputMimeType(String outputPath) {
    final extension = outputPath.split('.').last.toLowerCase();
    return switch (extension) {
      'mp4' || 'mov' || 'mkv' || 'webm' => 'video/$extension',
      'mp3' || 'wav' || 'aac' || 'm4a' => 'audio/$extension',
      'jpg' || 'jpeg' || 'png' || 'webp' => 'image/$extension',
      _ => null,
    };
  }

  Future<int?> _loadOutputSizeBytes(String outputPath) async {
    final file = File(outputPath);
    if (!await file.exists()) {
      return null;
    }
    return file.length();
  }

  String _joinCommand(List<String> command) {
    return command.map(_quoteCommandPart).join(' ');
  }

  String _quoteCommandPart(String value) {
    if (value.isEmpty) {
      return '""';
    }
    if (!value.contains(' ') && !value.contains('"')) {
      return value;
    }
    final escaped = value.replaceAll('"', r'\"');
    return '"$escaped"';
  }

  String _sanitizeMessage(String? message) {
    if (message == null || message.trim().isEmpty) {
      return '-';
    }
    return message.trim().replaceAll('\n', r'\n');
  }
}
