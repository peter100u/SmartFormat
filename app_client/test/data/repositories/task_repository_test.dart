import 'dart:async';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:hive_ce/hive_ce.dart';
import 'package:mova/core/constants/app_constants.dart';
import 'package:mova/data/repositories/task_repository.dart';
import 'package:mova/shared/models/hive_registrar.g.dart';
import 'package:mova/shared/models/task_models.dart';
import 'package:mova/shared/models/tool_models.dart';

void main() {
  late Directory tempDir;
  late Box<TaskRecord> box;
  late TaskRepository repository;

  setUp(() async {
    tempDir = await Directory.systemTemp.createTemp('mova_hive_test_');
    Hive.init(tempDir.path);
    Hive.registerAdapters();
    box = await Hive.openBox<TaskRecord>(AppConstants.taskRecordsBoxName);
    repository = TaskRepository(box);
  });

  tearDown(() async {
    await box.close();
    await Hive.close();
    if (tempDir.existsSync()) {
      await tempDir.delete(recursive: true);
    }
  });

  test('watchRecentTasks emits the initial snapshot', () async {
    await expectLater(repository.watchRecentTasks(), emits(isEmpty));
  });

  test('watchRecentTasks emits inserted records in reverse createdAt order', () async {
    await repository.saveTask(_record(id: 'older', createdAt: DateTime(2026)));

    final stream = repository.watchRecentTasks();
    expect((await stream.first).map((record) => record.id).toList(), ['older']);

    final nextSnapshot = _nextSnapshot(stream, () async {
      await repository.saveTask(
        _record(id: 'newer', createdAt: DateTime(2026, 1, 2)),
      );
    });

    final records = await nextSnapshot;
    expect(records.map((record) => record.id).toList(), ['newer', 'older']);
  });

  test('watchRecentTasks emits deletions', () async {
    final existing = _record(id: 'keep', createdAt: DateTime(2026, 1, 1));
    await repository.saveTask(existing);

    final stream = repository.watchRecentTasks();
    expect((await stream.first).map((record) => record.id).toList(), ['keep']);

    final nextSnapshot = _nextSnapshot(stream, () async {
      await repository.deleteTask('keep');
    });

    expect(await nextSnapshot, isEmpty);
  });
}

Future<List<TaskRecord>> _nextSnapshot(
  Stream<List<TaskRecord>> stream,
  Future<void> Function() action,
) async {
  late StreamSubscription<List<TaskRecord>> subscription;
  final completer = Completer<List<TaskRecord>>();

  subscription = stream.skip(1).listen((records) async {
    await subscription.cancel();
    completer.complete(records);
  });

  await action();
  return completer.future;
}

TaskRecord _record({
  required String id,
  required DateTime createdAt,
}) {
  return TaskRecord(
    id: id,
    toolId: 'video.extractAudio',
    status: TaskStatus.queued,
    progress: 0,
    inputName: '$id.mp4',
    createdAt: createdAt,
  );
}
