import '../shared/models/media_file.dart';

/// 封装系统文件选择器，并将平台文件句柄映射为 `MediaFile`。
///
/// 边界：
/// - 工具 controller 应通过这个服务获取输入文件。
/// - Widget 不应直接调用 `file_picker`。
/// - iOS/Android 的路径、沙箱和安全作用域访问差异应在这里处理。
class FileService {
  const FileService();

  Future<List<MediaFile>> pickFiles() async {
    // TODO(mvp): 集成 `file_picker`，并支持单个或多个媒体文件输入。
    return const [];
  }
}
