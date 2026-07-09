import '../shared/models/task_models.dart';

/// 负责本地媒体探测与处理相关的副作用。
///
/// 边界：
/// - controller 和 runner 应在任务记录创建后调用这个服务。
/// - FFmpeg/FFprobe 的插件调用应留在这里，不应出现在 widget 或 repository 中。
/// - 用户文件必须保留在本地设备上，这个服务不能上传媒体文件。
class MediaService {
  const MediaService();

  Stream<TaskProgress> execute(List<String> command) {
    // TODO(mvp): 执行 FFmpegKit 命令，并发出进度与状态更新。
    throw UnimplementedError('FFmpeg execution will be added in the MVP loop.');
  }

  Future<MediaProbeInfo> probe(String path) {
    // TODO(mvp): 执行 FFprobe 预检，并将流元数据映射为 `MediaProbeInfo`。
    throw UnimplementedError(
      'FFprobe integration will be added in the MVP loop.',
    );
  }
}
