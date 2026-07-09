import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_ce/hive_ce.dart';

import '../../core/constants/app_constants.dart';
import '../models/task_models.dart';

final taskRecordsBoxProvider = Provider<Box<TaskRecord>>((ref) {
  final box = Hive.box<TaskRecord>(AppConstants.taskRecordsBoxName);
  ref.onDispose(box.close);
  return box;
});

final appPreferencesBoxProvider = Provider<Box<String>>((ref) {
  final box = Hive.box<String>(AppConstants.appPreferencesBoxName);
  ref.onDispose(box.close);
  return box;
});
