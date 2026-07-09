import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/repositories/task_repository.dart';
import 'database_providers.dart';

/// Declares repository dependencies for persistent app data.
///
/// Boundary:
/// - Repositories hide Drift details from feature controllers and pages.
/// - Provider setup should stay thin and deterministic for testing overrides.
final taskRepositoryProvider = Provider<TaskRepository>((ref) {
  return TaskRepository(ref.watch(appDatabaseProvider));
});
