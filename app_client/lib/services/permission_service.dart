/// Centralizes permission checks and recovery guidance for platform inputs.
///
/// Boundary:
/// - Controllers call this before file/photo actions that need permission.
/// - Platform-specific permission_handler calls and settings redirects stay here.
/// - UI receives user-readable state instead of raw platform permission objects.
abstract class PermissionService {
  Future<bool> canReadPhotos();
}

class PendingPermissionService implements PermissionService {
  const PendingPermissionService();

  @override
  Future<bool> canReadPhotos() async {
    // TODO(mvp): Request/read photo permission and expose denied recovery state.
    return false;
  }
}
