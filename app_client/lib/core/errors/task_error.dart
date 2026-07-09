import '../../shared/models/tool_models.dart';

class TaskError implements Exception {
  const TaskError({
    required this.code,
    required this.message,
    this.ffmpegReturnCode,
    this.logSummary,
  });

  final TaskErrorCode code;
  final String message;
  final int? ffmpegReturnCode;
  final String? logSummary;
}
