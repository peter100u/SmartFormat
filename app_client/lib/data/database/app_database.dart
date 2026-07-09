import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

import '../../core/constants/app_constants.dart';
import 'tables.dart';

part 'app_database.g.dart';

@DriftDatabase(tables: [TaskRecords])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;
}

QueryExecutor _openConnection() {
  return driftDatabase(name: AppConstants.databaseName);
}
