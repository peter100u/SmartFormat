import 'package:drift/drift.dart';

/// Drift schema for processing history and App-internal result locations.
///
/// Boundary:
/// - Stores task status, input/output metadata, parameters, and concise errors.
/// - Does not guarantee permanent storage of original user media.
/// - Schema changes should be paired with migrations in AppDatabase.
class TaskRecords extends Table {
  TextColumn get id => text()();
  TextColumn get toolId => text()();
  TextColumn get status => text()();
  IntColumn get progress => integer().withDefault(const Constant(0))();
  TextColumn get inputName => text()();
  TextColumn get inputPath => text().nullable()();
  TextColumn get inputMimeType => text().nullable()();
  IntColumn get inputSizeBytes => integer().nullable()();
  TextColumn get outputPath => text().nullable()();
  TextColumn get outputMimeType => text().nullable()();
  IntColumn get outputSizeBytes => integer().nullable()();
  TextColumn get parametersJson => text()();
  TextColumn get errorCode => text().nullable()();
  TextColumn get errorMessage => text().nullable()();
  IntColumn get ffmpegReturnCode => integer().nullable()();
  TextColumn get logSummary => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get startedAt => dateTime().nullable()();
  DateTimeColumn get completedAt => dateTime().nullable()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}
