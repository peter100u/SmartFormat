import '../shared/models/task_models.dart';

/// Owns local media inspection and processing side effects.
///
/// Boundary:
/// - Controllers and runners call this service after task records are created.
/// - FFmpeg/FFprobe plugin calls stay here, not in widgets or repositories.
/// - User files remain on device; this service must not upload media.
abstract class MediaService {
  Future<MediaProbeInfo> probe(String path);

  Stream<TaskProgress> execute(List<String> command);
}

class PendingMediaService implements MediaService {
  const PendingMediaService();

  @override
  Stream<TaskProgress> execute(List<String> command) {
    // TODO(mvp): Execute FFmpegKit commands and emit progress/status updates.
    throw UnimplementedError('FFmpeg execution will be added in the MVP loop.');
  }

  @override
  Future<MediaProbeInfo> probe(String path) {
    // TODO(mvp): Run FFprobe preflight and map stream metadata to MediaProbeInfo.
    throw UnimplementedError(
      'FFprobe integration will be added in the MVP loop.',
    );
  }
}
