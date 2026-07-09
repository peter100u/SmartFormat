import 'package:flutter_riverpod/flutter_riverpod.dart';

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
    state = ToolState(tool: state.tool, selectedPresetId: presetId);
  }

  Future<void> selectFiles() async {
    // TODO(mvp): 请求权限、选择文件或资源、执行预检，
    // 并把选中的 `MediaFile` 保存到 `ToolState` 中。
  }

  Future<void> startTasks() async {
    // TODO(mvp): 为每个已选输入创建任务并交给 `TaskRunner` 执行，
    // 然后在处理开始或完成后跳转到结果页或任务列表页。
    state = ToolState(
      tool: state.tool,
      selectedPresetId: state.selectedPresetId,
      isStarting: true,
    );
    state = ToolState.initial(state.tool);
  }
}
