import 'dart:ui';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'service_providers.dart';

final appLocaleControllerProvider =
    AsyncNotifierProvider<AppLocaleController, Locale>(AppLocaleController.new);

/// 管理应用内语言偏好，并在启动时恢复已保存的 locale。
class AppLocaleController extends AsyncNotifier<Locale> {
  @override
  Future<Locale> build() async {
    final code = await ref.read(preferencesServiceProvider).loadLanguageCode();
    return Locale(code ?? 'zh');
  }

  Future<void> setLocale(Locale locale) async {
    await ref
        .read(preferencesServiceProvider)
        .saveLanguageCode(locale.languageCode);
    state = AsyncData(locale);
  }
}
