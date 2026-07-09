import 'dart:io';

import 'package:share_plus/share_plus.dart';

/// 负责应用内部生成结果的系统分享面板副作用。
///
/// 边界：
/// - 结果页和任务流程应通过 controller 调用这个服务。
/// - Widget 不应直接调用 `share_plus`。
/// - 文件缺失和平台分享失败应转换为用户可读的错误。
class ShareService {
  const ShareService({this.shareFiles});

  final Future<ShareResult> Function(List<XFile> files)? shareFiles;

  Future<void> shareFile(String path) async {
    final file = File(path);
    if (!await file.exists()) {
      throw Exception('要分享的文件不存在，请先确认导出成功。');
    }

    try {
      await (shareFiles ??
          (files) => SharePlus.instance.share(ShareParams(files: files)))([
        XFile(path),
      ]);
    } catch (_) {
      throw Exception('分享文件失败，请稍后重试。');
    }
  }
}
