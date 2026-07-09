import '../shared/models/media_file.dart';

/// Wraps the system file picker and maps platform file handles to MediaFile.
///
/// Boundary:
/// - Tool controllers ask this service for inputs.
/// - Widgets must not call file_picker directly.
/// - iOS/Android path, sandbox, and security-scoped access differences belong here.
abstract class FileService {
  Future<List<MediaFile>> pickFiles();
}

class PendingFileService implements FileService {
  const PendingFileService();

  @override
  Future<List<MediaFile>> pickFiles() async {
    // TODO(mvp): Integrate file_picker and support single/multi media inputs.
    return const [];
  }
}
