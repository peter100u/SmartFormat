import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_ce/hive_ce.dart';
import 'package:mova/core/constants/app_constants.dart';
import 'package:mova/data/repositories/task_repository.dart';
import 'package:mova/features/result/task_result_page.dart';
import 'package:mova/features/tasks/task_detail_page.dart';
import 'package:mova/features/tasks/tasks_page.dart';
import 'package:mova/l10n/app_localizations.dart';
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
  late RecordingOpenFileService openFileService;
  late RecordingShareService shareService;

  setUp(() async {
    tempDir = await Directory.systemTemp.createTemp('mova_task_pages_');
    Hive.init(tempDir.path);
    Hive.registerAdapters();
    box = await Hive.openBox<TaskRecord>(AppConstants.taskRecordsBoxName);
    repository = TaskRepository(box);
    openFileService = RecordingOpenFileService();
    shareService = RecordingShareService();
  });

  tearDown(() async {
    await box.close();
    await Hive.close();
    if (tempDir.existsSync()) {
      await tempDir.delete(recursive: true);
    }
  });

  testWidgets('tasks page shows the localized empty state', (tester) async {
    await tester.pumpWidget(buildTestApp(
      child: const TasksPage(),
      repository: repository,
      openFileService: openFileService,
      shareService: shareService,
    ));

    expect(find.text('No tasks yet'), findsOneWidget);
    expect(find.text('Finished conversions will appear here.'), findsOneWidget);
  });

  testWidgets('task detail page shows retry and delete actions for failed tasks', (
    tester,
  ) async {
    await repository.saveTask(
      TaskRecord(
        id: 'detail-task',
        toolId: 'video.convert',
        status: TaskStatus.failed,
        progress: 0,
        inputName: 'clip.mp4',
        inputPath: '/tmp/clip.mp4',
        outputPath: '/tmp/clip.mp4',
        errorMessage: 'ffmpeg failed',
        createdAt: DateTime(2026, 1, 1),
      ),
    );

    await tester.pumpWidget(buildTestApp(
      child: const TaskDetailPage(taskId: 'detail-task'),
      repository: repository,
      openFileService: openFileService,
      shareService: shareService,
    ));
    await tester.pumpAndSettle();

    expect(find.text('Retry'), findsOneWidget);
    expect(find.text('Delete'), findsOneWidget);
    expect(find.text('ffmpeg failed'), findsOneWidget);
  });

  testWidgets('tasks page lets the user cancel a running task from the list', (
    tester,
  ) async {
    await repository.saveTask(
      TaskRecord(
        id: 'running-task',
        toolId: 'video.convert',
        status: TaskStatus.running,
        progress: 44,
        inputName: 'clip.mp4',
        inputPath: '/tmp/clip.mp4',
        outputPath: '/tmp/clip.mp4',
        createdAt: DateTime(2026, 1, 1),
        startedAt: DateTime(2026, 1, 1, 0, 0, 1),
      ),
    );

    await tester.pumpWidget(buildTestApp(
      child: const TasksPage(),
      repository: repository,
      openFileService: openFileService,
      shareService: shareService,
    ));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Cancel'));
    await tester.pumpAndSettle();

    expect(repository.loadTask('running-task')?.status, TaskStatus.cancelled);
  });

  testWidgets('task result page opens and shares the stored output file', (
    tester,
  ) async {
    await repository.saveTask(
      TaskRecord(
        id: 'result-task',
        toolId: 'video.convert',
        status: TaskStatus.succeeded,
        progress: 100,
        inputName: 'clip.mp4',
        outputPath: '/tmp/result.mp4',
        createdAt: DateTime(2026, 1, 1),
        completedAt: DateTime(2026, 1, 1, 0, 1),
      ),
    );

    await tester.pumpWidget(buildTestApp(
      child: const TaskResultPage(taskId: 'result-task'),
      repository: repository,
      openFileService: openFileService,
      shareService: shareService,
    ));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Open'));
    await tester.pump();
    await tester.tap(find.text('Share'));
    await tester.pump();

    expect(openFileService.openedPaths, ['/tmp/result.mp4']);
    expect(shareService.sharedPaths, ['/tmp/result.mp4']);
  });
}

Widget buildTestApp({
  required Widget child,
  required TaskRepository repository,
  required RecordingOpenFileService openFileService,
  required RecordingShareService shareService,
}) {
  return ProviderScope(
    overrides: [
      taskRepositoryProvider.overrideWithValue(repository),
      taskRunnerProvider.overrideWithValue(RecordingTaskRunner(repository)),
      openFileServiceProvider.overrideWithValue(openFileService),
      shareServiceProvider.overrideWithValue(shareService),
    ],
    child: MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: child,
    ),
  );
}

class RecordingTaskRunner extends TaskRunner {
  RecordingTaskRunner(TaskRepository repository)
    : super(
        mediaService: const MediaService(),
        taskRepository: repository,
        commandBuilder: const CommandBuilder(),
      );

  @override
  Future<void> startTask(TaskRequest request) async {}
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
