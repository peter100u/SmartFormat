import '../shared/models/task_models.dart';

/// 将任务请求和预设转换为 FFmpeg 命令参数。
///
/// 边界：
/// - 工具默认值应放在工具注册表或请求参数中。
/// - 这个构建器只负责把已校验的请求转换为命令。
/// - 它不应执行 FFmpeg、写入任务记录或展示 UI 错误。
class CommandBuilder {
  const CommandBuilder();

  List<String> build(TaskRequest request) {
    // TODO(mvp): 为转换、压缩、提取等不同工具构建各自的命令。
    return ['-y', '-i', request.input.path ?? '', request.outputPath];
  }
}
