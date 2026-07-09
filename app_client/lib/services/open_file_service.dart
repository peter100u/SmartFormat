import 'package:open_file/open_file.dart';

/// Opens generated result files using the platform's default handler.
///
/// Boundary:
/// - Result/task controllers call this service after verifying the task output.
/// - Widgets must not call open_file directly.
/// - Plugin return codes should be mapped to user-readable failures.
abstract class OpenFileService {
  Future<void> open(String path);
}

class PluginOpenFileService implements OpenFileService {
  const PluginOpenFileService();

  @override
  Future<void> open(String path) async {
    // TODO(mvp): Surface OpenFile result errors instead of dropping plugin status.
    await OpenFile.open(path);
  }
}
