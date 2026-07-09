import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../services/app_info_service.dart';
import '../../services/cache_service.dart';
import '../../shared/providers/service_providers.dart';
import 'settings_state.dart';

final settingsControllerProvider =
    NotifierProvider<SettingsController, SettingsState>(SettingsController.new);

/// 管理设置页中的反馈、法律文档地址和缓存清理等用户动作。
///
/// 边界：
/// - 页面通过这个 controller 触发副作用，不直接调用底层 service。
/// - 应用信息、反馈发送和缓存清理通过 provider 注入的 service 完成。
/// - 这个 controller 只维护设置页交互状态，不持久化业务数据。
class SettingsController extends Notifier<SettingsState> {
  @override
  SettingsState build() {
    return const SettingsState();
  }

  Future<void> sendFeedback() async {
    state = state.copyWith(isSendingFeedback: true);
    try {
      final appInfo = await ref.read(appInfoServiceProvider).load();
      await ref
          .read(feedbackServiceProvider)
          .sendFeedback(
            subject: 'Mova Feedback',
            body: _buildFeedbackBody(appInfo),
          );
    } finally {
      state = state.copyWith(isSendingFeedback: false);
    }
  }

  Future<CacheCleanupResult> clearCache() async {
    state = state.copyWith(isClearingCache: true);
    try {
      final result = await ref.read(cacheServiceProvider).clearCache();
      state = state.copyWith(
        isClearingCache: false,
        lastCacheCleanupResult: result,
      );
      return result;
    } catch (_) {
      state = state.copyWith(isClearingCache: false);
      rethrow;
    }
  }

  String _buildFeedbackBody(AppInfo appInfo) {
    return '''
应用：${appInfo.appName}
版本：${appInfo.version}
构建号：${appInfo.buildNumber}
包名：${appInfo.packageName}

请在这里描述你的反馈内容：
''';
  }
}
