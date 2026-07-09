/// 统一处理平台输入相关的权限检查与恢复指引。
///
/// 边界：
/// - controller 在执行需要权限的文件或相册操作前调用这里。
/// - 平台相关的 `permission_handler` 调用和跳转系统设置逻辑应放在这里。
/// - UI 应接收用户可读状态，而不是原始平台权限对象。
class PermissionService {
  const PermissionService();

  Future<bool> canReadPhotos() async {
    // TODO(mvp): 请求并读取相册权限，同时暴露被拒绝后的恢复状态。
    return false;
  }
}
