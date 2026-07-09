import '../shared/models/task_models.dart';

/// Converts task requests and presets into FFmpeg command arguments.
///
/// Boundary:
/// - Tool-specific defaults belong in the tool registry/request parameters.
/// - This builder turns validated requests into commands only.
/// - It must not execute FFmpeg, write task records, or show UI errors.
class CommandBuilder {
  const CommandBuilder();

  List<String> build(TaskRequest request) {
    // TODO(mvp): Build per-tool commands for conversion, compression, and extraction.
    return ['-y', '-i', request.input.path ?? '', request.outputPath];
  }
}
