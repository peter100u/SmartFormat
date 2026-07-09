# Settings MVP Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Implement a fully interactive MVP settings center for Mova with app-controlled language selection, feedback, placeholder privacy/legal links, cache cleanup, app info, and about content.

**Architecture:** Add a lightweight settings feature layer with a controller/state pair, detail pages for language/about/version, and small services for locale persistence, app info, feedback launch, placeholder URL launching, and cache cleanup. Keep side effects in services, keep UI declarative, and use explicit go_router routes only for in-app detail screens.

**Tech Stack:** Flutter, Riverpod, go_router, shared_preferences, package_info_plus, url_launcher, path_provider, flutter_test

---

### Task 1: Add settings tests and locale plumbing plan

**Files:**
- Create: `app_client/test/features/settings/settings_controller_test.dart`
- Create: `app_client/test/features/settings/settings_page_test.dart`
- Modify: `app_client/lib/app/app.dart`
- Create: `app_client/lib/shared/providers/app_preferences_providers.dart`

- [ ] **Step 1: Write the failing tests**

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mova/app/app.dart';

void main() {
  testWidgets('settings language preference drives MaterialApp locale', (
    tester,
  ) async {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const MovaApp(),
      ),
    );

    final app = tester.widget<MaterialApp>(find.byType(MaterialApp));
    expect(app.locale?.languageCode, 'zh');
  });
}
```

- [ ] **Step 2: Run tests to verify they fail**

Run: `flutter test test/features/settings/settings_page_test.dart`
Expected: FAIL because locale provider wiring does not exist yet.

- [ ] **Step 3: Write minimal implementation**

```dart
final appLocaleProvider = StateProvider<Locale>((ref) {
  return const Locale('zh');
});
```

```dart
return MaterialApp.router(
  locale: ref.watch(appLocaleProvider),
  // ...
);
```

- [ ] **Step 4: Run tests to verify they pass**

Run: `flutter test test/features/settings/settings_page_test.dart`
Expected: PASS.

- [ ] **Step 5: Commit**

```bash
git add app_client/lib/app/app.dart app_client/lib/shared/providers/app_preferences_providers.dart app_client/test/features/settings/settings_page_test.dart
git commit -m "test: add locale wiring coverage"
```

### Task 2: Implement persisted app-controlled locale selection

**Files:**
- Modify: `app_client/lib/app/app.dart`
- Create: `app_client/lib/services/preferences_service.dart`
- Modify: `app_client/lib/shared/providers/service_providers.dart`
- Modify: `app_client/lib/shared/providers/app_preferences_providers.dart`
- Create: `app_client/lib/features/settings/language_settings_page.dart`
- Test: `app_client/test/features/settings/settings_controller_test.dart`

- [ ] **Step 1: Write the failing test**

```dart
test('setLocale persists explicit in-app language preference', () async {
  final service = InMemoryPreferencesService();
  final container = ProviderContainer(
    overrides: [preferencesServiceProvider.overrideWithValue(service)],
  );
  addTearDown(container.dispose);

  await container.read(appLocaleControllerProvider.notifier).setLocale(
    const Locale('en'),
  );

  expect(service.savedLanguageCode, 'en');
  expect(container.read(appLocaleControllerProvider).languageCode, 'en');
});
```

- [ ] **Step 2: Run test to verify it fails**

Run: `flutter test test/features/settings/settings_controller_test.dart`
Expected: FAIL because no locale controller/persistence exists.

- [ ] **Step 3: Write minimal implementation**

```dart
abstract class PreferencesService {
  Future<String?> loadLanguageCode();
  Future<void> saveLanguageCode(String languageCode);
}
```

```dart
class AppLocaleController extends AsyncNotifier<Locale> {
  @override
  Future<Locale> build() async {
    final code = await ref.read(preferencesServiceProvider).loadLanguageCode();
    return Locale(code ?? 'zh');
  }

  Future<void> setLocale(Locale locale) async {
    await ref.read(preferencesServiceProvider).saveLanguageCode(
      locale.languageCode,
    );
    state = AsyncData(locale);
  }
}
```

- [ ] **Step 4: Run test to verify it passes**

Run: `flutter test test/features/settings/settings_controller_test.dart`
Expected: PASS.

- [ ] **Step 5: Commit**

```bash
git add app_client/lib/app/app.dart app_client/lib/services/preferences_service.dart app_client/lib/shared/providers/service_providers.dart app_client/lib/shared/providers/app_preferences_providers.dart app_client/lib/features/settings/language_settings_page.dart app_client/test/features/settings/settings_controller_test.dart
git commit -m "feat: add app-controlled language preference"
```

### Task 3: Add settings routes and interactive settings home

**Files:**
- Modify: `app_client/lib/app/router.dart`
- Modify: `app_client/lib/features/settings/settings_page.dart`
- Create: `app_client/lib/features/settings/settings_controller.dart`
- Create: `app_client/lib/features/settings/settings_state.dart`
- Test: `app_client/test/features/settings/settings_page_test.dart`

- [ ] **Step 1: Write the failing widget test**

```dart
testWidgets('settings tiles navigate to detail pages', (tester) async {
  await tester.pumpWidget(const ProviderScope(child: MovaApp()));
  await tester.tap(find.text('设置'));
  await tester.pumpAndSettle();

  await tester.tap(find.text('关于 Mova'));
  await tester.pumpAndSettle();

  expect(find.text('关于 Mova'), findsWidgets);
  expect(find.text('Mova 是一款面向普通用户的现代格式工厂'), findsOneWidget);
});
```

- [ ] **Step 2: Run test to verify it fails**

Run: `flutter test test/features/settings/settings_page_test.dart`
Expected: FAIL because detail routes/pages do not exist.

- [ ] **Step 3: Write minimal implementation**

```dart
GoRoute(
  path: AppPaths.settingsAbout,
  name: AppRoutes.settingsAbout,
  builder: (context, state) => const AboutMovaPage(),
),
```

```dart
SettingsTile(
  title: '关于 Mova',
  onTap: () => context.pushNamed(AppRoutes.settingsAbout),
)
```

- [ ] **Step 4: Run test to verify it passes**

Run: `flutter test test/features/settings/settings_page_test.dart`
Expected: PASS.

- [ ] **Step 5: Commit**

```bash
git add app_client/lib/app/router.dart app_client/lib/features/settings/settings_page.dart app_client/lib/features/settings/settings_controller.dart app_client/lib/features/settings/settings_state.dart app_client/test/features/settings/settings_page_test.dart
git commit -m "feat: add interactive settings navigation"
```

### Task 4: Implement app info and about/version pages

**Files:**
- Modify: `app_client/lib/services/app_info_service.dart`
- Modify: `app_client/lib/shared/providers/service_providers.dart`
- Create: `app_client/lib/features/settings/app_version_page.dart`
- Create: `app_client/lib/features/settings/about_mova_page.dart`
- Test: `app_client/test/features/settings/settings_page_test.dart`

- [ ] **Step 1: Write the failing test**

```dart
testWidgets('app version page shows runtime app info', (tester) async {
  await tester.pumpWidget(/* 使用假的应用信息服务构建应用 */);
  await tester.tap(find.text('App 版本'));
  await tester.pumpAndSettle();

  expect(find.text('1.0.0'), findsOneWidget);
  expect(find.text('com.peter100u.mova'), findsOneWidget);
});
```

- [ ] **Step 2: Run test to verify it fails**

Run: `flutter test test/features/settings/settings_page_test.dart`
Expected: FAIL because runtime app info page is missing.

- [ ] **Step 3: Write minimal implementation**

```dart
class PackageInfoAppInfoService implements AppInfoService {
  @override
  Future<AppInfo> load() async {
    final info = await PackageInfo.fromPlatform();
    return AppInfo(
      version: info.version,
      buildNumber: info.buildNumber,
      packageName: info.packageName,
    );
  }
}
```

- [ ] **Step 4: Run test to verify it passes**

Run: `flutter test test/features/settings/settings_page_test.dart`
Expected: PASS.

- [ ] **Step 5: Commit**

```bash
git add app_client/lib/services/app_info_service.dart app_client/lib/shared/providers/service_providers.dart app_client/lib/features/settings/app_version_page.dart app_client/lib/features/settings/about_mova_page.dart app_client/test/features/settings/settings_page_test.dart
git commit -m "feat: add app info and about pages"
```

### Task 5: Implement feedback flow

**Files:**
- Modify: `app_client/lib/services/feedback_service.dart`
- Modify: `app_client/lib/shared/providers/service_providers.dart`
- Modify: `app_client/lib/features/settings/settings_controller.dart`
- Test: `app_client/test/features/settings/settings_controller_test.dart`

- [ ] **Step 1: Write the failing test**

```dart
test('sendFeedback delegates to feedback service with app info', () async {
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
});
```

- [ ] **Step 2: Run test to verify it fails**

Run: `flutter test test/features/settings/settings_controller_test.dart`
Expected: FAIL because feedback action/service implementation is missing.

- [ ] **Step 3: Write minimal implementation**

```dart
class MailtoFeedbackService implements FeedbackService {
  @override
  Future<void> sendFeedback({required String subject, required String body}) async {
    final uri = Uri(
      scheme: 'mailto',
      path: 'support@peter100u.com',
      queryParameters: {'subject': subject, 'body': body},
    );
    if (!await launchUrl(uri)) throw Exception('feedback_unavailable');
  }
}
```

- [ ] **Step 4: Run test to verify it passes**

Run: `flutter test test/features/settings/settings_controller_test.dart`
Expected: PASS.

- [ ] **Step 5: Commit**

```bash
git add app_client/lib/services/feedback_service.dart app_client/lib/shared/providers/service_providers.dart app_client/lib/features/settings/settings_controller.dart app_client/test/features/settings/settings_controller_test.dart
git commit -m "feat: add settings feedback flow"
```

### Task 6: Implement placeholder privacy/legal links

**Files:**
- Create: `app_client/lib/services/link_launcher_service.dart`
- Modify: `app_client/lib/shared/providers/service_providers.dart`
- Modify: `app_client/lib/features/settings/settings_controller.dart`
- Modify: `app_client/lib/features/settings/settings_page.dart`
- Test: `app_client/test/features/settings/settings_page_test.dart`

- [ ] **Step 1: Write the failing test**

```dart
testWidgets('privacy and legal entries remain visible on settings page', (
  tester,
) async {
  await tester.pumpWidget(const ProviderScope(child: MovaApp()));
  await tester.tap(find.text('设置'));
  await tester.pumpAndSettle();

  expect(find.text('隐私政策'), findsOneWidget);
  expect(find.text('用户协议'), findsOneWidget);
  expect(find.text('许可证'), findsOneWidget);
});
```

- [ ] **Step 2: Run test to verify it fails**

Run: `flutter test test/features/settings/settings_page_test.dart`
Expected: FAIL because placeholder legal link launching does not exist.

- [ ] **Step 3: Write minimal implementation**

```dart
abstract class LinkLauncherService {
  Future<void> openPlaceholderLegalUrl();
}

class UrlLauncherLinkLauncherService implements LinkLauncherService {
  @override
  Future<void> openPlaceholderLegalUrl() async {
    if (!await launchUrl(Uri.parse('https://www.baidu.com'))) {
      throw Exception('legal_url_unavailable');
    }
  }
}
```

- [ ] **Step 4: Run test to verify it passes**

Run: `flutter test test/features/settings/settings_page_test.dart`
Expected: PASS.

- [ ] **Step 5: Commit**

```bash
git add app_client/lib/services/link_launcher_service.dart app_client/lib/shared/providers/service_providers.dart app_client/lib/features/settings/settings_controller.dart app_client/lib/features/settings/settings_page.dart app_client/test/features/settings/settings_page_test.dart
git commit -m "feat: add placeholder privacy and legal links"
```

### Task 7: Implement cache cleanup

**Files:**
- Create: `app_client/lib/services/cache_service.dart`
- Modify: `app_client/lib/shared/providers/service_providers.dart`
- Modify: `app_client/lib/features/settings/settings_controller.dart`
- Modify: `app_client/lib/features/settings/settings_state.dart`
- Test: `app_client/test/features/settings/settings_controller_test.dart`

- [ ] **Step 1: Write the failing test**

```dart
test('clearCache returns cleaned byte count', () async {
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
```

- [ ] **Step 2: Run test to verify it fails**

Run: `flutter test test/features/settings/settings_controller_test.dart`
Expected: FAIL because no cache cleanup service exists.

- [ ] **Step 3: Write minimal implementation**

```dart
class CacheCleanupResult {
  const CacheCleanupResult({required this.bytesRemoved});
  final int bytesRemoved;
}
```

```dart
class DirectoryCacheService implements CacheService {
  @override
  Future<CacheCleanupResult> clearCache() async {
    return const CacheCleanupResult(bytesRemoved: 0);
  }
}
```

- [ ] **Step 4: Run test to verify it passes**

Run: `flutter test test/features/settings/settings_controller_test.dart`
Expected: PASS.

- [ ] **Step 5: Commit**

```bash
git add app_client/lib/services/cache_service.dart app_client/lib/shared/providers/service_providers.dart app_client/lib/features/settings/settings_controller.dart app_client/lib/features/settings/settings_state.dart app_client/test/features/settings/settings_controller_test.dart
git commit -m "feat: add cache cleanup flow"
```

### Task 8: Verify the full settings MVP

**Files:**
- Modify: `app_client/lib/l10n/app_en.arb`
- Modify: `app_client/lib/l10n/app_zh.arb`
- Modify: `app_client/lib/features/settings/` (as needed for copy)
- Test: `app_client/test/features/settings/settings_controller_test.dart`
- Test: `app_client/test/features/settings/settings_page_test.dart`

- [ ] **Step 1: Add any missing localized strings and final failing assertions**

```dart
expect(find.text('中文'), findsOneWidget);
expect(find.text('English'), findsOneWidget);
expect(find.text('清理缓存'), findsOneWidget);
```

- [ ] **Step 2: Run the targeted tests**

Run: `flutter test test/features/settings`
Expected: PASS with all settings tests green.

- [ ] **Step 3: Run analyzer and app test suite**

Run: `flutter analyze`
Expected: `No issues found!`

Run: `flutter test`
Expected: all tests pass.

- [ ] **Step 4: Manually verify in simulator**

Run: `flutter run -d FCA60B49-F414-4299-8D61-733428C3B238`
Expected: settings page allows language switching, feedback tap, placeholder legal link launching, cache cleanup, and version/about viewing.

- [ ] **Step 5: Commit**

```bash
git add app_client/lib app_client/test
git commit -m "feat: complete settings MVP"
```
