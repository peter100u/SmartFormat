/// Owns system share sheet side effects for generated App-internal results.
///
/// Boundary:
/// - Result and task flows call this service through controllers.
/// - Widgets must not invoke share_plus directly.
/// - Missing files and platform share failures should become user-readable errors.
abstract class ShareService {
  Future<void> shareFile(String path);
}

class PendingShareService implements ShareService {
  const PendingShareService();

  @override
  Future<void> shareFile(String path) async {
    // TODO(mvp): Integrate share_plus and validate result file existence first.
  }
}
