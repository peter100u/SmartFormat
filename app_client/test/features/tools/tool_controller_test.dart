import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:hive_ce/hive_ce.dart';
import 'package:mova/core/constants/app_constants.dart';
import 'package:mova/data/repositories/task_repository.dart';
import 'package:mova/features/tools/tool_controller.dart';
import 'package:mova/shared/models/hive_registrar.g.dart';
import 'package:mova/shared/models/media_file.dart';
import 'package:mova/shared/models/task_models.dart';
import 'package:mova/shared/models/tool_models.dart';
import 'package:mova/shared/providers/repository_providers.dart';
import 'package:mova/shared/providers/service_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mova/services/command_builder.dart';
import 'package:mova/services/file_service.dart';
import 'package:mova/services/media_service.dart';
import 'package:mova/services/task_runner.dart';

void main() {
  late Directory tempDir;
  late Box<TaskRecord> box;
  late ProviderContainer container;
  late FakeTaskRunner taskRunner;

  setUp(() async {
    tempDir = await Directory.systemTemp.createTemp('mova_tool_controller_');
    Hive.init(tempDir.path);
    Hive.registerAdapters();
    box = await Hive.openBox<TaskRecord>(AppConstants.taskRecordsBoxName);
    final repository = TaskRepository(box);
    taskRunner = FakeTaskRunner();

    container = ProviderContainer(
      overrides: [
        taskRepositoryProvider.overrideWithValue(repository),
        taskRunnerProvider.overrideWithValue(taskRunner),
        fileServiceProvider.overrideWithValue(
          FakeFileService([
            const MediaFile(
              id: 'file-1',
              displayName: 'clip.mp4',
              path: '/tmp/clip.mp4',
              kind: MediaKind.video,
              source: InputSource.filePicker,
            ),
            const MediaFile(
              id: 'file-2',
              displayName: 'clip-2.mp4',
              path: '/tmp/clip-2.mp4',
              kind: MediaKind.video,
              source: InputSource.filePicker,
            ),
          ]),
        ),
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

  test('selectFiles stores the picked files in tool state', () async {
    await container
        .read(toolFlowControllerProvider('video.convert').notifier)
        .selectFiles();

    final state = container.read(toolFlowControllerProvider('video.convert'));
    expect(state.selectedFiles.map((file) => file.displayName).toList(), [
      'clip.mp4',
      'clip-2.mp4',
    ]);
    expect(state.selectionSourceLabel, '文件');
    expect(state.commandPreview, contains('-c:v mpeg4'));
    expect(state.commandPreview, contains('clip_file-1.mp4'));
  });

  test('startTasks sends built task requests to task runner', () async {
    final controller = container.read(
      toolFlowControllerProvider('video.extractAudio').notifier,
    );

    await controller.selectFiles();
    await controller.startTasks();

    expect(taskRunner.startedRequests, hasLength(2));
    expect(
      taskRunner.startedRequests.map((request) => request.input.displayName),
      ['clip.mp4', 'clip-2.mp4'],
    );
    expect(
      taskRunner.startedRequests.every(
        (request) => request.toolId == 'video.extractAudio',
      ),
      isTrue,
    );
    expect(
      taskRunner.startedRequests.map((request) => request.outputPath).toList(),
      everyElement(contains('.mp3')),
    );
    expect(
      container
          .read(toolFlowControllerProvider('video.extractAudio'))
          .selectedFiles,
      isEmpty,
    );
  });
}

class FakeFileService extends FileService {
  FakeFileService(this._files);

  final List<MediaFile> _files;

  @override
  Future<List<MediaFile>> pickFiles() async {
    return _files;
  }
}

class FakeTaskRunner extends TaskRunner {
  FakeTaskRunner()
    : super(
        mediaService: const MediaService(),
        taskRepository: TaskRepository(
          Hive.box<TaskRecord>(AppConstants.taskRecordsBoxName),
        ),
        commandBuilder: const CommandBuilder(),
      );

  final List<TaskRequest> startedRequests = [];

  @override
  Future<void> startTasks(Iterable<TaskRequest> requests) async {
    startedRequests.addAll(requests);
  }
}
