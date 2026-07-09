import 'media_file.dart';
import 'tool_models.dart';

/// controller、runner 和 service 共享的不可变任务流水线模型。
///
/// 边界：
/// - `TaskRequest` 描述基于已选输入和预设需要创建的工作项。
/// - `TaskRecord` 描述已持久化的历史记录和结果查询状态。
/// - 平台或插件返回值在进入这些模型前应先完成规范化。
class TaskRequest {
  const TaskRequest({
    required this.id,
    required this.toolId,
    required this.input,
    required this.presetId,
    required this.outputTarget,
    required this.outputPath,
    required this.parameters,
    required this.createdAt,
  });

  final String id;
  final String toolId;
  final MediaFile input;
  final String presetId;
  final OutputTarget outputTarget;
  final String outputPath;
  final Map<String, Object?> parameters;
  final DateTime createdAt;
}

class TaskRecord {
  const TaskRecord({
    required this.id,
    required this.toolId,
    required this.status,
    required this.progress,
    required this.inputName,
    required this.createdAt,
    this.inputPath,
    this.outputPath,
    this.outputMimeType,
    this.outputSizeBytes,
    this.errorCode,
    this.errorMessage,
    this.ffmpegReturnCode,
    this.logSummary,
    this.startedAt,
    this.completedAt,
  });

  final String id;
  final String toolId;
  final TaskStatus status;
  final int progress;
  final String inputName;
  final String? inputPath;
  final String? outputPath;
  final String? outputMimeType;
  final int? outputSizeBytes;
  final String? errorCode;
  final String? errorMessage;
  final int? ffmpegReturnCode;
  final String? logSummary;
  final DateTime createdAt;
  final DateTime? startedAt;
  final DateTime? completedAt;
}

class MediaProbeInfo {
  const MediaProbeInfo({
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

class TaskProgress {
  const TaskProgress({
    required this.taskId,
    required this.status,
    required this.progress,
    this.elapsed,
    this.message,
  });

  final String taskId;
  final TaskStatus status;
  final double progress;
  final Duration? elapsed;
  final String? message;
}
