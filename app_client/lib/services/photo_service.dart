import '../shared/models/media_file.dart';

/// 封装相册输入，并规范化选中的媒体资源。
///
/// 边界：
/// - 工具 controller 通过这个服务导入相册中的图片或视频。
/// - 权限弹窗和平台资源导出差异应在 widget 外处理。
/// - 返回的文件应可被本地处理流水线直接读取。
class PhotoService {
  const PhotoService();

  Future<List<MediaFile>> pickAssets() async {
    // TODO(mvp): 集成 `photo_manager` 或 `image_picker` 以选择相册媒体。
    return const [];
  }
}
