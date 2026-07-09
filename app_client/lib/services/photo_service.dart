import '../shared/models/media_file.dart';

/// Wraps album/photo-library input and normalizes selected assets.
///
/// Boundary:
/// - Tool controllers use this service for photo/video library imports.
/// - Permission prompts and platform asset export quirks stay outside widgets.
/// - Returned files should be readable by the local processing pipeline.
abstract class PhotoService {
  Future<List<MediaFile>> pickAssets();
}

class PendingPhotoService implements PhotoService {
  const PendingPhotoService();

  @override
  Future<List<MediaFile>> pickAssets() async {
    // TODO(mvp): Integrate photo_manager/image_picker for album media selection.
    return const [];
  }
}
