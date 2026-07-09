import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';

import 'app/app.dart';
import 'core/constants/app_constants.dart';
import 'shared/models/hive_registrar.g.dart';
import 'shared/models/task_models.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapters();
  await Hive.openBox<TaskRecord>(AppConstants.taskRecordsBoxName);
  await Hive.openBox<String>(AppConstants.appPreferencesBoxName);
  runApp(const ProviderScope(child: MovaApp()));
}
