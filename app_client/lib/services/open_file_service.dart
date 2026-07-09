import 'dart:io';

import 'package:open_file/open_file.dart';

/// 使用平台默认处理器打开生成的结果文件。
///
/// 边界：
/// - 结果页和任务 controller 应在确认任务输出有效后调用这个服务。
/// - Widget 不应直接调用 `open_file`。
/// - 插件返回码应映射为用户可读的失败信息。
class OpenFileService {
  const OpenFileService({this.openFile});

  final Future<OpenResult> Function(String path)? openFile;

  Future<void> open(String path) async {
    final file = File(path);
    if (!await file.exists()) {
      throw Exception('要打开的文件不存在，请先确认导出成功。');
    }

    final result = await _open(path);
    switch (result.type) {
      case ResultType.done:
        return;
      case ResultType.fileNotFound:
        throw Exception('要打开的文件不存在，请先确认导出成功。');
      case ResultType.noAppToOpen:
        throw Exception('当前设备没有可用应用可以打开这个文件。');
      case ResultType.permissionDenied:
        throw Exception('系统拒绝打开这个文件，请检查权限设置。');
      case ResultType.error:
        throw Exception(_buildErrorMessage(result.message));
    }
  }

  Future<OpenResult> _open(String path) async {
    try {
      return await (openFile ?? OpenFile.open)(path);
    } catch (_) {
      throw Exception('打开文件失败，请稍后重试。');
    }
  }

  String _buildErrorMessage(String message) {
    final normalized = message.trim();
    if (normalized.isEmpty || normalized == 'done') {
      return '打开文件失败，请稍后重试。';
    }
    return '打开文件失败：$normalized';
  }
}
