import 'package:open_file/open_file.dart';

/// 使用平台默认处理器打开生成的结果文件。
///
/// 边界：
/// - 结果页和任务 controller 应在确认任务输出有效后调用这个服务。
/// - Widget 不应直接调用 `open_file`。
/// - 插件返回码应映射为用户可读的失败信息。
class OpenFileService {
  const OpenFileService();

  Future<void> open(String path) async {
    // TODO(mvp): 暴露 `OpenFile` 的错误结果，而不是直接忽略插件状态。
    await OpenFile.open(path);
  }
}
