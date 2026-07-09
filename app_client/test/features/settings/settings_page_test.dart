import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mova/app/app.dart';
import 'package:mova/services/app_info_service.dart';
import 'package:mova/services/preferences_service.dart';
import 'package:mova/shared/providers/app_preferences_providers.dart';
import 'package:mova/shared/providers/service_providers.dart';
import 'package:mova/shared/webview/mova_webview_page.dart';

void main() {
  testWidgets('设置里的语言偏好会驱动 MaterialApp 的 locale', (tester) async {
    final container = ProviderContainer(
      overrides: [
        preferencesServiceProvider.overrideWithValue(
          TestPreferencesService(initialLanguageCode: 'zh'),
        ),
      ],
    );
    addTearDown(container.dispose);

    await tester.pumpWidget(
      UncontrolledProviderScope(container: container, child: const MovaApp()),
    );
    await tester.pumpAndSettle();

    final app = tester.widget<MaterialApp>(find.byType(MaterialApp));
    expect(app.locale?.languageCode, 'zh');
  });

  testWidgets('设置项可以导航到详情页面', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          appInfoServiceProvider.overrideWithValue(FakeAppInfoService()),
        ],
        child: const MovaApp(),
      ),
    );

    await tester.tap(find.text('设置'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('关于 Mova'));
    await tester.pumpAndSettle();

    expect(find.text('关于 Mova'), findsWidgets);
    expect(find.text('Mova 是一款面向普通用户的现代格式工厂。'), findsOneWidget);
  });

  testWidgets('应用版本页会展示运行时应用信息', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          appInfoServiceProvider.overrideWithValue(FakeAppInfoService()),
        ],
        child: const MovaApp(),
      ),
    );

    await tester.tap(find.text('设置'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('App 版本'));
    await tester.pumpAndSettle();

    expect(find.text('9.9.9'), findsOneWidget);
    expect(find.text('com.peter100u.mova'), findsOneWidget);
  });

  testWidgets('隐私政策入口会进入应用内法律页面', (tester) async {
    await tester.pumpWidget(const ProviderScope(child: MovaApp()));

    await tester.tap(find.text('设置'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('隐私政策'));
    await tester.pumpAndSettle();

    expect(find.byType(MovaWebViewPage), findsOneWidget);
    expect(find.text('隐私政策'), findsOneWidget);
  });

  testWidgets('语言选择会在应用内更新 locale', (tester) async {
    final preferences = TestPreferencesService(initialLanguageCode: 'zh');
    final container = ProviderContainer(
      overrides: [preferencesServiceProvider.overrideWithValue(preferences)],
    );
    addTearDown(container.dispose);

    await tester.pumpWidget(
      UncontrolledProviderScope(container: container, child: const MovaApp()),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('设置'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('多语言'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('English'));
    await tester.pumpAndSettle();

    expect(
      container.read(appLocaleControllerProvider).value?.languageCode,
      'en',
    );
    expect(find.text('Language'), findsOneWidget);
  });
}

class TestPreferencesService extends PreferencesService {
  TestPreferencesService({this.initialLanguageCode});

  String? initialLanguageCode;

  @override
  Future<String?> loadLanguageCode() async {
    return initialLanguageCode;
  }

  @override
  Future<void> saveLanguageCode(String languageCode) async {
    initialLanguageCode = languageCode;
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
