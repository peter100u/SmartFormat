import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../features/home/home_page.dart';
import '../features/result/task_result_page.dart';
import '../features/settings/settings_page.dart';
import '../features/tasks/task_detail_page.dart';
import '../features/tasks/tasks_page.dart';
import '../features/tools/tool_detail_page.dart';
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
    ],
    errorBuilder: (context, state) => RouteErrorPage(error: state.error),
  );
});

class AppRoutes {
  static const home = 'home';
  static const tasks = 'tasks';
  static const taskDetail = 'taskDetail';
  static const settings = 'settings';
  static const toolDetail = 'toolDetail';
  static const taskResult = 'taskResult';
}

class AppPaths {
  static const home = '/home';
  static const tasks = '/tasks';
  static const taskDetail = '/tasks/:taskId';
  static const settings = '/settings';
  static const toolDetail = '/tools/:toolId';
  static const taskResult = '/tasks/:taskId/result';
}

class RouteErrorPage extends StatelessWidget {
  const RouteErrorPage({required this.error, super.key});

  final Exception? error;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('页面不存在')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Text(error?.toString() ?? '无法打开这个页面'),
        ),
      ),
    );
  }
}
