import '../../shared/models/tool_models.dart';

class ToolState {
  const ToolState({
    required this.tool,
    required this.selectedPresetId,
    this.isStarting = false,
  });

  factory ToolState.initial(ToolDefinition tool) {
    return ToolState(tool: tool, selectedPresetId: tool.defaultPresetId);
  }

  final ToolDefinition tool;
  final String selectedPresetId;
  final bool isStarting;
}
