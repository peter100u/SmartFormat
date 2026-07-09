/// 负责应用内部生成结果的系统分享面板副作用。
///
/// 边界：
/// - 结果页和任务流程应通过 controller 调用这个服务。
/// - Widget 不应直接调用 `share_plus`。
/// - 文件缺失和平台分享失败应转换为用户可读的错误。
class ShareService {
  const ShareService();

  Future<void> shareFile(String path) async {
    // TODO(mvp): 集成 `share_plus`，并先校验结果文件是否存在。
  }
}
