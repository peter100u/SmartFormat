import 'package:permission_handler/permission_handler.dart';
import 'package:photo_manager/photo_manager.dart';

/// 统一处理平台输入相关的权限检查与恢复指引。
///
/// 边界：
/// - controller 在执行需要权限的文件或相册操作前调用这里。
/// - 平台相关的 `permission_handler` 调用和跳转系统设置逻辑应放在这里。
/// - UI 应接收用户可读状态，而不是原始平台权限对象。
class PermissionService {
  const PermissionService({
    this.requestPhotoPermission,
    this.requestLibraryAccess,
  });

  final Future<PermissionStatus> Function()? requestPhotoPermission;
  final Future<PermissionState> Function()? requestLibraryAccess;

  Future<bool> canReadPhotos() async {
    try {
      final status =
          await (requestPhotoPermission ?? () => Permission.photos.request())();
      if (status.isGranted || status.isLimited) {
        return true;
      }
    } catch (_) {
      // 这里继续回退到 photo_manager，兼容平台差异。
    }

    try {
      final state =
          await (requestLibraryAccess ?? PhotoManager.requestPermissionExtend)();
      return state.hasAccess;
    } catch (_) {
      return false;
    }
  }
}
