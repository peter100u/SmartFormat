import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../features/home/home_page.dart';
import '../features/result/task_result_page.dart';
import '../features/settings/about_mova_page.dart';
import '../features/settings/app_version_page.dart';
import '../features/settings/language_settings_page.dart';
import '../features/settings/settings_page.dart';
import '../features/tasks/task_detail_page.dart';
import '../features/tasks/tasks_page.dart';
import '../features/tools/tool_detail_page.dart';
import '../l10n/app_localizations.dart';
import '../shared/webview/mova_webview_config.dart';
import '../shared/webview/mova_webview_page.dart';
import '../shared/widgets/mova_scaffold.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: AppPaths.home,
    routes: [
      ShellRoute(
        builder: (context, state, child) => MovaScaffold(child: child),
        routes: [
          GoRoute(
            path: AppPaths.home,
            name: AppRoutes.home,
            pageBuilder: (context, state) =>
                const NoTransitionPage(child: HomePage()),
          ),
          GoRoute(
            path: AppPaths.tasks,
            name: AppRoutes.tasks,
            pageBuilder: (context, state) =>
                const NoTransitionPage(child: TasksPage()),
          ),
          GoRoute(
            path: AppPaths.settings,
            name: AppRoutes.settings,
            pageBuilder: (context, state) =>
                const NoTransitionPage(child: SettingsPage()),
          ),
        ],
      ),
      GoRoute(
        path: AppPaths.toolDetail,
        name: AppRoutes.toolDetail,
        builder: (context, state) =>
            ToolDetailPage(toolId: state.pathParameters['toolId'] ?? ''),
      ),
      GoRoute(
        path: AppPaths.taskDetail,
        name: AppRoutes.taskDetail,
        builder: (context, state) =>
            TaskDetailPage(taskId: state.pathParameters['taskId'] ?? ''),
      ),
      GoRoute(
        path: AppPaths.taskResult,
        name: AppRoutes.taskResult,
        builder: (context, state) =>
            TaskResultPage(taskId: state.pathParameters['taskId'] ?? ''),
      ),
      GoRoute(
        path: AppPaths.settingsLanguage,
        name: AppRoutes.settingsLanguage,
        builder: (context, state) => const LanguageSettingsPage(),
      ),
      GoRoute(
        path: AppPaths.settingsAppVersion,
        name: AppRoutes.settingsAppVersion,
        builder: (context, state) => const AppVersionPage(),
      ),
      GoRoute(
        path: AppPaths.settingsAbout,
        name: AppRoutes.settingsAbout,
        builder: (context, state) => const AboutMovaPage(),
      ),
      GoRoute(
        path: AppPaths.settingsLegal,
        name: AppRoutes.settingsLegal,
        builder: (context, state) {
          final slug = state.pathParameters['documentType'] ?? '';
          final l10n = AppLocalizations.of(context)!;
          final title = switch (slug) {
            'privacy-policy' => l10n.settingsPrivacyPolicy,
            'user-agreement' => l10n.settingsUserAgreement,
            'license' => l10n.settingsLicense,
            _ => null,
          };
          if (title == null) {
            return RouteErrorPage(detail: 'Unknown legal document: $slug');
          }
          return MovaWebViewPage(
            title: title,
            config: MovaWebViewConfig.legalDocument(
              initialUri: Uri.parse('https://www.baidu.com'),
            ),
          );
        },
      ),
    ],
    errorBuilder: (context, state) =>
        RouteErrorPage(detail: state.error?.toString()),
  );
});

class AppRoutes {
  static const home = 'home';
  static const tasks = 'tasks';
  static const taskDetail = 'taskDetail';
  static const settings = 'settings';
  static const settingsLanguage = 'settingsLanguage';
  static const settingsAppVersion = 'settingsAppVersion';
  static const settingsAbout = 'settingsAbout';
  static const settingsLegal = 'settingsLegal';
  static const toolDetail = 'toolDetail';
  static const taskResult = 'taskResult';
}

class AppPaths {
  static const home = '/home';
  static const tasks = '/tasks';
  static const taskDetail = '/tasks/:taskId';
  static const settings = '/settings';
  static const settingsLanguage = '/settings/language';
  static const settingsAppVersion = '/settings/version';
  static const settingsAbout = '/settings/about';
  static const settingsLegal = '/settings/legal/:documentType';
  static const toolDetail = '/tools/:toolId';
  static const taskResult = '/tasks/:taskId/result';
}

class RouteErrorPage extends StatelessWidget {
  const RouteErrorPage({this.detail, super.key});

  final String? detail;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.routeErrorTitle)),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Text(
            kDebugMode && detail != null
                ? '${l10n.routeErrorMessage}\n$detail'
                : l10n.routeErrorMessage,
          ),
        ),
      ),
    );
  }
}
