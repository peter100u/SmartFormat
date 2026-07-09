import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

import '../../shared/models/media_file.dart';
import '../../shared/models/task_models.dart';
import '../../shared/models/tool_models.dart';
import '../../shared/providers/service_providers.dart';
import '../../shared/providers/tool_providers.dart';
import 'tool_state.dart';

final toolFlowControllerProvider =
    NotifierProvider.family<ToolFlowController, ToolState, String>(
      ToolFlowController.new,
    );

/// 管理单个已选 MVP 工具的详情流程状态。
///
/// 边界：
/// - UI 通过这个 controller 处理预设切换、输入选择和开始执行。
/// - 文件、相册、权限、任务等副作用应通过 service 和 `TaskRunner` 完成。
/// - 只有这个 controller 可以修改 `ToolState`。
class ToolFlowController extends Notifier<ToolState> {
  ToolFlowController(this.toolId);

  final String toolId;

  @override
  ToolState build() {
    final tool = ref.watch(toolRegistryProvider).requireById(toolId);
    return ToolState.initial(tool);
  }

  void updatePreset(String presetId) {
    state = ToolState(
      tool: state.tool,
      selectedPresetId: presetId,
      selectedFiles: state.selectedFiles,
      selectionSourceLabel: state.selectionSourceLabel,
      commandPreview: _buildCommandPreview(
        selectedFiles: state.selectedFiles,
        selectedPresetId: presetId,
      ),
    );
  }

  Future<void> selectFiles() async {
    final pickedFiles = await ref.read(fileServiceProvider).pickFiles();
    final selectedFiles = state.tool.allowMultipleInputs
        ? pickedFiles
        : pickedFiles.take(1).toList(growable: false);
    state = ToolState(
      tool: state.tool,
      selectedPresetId: state.selectedPresetId,
      selectedFiles: selectedFiles,
      selectionSourceLabel: _buildSelectionSourceLabel(selectedFiles),
      commandPreview: _buildCommandPreview(
        selectedFiles: selectedFiles,
        selectedPresetId: state.selectedPresetId,
      ),
    );
  }

  Future<void> startTasks() async {
    if (state.selectedFiles.isEmpty) {
      return;
    }

    state = ToolState(
      tool: state.tool,
      selectedPresetId: state.selectedPresetId,
      selectedFiles: state.selectedFiles,
      selectionSourceLabel: state.selectionSourceLabel,
      commandPreview: state.commandPreview,
      isStarting: true,
    );

    final preset = state.tool.presets.firstWhere(
      (item) => item.id == state.selectedPresetId,
      orElse: () => state.tool.presets.first,
    );
    try {
      final requests = await _buildRequests(preset);
      await ref.read(taskRunnerProvider).startTasks(requests);
    } finally {
      state = ToolState.initial(state.tool);
    }
  }

  Future<List<TaskRequest>> _buildRequests(ToolPreset preset) async {
    final tempDirectory = await getTemporaryDirectory();
    final now = DateTime.now();

    return [
      for (var index = 0; index < state.selectedFiles.length; index++)
        TaskRequest(
          id: '${state.tool.id}_${state.selectedFiles[index].id}_${now.microsecondsSinceEpoch}_$index',
          toolId: state.tool.id,
          input: state.selectedFiles[index],
          presetId: preset.id,
          outputTarget: OutputTarget.appResult,
          outputPath: _buildOutputPath(
            tempDirectory.path,
            state.selectedFiles[index],
            preset.outputExtension,
          ),
          parameters: preset.parameters,
          createdAt: now,
        ),
    ];
  }

  String _buildOutputPath(
    String directoryPath,
    MediaFile file,
    String outputExtension,
  ) {
    final originalPath = file.path;
    final baseName = originalPath == null
        ? file.displayName
        : path.basenameWithoutExtension(originalPath);
    final normalizedBaseName = baseName.replaceAll(RegExp(r'[^\w\-]+'), '_');
    return path.join(
      directoryPath,
      '${normalizedBaseName}_${file.id}.$outputExtension',
    );
  }

  String? _buildSelectionSourceLabel(List<MediaFile> files) {
    if (files.isEmpty) {
      return null;
    }
    final hasPicker = files.any(
      (file) => file.source == InputSource.filePicker,
    );
    final hasLibrary = files.any(
      (file) => file.source == InputSource.photoLibrary,
    );
    if (hasPicker && hasLibrary) {
      return '文件和相册';
    }
    if (hasLibrary) {
      return '相册';
    }
    return '文件';
  }

  String? _buildCommandPreview({
    required List<MediaFile> selectedFiles,
    required String selectedPresetId,
  }) {
    if (selectedFiles.isEmpty) {
      return null;
    }
    final preset = state.tool.presets.firstWhere(
      (item) => item.id == selectedPresetId,
      orElse: () => state.tool.presets.first,
    );
    final firstFile = selectedFiles.first;
    final inputPath = firstFile.path;
    if (inputPath == null || inputPath.isEmpty) {
      return null;
    }
    final previewRequest = TaskRequest(
      id: 'preview',
      toolId: state.tool.id,
      input: firstFile,
      presetId: preset.id,
      outputTarget: OutputTarget.appResult,
      outputPath: _buildOutputPath(
        path.dirname(inputPath),
        firstFile,
        preset.outputExtension,
      ),
      parameters: preset.parameters,
      createdAt: DateTime.now(),
    );
    return ref.read(commandBuilderProvider).build(previewRequest).join(' ');
  }
}
