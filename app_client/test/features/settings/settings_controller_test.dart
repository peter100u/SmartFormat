import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mova/features/settings/settings_controller.dart';
import 'package:mova/services/app_info_service.dart';
import 'package:mova/services/cache_service.dart';
import 'package:mova/services/feedback_service.dart';
import 'package:mova/services/preferences_service.dart';
import 'package:mova/shared/providers/app_preferences_providers.dart';
import 'package:mova/shared/providers/service_providers.dart';

void main() {
  test('setLocale 会持久化应用内显式语言偏好', () async {
    final preferences = FakePreferencesService();
    final container = ProviderContainer(
      overrides: [preferencesServiceProvider.overrideWithValue(preferences)],
    );
    addTearDown(container.dispose);

    await container
        .read(appLocaleControllerProvider.notifier)
        .setLocale(const Locale('en'));

    expect(preferences.savedLanguageCode, 'en');
    expect(
      container.read(appLocaleControllerProvider).value?.languageCode,
      'en',
    );
  });

  test('sendFeedback 会携带应用信息委托给反馈服务', () async {
    final feedback = FakeFeedbackService();
    final appInfo = FakeAppInfoService();
    final container = ProviderContainer(
      overrides: [
        feedbackServiceProvider.overrideWithValue(feedback),
        appInfoServiceProvider.overrideWithValue(appInfo),
      ],
    );
    addTearDown(container.dispose);

    await container.read(settingsControllerProvider.notifier).sendFeedback();

    expect(feedback.lastSubject, contains('Mova Feedback'));
    expect(feedback.lastBody, contains('com.peter100u.mova'));
    expect(feedback.lastBody, contains('9.9.9'));
  });

  test('clearCache 会返回已清理的字节数', () async {
    final cache = FakeCacheService(bytesRemoved: 1024);
    final container = ProviderContainer(
      overrides: [cacheServiceProvider.overrideWithValue(cache)],
    );
    addTearDown(container.dispose);

    final result = await container
        .read(settingsControllerProvider.notifier)
        .clearCache();

    expect(result.bytesRemoved, 1024);
  });
}

class FakePreferencesService extends PreferencesService {
  String? savedLanguageCode;

  @override
  Future<String?> loadLanguageCode() async {
    return savedLanguageCode;
  }

  @override
  Future<void> saveLanguageCode(String languageCode) async {
    savedLanguageCode = languageCode;
  }
}

class FakeFeedbackService extends FeedbackService {
  String? lastSubject;
  String? lastBody;

  @override
  Future<void> sendFeedback({
    required String subject,
    required String body,
  }) async {
    lastSubject = subject;
    lastBody = body;
  }
}

class FakeAppInfoService extends AppInfoService {
  @override
  Future<AppInfo> load() async {
    return const AppInfo(
      appName: 'Mova',
      version: '9.9.9',
      buildNumber: '99',
      packageName: 'com.peter100u.mova',
    );
  }
}

class FakeCacheService extends CacheService {
  FakeCacheService({required this.bytesRemoved});

  final int bytesRemoved;

  @override
  Future<CacheCleanupResult> clearCache() async {
    return CacheCleanupResult(bytesRemoved: bytesRemoved);
  }
}
