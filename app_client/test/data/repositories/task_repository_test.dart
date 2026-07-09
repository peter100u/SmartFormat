import 'dart:async';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:hive_ce/hive_ce.dart';
import 'package:mova/core/constants/app_constants.dart';
import 'package:mova/data/repositories/task_repository.dart';
import 'package:mova/shared/models/hive_registrar.g.dart';
import 'package:mova/shared/models/task_models.dart';
import 'package:mova/shared/models/tool_models.dart';

import '../../support/log_test_helpers.dart';

void main() {
  late Directory tempDir;
  late Box<TaskRecord> box;
  late TaskRepository repository;
  late RecordingLogOutput logOutput;

  setUp(() async {
    tempDir = await Directory.systemTemp.createTemp('mova_hive_test_');
    Hive.init(tempDir.path);
    Hive.registerAdapters();
    box = await Hive.openBox<TaskRecord>(AppConstants.taskRecordsBoxName);
    logOutput = RecordingLogOutput();
    repository = TaskRepository(box, logger: buildTestLogger(logOutput));
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

  test(
    'watchRecentTasks emits inserted records in reverse createdAt order',
    () async {
      await repository.saveTask(
        _record(id: 'older', createdAt: DateTime(2026)),
      );

      final stream = repository.watchRecentTasks();
      expect((await stream.first).map((record) => record.id).toList(), [
        'older',
      ]);

      final nextSnapshot = _nextSnapshot(stream, () async {
        await repository.saveTask(
          _record(id: 'newer', createdAt: DateTime(2026, 1, 2)),
        );
      });

      final records = await nextSnapshot;
      expect(records.map((record) => record.id).toList(), ['newer', 'older']);
    },
  );

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

  test('saveTask and deleteTask write repository logs', () async {
    await repository.saveTask(
      _record(id: 'logged', createdAt: DateTime(2026, 1, 3)),
    );
    await repository.deleteTask('logged');

    expect(
      logOutput.lines.any(
        (line) => line.contains('taskRepository.save taskId=logged'),
      ),
      isTrue,
    );
    expect(
      logOutput.lines.any(
        (line) => line.contains('taskRepository.delete taskId=logged'),
      ),
      isTrue,
    );
  });

  test('loadTask returns the stored task by id', () async {
    final task = _record(id: 'task-42', createdAt: DateTime(2026, 1, 1));
    await repository.saveTask(task);

    expect(repository.loadTask('task-42')?.id, 'task-42');
    expect(repository.loadTask('missing'), isNull);
  });

  test('watchTask emits task updates and null after deletion', () async {
    await repository.saveTask(
      _record(id: 'focus', createdAt: DateTime(2026, 1, 1)),
    );

    final stream = repository.watchTask('focus');
    expect((await stream.first)?.status, TaskStatus.queued);

    final updatedSnapshot = _nextTaskSnapshot(stream, () async {
      await repository.saveTask(
        TaskRecord(
          id: 'focus',
          toolId: 'video.extractAudio',
          status: TaskStatus.succeeded,
          progress: 100,
          inputName: 'focus.mp4',
          outputPath: '/tmp/focus.mp3',
          createdAt: DateTime(2026, 1, 1),
          completedAt: DateTime(2026, 1, 1, 0, 1),
        ),
      );
    });
    expect((await updatedSnapshot)?.status, TaskStatus.succeeded);

    final deletedSnapshot = _nextTaskSnapshot(stream, () async {
      await repository.deleteTask('focus');
    });
    expect(await deletedSnapshot, isNull);
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

Future<TaskRecord?> _nextTaskSnapshot(
  Stream<TaskRecord?> stream,
  Future<void> Function() action,
) async {
  late StreamSubscription<TaskRecord?> subscription;
  final completer = Completer<TaskRecord?>();

  subscription = stream.skip(1).listen((record) async {
    await subscription.cancel();
    completer.complete(record);
  });

  await action();
  return completer.future;
}

TaskRecord _record({required String id, required DateTime createdAt}) {
  return TaskRecord(
    id: id,
    toolId: 'video.extractAudio',
    status: TaskStatus.queued,
    progress: 0,
    inputName: '$id.mp4',
    createdAt: createdAt,
  );
}
