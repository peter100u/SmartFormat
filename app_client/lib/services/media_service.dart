import 'dart:async';

import 'package:ffmpeg_kit_extended_flutter/ffmpeg_kit_extended_flutter.dart';
import 'package:logger/logger.dart';

import '../core/logging/app_logger.dart';
import '../shared/models/task_models.dart';
import '../shared/models/tool_models.dart';

/// 负责本地媒体探测与处理相关的副作用。
///
/// 边界：
/// - controller 和 runner 应在任务记录创建后调用这个服务。
/// - FFmpeg/FFprobe 的插件调用应留在这里，不应出现在 widget 或 repository 中。
/// - 用户文件必须保留在本地设备上，这个服务不能上传媒体文件。
class MediaService {
  const MediaService({FFmpegKitBackend? backend, this.logger})
    : _backend = backend ?? const FFmpegKitBackend();

  final FFmpegKitBackend _backend;
  final Logger? logger;

  Future<MediaProbeInfo> probe(String path) async {
    _effectiveLogger.d('media.probe.start path=$path');
    final snapshot = await _backend.probe(path);
    final result = MediaProbeInfo(
      duration: snapshot.duration,
      width: snapshot.width,
      height: snapshot.height,
      bitrate: snapshot.bitrate,
      videoCodec: snapshot.videoCodec,
      audioCodec: snapshot.audioCodec,
      hasVideo: snapshot.hasVideo,
      hasAudio: snapshot.hasAudio,
      rotation: snapshot.rotation,
    );
    _effectiveLogger.d(
      'media.probe.completed path=$path hasVideo=${result.hasVideo} '
      'hasAudio=${result.hasAudio} durationMs=${result.duration?.inMilliseconds ?? '-'}',
    );
    return result;
  }

  Stream<TaskProgress> execute(List<String> command) async* {
    _effectiveLogger.i(
      'media.execute.start command=${_toCommandString(command)}',
    );
    yield const TaskProgress(
      taskId: '',
      status: TaskStatus.running,
      progress: 0,
    );

    await for (final event in _backend.execute(command)) {
      switch (event.kind) {
        case MediaExecutionEventKind.statistics:
          _effectiveLogger.d(
            'media.execute.statistics progress=${event.progress ?? 0} '
            'elapsedMs=${event.elapsed?.inMilliseconds ?? '-'} '
            'message=${_sanitizeLogValue(event.message)}',
          );
          yield TaskProgress(
            taskId: '',
            status: TaskStatus.running,
            progress: event.progress ?? 0,
            elapsed: event.elapsed,
            message: event.message,
          );
        case MediaExecutionEventKind.completed:
          final returnCode = event.returnCode ?? 1;
          final status = _mapCompletionStatus(returnCode);
          final message = _buildCompletionMessage(event);
          _logCompletion(
            status: status,
            returnCode: returnCode,
            elapsed: event.elapsed,
            message: message,
          );
          yield TaskProgress(
            taskId: '',
            status: status,
            progress: _mapCompletionProgress(returnCode),
            elapsed: event.elapsed,
            message: message,
          );
      }
    }
  }

  Future<void> cancelTask(String taskId) async {
    _effectiveLogger.w('media.execute.cancel taskId=$taskId');
    _backend.cancelTask(taskId);
  }

  Logger get _effectiveLogger => logger ?? appLogger;

  void _logCompletion({
    required TaskStatus status,
    required int returnCode,
    required Duration? elapsed,
    required String? message,
  }) {
    final logMessage =
        'media.execute.completed status=${status.name} returnCode=$returnCode '
        'elapsedMs=${elapsed?.inMilliseconds ?? '-'} '
        'message=${_sanitizeLogValue(message)}';
    switch (status) {
      case TaskStatus.queued:
        _effectiveLogger.t(logMessage);
      case TaskStatus.running:
        _effectiveLogger.d(logMessage);
      case TaskStatus.succeeded:
        _effectiveLogger.i(logMessage);
      case TaskStatus.cancelled:
        _effectiveLogger.w(logMessage);
      case TaskStatus.failed:
        _effectiveLogger.e(logMessage);
    }
  }

  TaskStatus _mapCompletionStatus(int returnCode) {
    if (ReturnCode.isSuccess(returnCode)) {
      return TaskStatus.succeeded;
    }
    if (ReturnCode.isCancel(returnCode)) {
      return TaskStatus.cancelled;
    }
    return TaskStatus.failed;
  }

  double _mapCompletionProgress(int returnCode) {
    return ReturnCode.isSuccess(returnCode) ? 1 : 0;
  }

  String? _buildCompletionMessage(MediaExecutionEvent event) {
    final parts = <String>[
      if ((event.logs ?? '').trim().isNotEmpty) event.logs!.trim(),
      if ((event.failStackTrace ?? '').trim().isNotEmpty)
        event.failStackTrace!.trim(),
    ];
    if (parts.isEmpty) {
      return event.message;
    }
    return parts.join('\n');
  }

  String _sanitizeLogValue(String? value) {
    if (value == null || value.trim().isEmpty) {
      return '-';
    }
    return value.trim().replaceAll('\n', r'\n');
  }

  String _toCommandString(List<String> command) {
    return command.map(_escapeArgument).join(' ');
  }

  String _escapeArgument(String value) {
    if (value.isEmpty) {
      return '""';
    }
    final needsQuotes = value.contains(' ') || value.contains('"');
    if (!needsQuotes) {
      return value;
    }
    final escaped = value.replaceAll('"', r'\"');
    return '"$escaped"';
  }
}

class MediaProbeSnapshot {
  const MediaProbeSnapshot({
    this.duration,
    this.width,
    this.height,
    this.bitrate,
    this.videoCodec,
    this.audioCodec,
    this.hasVideo = false,
    this.hasAudio = false,
    this.rotation,
  });

  final Duration? duration;
  final int? width;
  final int? height;
  final int? bitrate;
  final String? videoCodec;
  final String? audioCodec;
  final bool hasVideo;
  final bool hasAudio;
  final int? rotation;
}

enum MediaExecutionEventKind { statistics, completed }

class MediaExecutionEvent {
  const MediaExecutionEvent.statistics({
    required this.progress,
    this.elapsed,
    this.message,
  }) : kind = MediaExecutionEventKind.statistics,
       returnCode = null,
       logs = null,
       failStackTrace = null;

  const MediaExecutionEvent.completed({
    required this.returnCode,
    this.elapsed,
    this.logs,
    this.failStackTrace,
    this.message,
  }) : kind = MediaExecutionEventKind.completed,
       progress = null;

  final MediaExecutionEventKind kind;
  final double? progress;
  final int? returnCode;
  final Duration? elapsed;
  final String? logs;
  final String? failStackTrace;
  final String? message;
}

class FFmpegKitBackend {
  const FFmpegKitBackend();

  Future<MediaProbeSnapshot> probe(String path) async {
    final session = FFprobeKit.getMediaInformation(path);
    final info = session.getMediaInformation();
    if (info == null) {
      return const MediaProbeSnapshot();
    }

    final videoStream = info.streams.cast<StreamInformation?>().firstWhere(
      (stream) => stream?.type == 'video',
      orElse: () => null,
    );
    final audioStream = info.streams.cast<StreamInformation?>().firstWhere(
      (stream) => stream?.type == 'audio',
      orElse: () => null,
    );
    final rotationValue = _parseRotation(
      videoStream?.allProperties?['side_data_list'],
      videoStream?.tags?['rotate'],
    );

    return MediaProbeSnapshot(
      duration: _parseDuration(info.duration),
      width: videoStream?.width,
      height: videoStream?.height,
      bitrate: _parseInt(info.bitrate) ?? _parseInt(videoStream?.bitrate),
      videoCodec: videoStream?.codec,
      audioCodec: audioStream?.codec,
      hasVideo: videoStream != null,
      hasAudio: audioStream != null,
      rotation: rotationValue,
    );
  }

  Stream<MediaExecutionEvent> execute(List<String> command) {
    final controller = StreamController<MediaExecutionEvent>();
    final commandString = _toCommandString(command);

    unawaited(() async {
      try {
        await FFmpegKit.executeAsync(
          commandString,
          onStatistics: (statistics) {
            controller.add(
              MediaExecutionEvent.statistics(
                progress: statistics.transcodingProgress ?? 0,
                elapsed: Duration(milliseconds: statistics.timeElapsed),
                message: 'speed=${statistics.speed.toStringAsFixed(2)}x',
              ),
            );
          },
          onComplete: (session) {
            controller.add(
              MediaExecutionEvent.completed(
                returnCode: session.getReturnCode(),
                elapsed: Duration(milliseconds: session.getDuration()),
                logs: session.getLogsAsString(),
                failStackTrace: session.getFailStackTrace(),
              ),
            );
            unawaited(controller.close());
          },
        );
      } catch (error, stackTrace) {
        controller.add(
          MediaExecutionEvent.completed(
            returnCode: 1,
            message: error.toString(),
            failStackTrace: stackTrace.toString(),
          ),
        );
        await controller.close();
      }
    }());

    return controller.stream;
  }

  void cancelTask(String taskId) {
    FFmpegKitExtended.cancelAllSessions();
  }

  String _toCommandString(List<String> command) {
    return command.map(_escapeArgument).join(' ');
  }

  String _escapeArgument(String value) {
    if (value.isEmpty) {
      return '""';
    }
    final needsQuotes = value.contains(' ') || value.contains('"');
    if (!needsQuotes) {
      return value;
    }
    final escaped = value.replaceAll('"', r'\"');
    return '"$escaped"';
  }

  Duration? _parseDuration(String? value) {
    final seconds = double.tryParse(value ?? '');
    if (seconds == null) {
      return null;
    }
    return Duration(milliseconds: (seconds * 1000).round());
  }

  int? _parseInt(Object? value) {
    if (value == null) {
      return null;
    }
    return int.tryParse(value.toString());
  }

  int? _parseRotation(Object? sideDataList, Object? rotateTag) {
    final directRotation = _parseInt(rotateTag);
    if (directRotation != null) {
      return directRotation;
    }
    if (sideDataList is List) {
      for (final item in sideDataList) {
        if (item is Map && item['rotation'] != null) {
          return _parseInt(item['rotation']);
        }
      }
    }
    return null;
  }
}
