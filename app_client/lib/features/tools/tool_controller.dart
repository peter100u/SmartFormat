import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../shared/providers/tool_providers.dart';
import 'tool_state.dart';

final toolFlowControllerProvider =
    NotifierProvider.family<ToolFlowController, ToolState, String>(
      ToolFlowController.new,
    );

/// Handles the tool-detail flow state for one selected MVP tool.
///
/// Boundary:
/// - UI calls this controller for preset changes, input selection, and start.
/// - File/photo/permission/task side effects go through services and TaskRunner.
/// - The controller is the only place that should mutate ToolState.
class ToolFlowController extends Notifier<ToolState> {
  ToolFlowController(this.toolId);

  final String toolId;

  @override
  ToolState build() {
    final tool = ref.watch(toolRegistryProvider).requireById(toolId);
    return ToolState.initial(tool);
  }

  void updatePreset(String presetId) {
    state = ToolState(tool: state.tool, selectedPresetId: presetId);
  }

  Future<void> selectFiles() async {
    // TODO(mvp): Request permissions, pick files/assets, preflight them, and
    // store selected MediaFile values in ToolState.
  }

  Future<void> startTasks() async {
    // TODO(mvp): Create one task per selected input, run TaskRunner, then route
    // to the result page or task list when processing begins/completes.
    state = ToolState(
      tool: state.tool,
      selectedPresetId: state.selectedPresetId,
      isStarting: true,
    );
    state = ToolState.initial(state.tool);
  }
}
