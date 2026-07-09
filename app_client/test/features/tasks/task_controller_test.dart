import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_ce/hive_ce.dart';
import 'package:mova/core/constants/app_constants.dart';
import 'package:mova/data/repositories/task_repository.dart';
import 'package:mova/features/tasks/task_controller.dart';
import 'package:mova/services/command_builder.dart';
import 'package:mova/services/media_service.dart';
import 'package:mova/services/open_file_service.dart';
import 'package:mova/services/share_service.dart';
import 'package:mova/services/task_runner.dart';
import 'package:mova/shared/models/hive_registrar.g.dart';
import 'package:mova/shared/models/task_models.dart';
import 'package:mova/shared/models/tool_models.dart';
import 'package:mova/shared/providers/repository_providers.dart';
import 'package:mova/shared/providers/service_providers.dart';

void main() {
  late Directory tempDir;
  late Box<TaskRecord> box;
  late TaskRepository repository;
  late ProviderContainer container;
  late RecordingTaskRunner runner;
  late RecordingOpenFileService openFileService;
  late RecordingShareService shareService;

  setUp(() async {
    tempDir = await Directory.systemTemp.createTemp('mova_task_controller_');
    Hive.init(tempDir.path);
    Hive.registerAdapters();
    box = await Hive.openBox<TaskRecord>(AppConstants.taskRecordsBoxName);
    repository = TaskRepository(box);
    runner = RecordingTaskRunner(repository);
    openFileService = RecordingOpenFileService();
    shareService = RecordingShareService();
    container = ProviderContainer(
      overrides: [
        taskRepositoryProvider.overrideWithValue(repository),
        taskRunnerProvider.overrideWithValue(runner),
        openFileServiceProvider.overrideWithValue(openFileService),
        shareServiceProvider.overrideWithValue(shareService),
      ],
    );
  });

  tearDown(() async {
    container.dispose();
    await box.close();
    await Hive.close();
    if (tempDir.existsSync()) {
      await tempDir.delete(recursive: true);
    }
  });

  test('task list controller reflects repository updates', () async {
    container.read(taskListControllerProvider);

    await repository.saveTask(
      TaskRecord(
        id: 'task-1',
        toolId: 'video.convert',
        status: TaskStatus.queued,
        progress: 0,
        inputName: 'clip.mp4',
        createdAt: DateTime(2026, 1, 1),
      ),
    );

    await Future<void>.delayed(const Duration(milliseconds: 10));

    final state = container.read(taskListControllerProvider);
    expect(state.tasks, hasLength(1));
    expect(state.tasks.single.inputName, 'clip.mp4');
  });

  test('cancelTask persists a cancelled record when task exists', () async {
    final controller = container.read(taskListControllerProvider.notifier);
    await repository.saveTask(
      TaskRecord(
        id: 'task-cancel',
        toolId: 'video.convert',
        status: TaskStatus.running,
        progress: 44,
        inputName: 'clip.mp4',
        inputPath: '/tmp/clip.mp4',
        outputPath: '/tmp/clip.mp3',
        createdAt: DateTime(2026, 1, 1),
        startedAt: DateTime(2026, 1, 1, 0, 0, 1),
      ),
    );

    final didCancel = await controller.cancelTask('task-cancel');

    final record = repository.loadTask('task-cancel');
    expect(didCancel, isTrue);
    expect(record?.status, TaskStatus.cancelled);
    expect(record?.errorCode, TaskErrorCode.cancelled.name);
    expect(record?.completedAt, isNotNull);
  });

  test('retryTask rebuilds a request from the stored record', () async {
    final controller = container.read(taskListControllerProvider.notifier);
    await repository.saveTask(
      TaskRecord(
        id: 'task-retry',
        toolId: 'video.extractAudio',
        status: TaskStatus.failed,
        progress: 0,
        inputName: 'clip.mp4',
        inputPath: '/tmp/clip.mp4',
        outputPath: '/tmp/clip.mp3',
        createdAt: DateTime(2026, 1, 1),
        completedAt: DateTime(2026, 1, 1, 0, 1),
      ),
    );

    final didRetry = await controller.retryTask('task-retry');

    expect(didRetry, isTrue);
    expect(runner.startedRequests, hasLength(1));
    expect(runner.startedRequests.single.id, 'task-retry');
    expect(runner.startedRequests.single.input.path, '/tmp/clip.mp4');
    expect(runner.startedRequests.single.outputPath, '/tmp/clip.mp3');
  });

  test('deleteTask removes the stored task', () async {
    final controller = container.read(taskListControllerProvider.notifier);
    await repository.saveTask(
      TaskRecord(
        id: 'task-delete',
        toolId: 'video.convert',
        status: TaskStatus.failed,
        progress: 0,
        inputName: 'clip.mp4',
        createdAt: DateTime(2026, 1, 1),
      ),
    );

    final didDelete = await controller.deleteTask('task-delete');

    expect(didDelete, isTrue);
    expect(repository.loadTask('task-delete'), isNull);
  });

  test('openTaskResult forwards the output path to the open file service', () async {
    final controller = container.read(taskListControllerProvider.notifier);
    await repository.saveTask(
      TaskRecord(
        id: 'task-open',
        toolId: 'video.convert',
        status: TaskStatus.succeeded,
        progress: 100,
        inputName: 'clip.mp4',
        outputPath: '/tmp/open.mp4',
        createdAt: DateTime(2026, 1, 1),
      ),
    );

    final didOpen = await controller.openTaskResult('task-open');

    expect(didOpen, isTrue);
    expect(openFileService.openedPaths, ['/tmp/open.mp4']);
  });

  test('shareTaskResult forwards the output path to the share service', () async {
    final controller = container.read(taskListControllerProvider.notifier);
    await repository.saveTask(
      TaskRecord(
        id: 'task-share',
        toolId: 'video.convert',
        status: TaskStatus.succeeded,
        progress: 100,
        inputName: 'clip.mp4',
        outputPath: '/tmp/share.mp4',
        createdAt: DateTime(2026, 1, 1),
      ),
    );

    final didShare = await controller.shareTaskResult('task-share');

    expect(didShare, isTrue);
    expect(shareService.sharedPaths, ['/tmp/share.mp4']);
  });
}

class RecordingTaskRunner extends TaskRunner {
  RecordingTaskRunner(TaskRepository repository)
    : super(
        mediaService: const MediaService(),
        taskRepository: repository,
        commandBuilder: const CommandBuilder(),
      );

  final List<TaskRequest> startedRequests = [];

  @override
  Future<void> startTask(TaskRequest request) async {
    startedRequests.add(request);
  }
}

class RecordingOpenFileService extends OpenFileService {
  final List<String> openedPaths = [];

  @override
  Future<void> open(String path) async {
    openedPaths.add(path);
  }
}

class RecordingShareService extends ShareService {
  final List<String> sharedPaths = [];

  @override
  Future<void> shareFile(String path) async {
    sharedPaths.add(path);
  }
}
