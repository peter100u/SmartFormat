import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/repositories/task_repository.dart';
import 'database_providers.dart';

/// 声明持久化应用数据所需的 repository 依赖。
///
/// 边界：
/// - repository 负责向功能 controller 和页面隐藏 Hive 持久化细节。
/// - provider 配置应保持轻量且可预测，便于测试时覆盖。
final taskRepositoryProvider = Provider<TaskRepository>((ref) {
  return TaskRepository(ref.watch(taskRecordsBoxProvider));
});
