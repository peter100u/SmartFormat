import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:hive_ce/hive_ce.dart';
import 'package:mova/core/constants/app_constants.dart';
import 'package:mova/data/repositories/task_repository.dart';
import 'package:mova/services/command_builder.dart';
import 'package:mova/services/media_service.dart';
import 'package:mova/services/task_runner.dart';
import 'package:mova/shared/models/hive_registrar.g.dart';
import 'package:mova/shared/models/media_file.dart';
import 'package:mova/shared/models/task_models.dart';
import 'package:mova/shared/models/tool_models.dart';

import '../support/log_test_helpers.dart';

void main() {
  late Directory tempDir;
  late Box<TaskRecord> box;
  late TaskRepository repository;
  late RecordingLogOutput logOutput;

  setUp(() async {
    tempDir = await Directory.systemTemp.createTemp('mova_task_runner_');
    Hive.init(tempDir.path);
    Hive.registerAdapters();
    box = await Hive.openBox<TaskRecord>(AppConstants.taskRecordsBoxName);
    repository = TaskRepository(box);
    logOutput = RecordingLogOutput();
  });

  tearDown(() async {
    await box.close();
    await Hive.close();
    if (tempDir.existsSync()) {
      await tempDir.delete(recursive: true);
    }
  });

  test('startTask persists running and succeeded task states', () async {
    final runner = TaskRunner(
      mediaService: FakeRunnerMediaService(
        events: [
          const TaskProgress(
            taskId: '',
            status: TaskStatus.running,
            progress: 0.45,
            elapsed: Duration(seconds: 2),
          ),
          const TaskProgress(
            taskId: '',
            status: TaskStatus.succeeded,
            progress: 1,
            elapsed: Duration(seconds: 5),
            message: 'done',
          ),
        ],
      ),
      taskRepository: repository,
      commandBuilder: const FakeRunnerCommandBuilder(),
      logger: buildTestLogger(logOutput),
    );

    await runner.startTask(_request());

    final record = box.get('task-1');
    expect(record, isNotNull);
    expect(record!.status, TaskStatus.succeeded);
    expect(record.progress, 100);
    expect(record.outputPath, '/tmp/output.mp3');
    expect(record.startedAt, isNotNull);
    expect(record.completedAt, isNotNull);
    expect(record.logSummary, 'done');
    expect(
      logOutput.lines.any((line) => line.contains('task.start taskId=task-1')),
      isTrue,
    );
    expect(
      logOutput.lines.any(
        (line) =>
            line.contains('task.progress taskId=task-1') &&
            line.contains('status=succeeded'),
      ),
      isTrue,
    );
  });

  test('startTask persists failed task state and failure summary', () async {
    final runner = TaskRunner(
      mediaService: FakeRunnerMediaService(
        events: const [
          TaskProgress(
            taskId: '',
            status: TaskStatus.failed,
            progress: 0,
            message: 'ffmpeg failed',
          ),
        ],
      ),
      taskRepository: repository,
      commandBuilder: const FakeRunnerCommandBuilder(),
      logger: buildTestLogger(logOutput),
    );

    await runner.startTask(_request(id: 'task-2'));

    final record = box.get('task-2');
    expect(record, isNotNull);
    expect(record!.status, TaskStatus.failed);
    expect(record.errorMessage, 'ffmpeg failed');
    expect(record.logSummary, 'ffmpeg failed');
    expect(record.completedAt, isNotNull);
    expect(
      logOutput.lines.any(
        (line) =>
            line.contains('task.progress taskId=task-2') &&
            line.contains('status=failed'),
      ),
      isTrue,
    );
  });
}

TaskRequest _request({String id = 'task-1'}) {
  return TaskRequest(
    id: id,
    toolId: 'video.extractAudio',
    input: const MediaFile(
      id: 'file-1',
      displayName: 'clip.mp4',
      path: '/tmp/clip.mp4',
      kind: MediaKind.video,
      source: InputSource.filePicker,
    ),
    presetId: 'mp3',
    outputTarget: OutputTarget.appResult,
    outputPath: '/tmp/output.mp3',
    parameters: const {'audioBitrate': '192k'},
    createdAt: DateTime(2026, 1, 1),
  );
}

class FakeRunnerMediaService extends MediaService {
  FakeRunnerMediaService({required this.events});

  final List<TaskProgress> events;

  @override
  Stream<TaskProgress> execute(List<String> command) async* {
    for (final event in events) {
      yield event;
    }
  }
}

class FakeRunnerCommandBuilder extends CommandBuilder {
  const FakeRunnerCommandBuilder();

  @override
  List<String> build(TaskRequest request) {
    return ['-i', request.input.path ?? '', request.outputPath];
  }
}
