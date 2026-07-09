import 'media_file.dart';
import 'tool_models.dart';

/// Immutable task pipeline models shared by controllers, runners, and services.
///
/// Boundary:
/// - TaskRequest describes the work to create from selected inputs and presets.
/// - TaskRecord describes persisted history and result lookup state.
/// - Platform/plugin return values should be normalized before entering these models.
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
