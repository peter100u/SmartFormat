import '../../shared/models/media_file.dart';
import '../../shared/models/tool_models.dart';

class ToolState {
  const ToolState({
    required this.tool,
    required this.selectedPresetId,
    this.selectedFiles = const [],
    this.selectionSourceLabel,
    this.commandPreview,
    this.isStarting = false,
  });

  factory ToolState.initial(ToolDefinition tool) {
    return ToolState(tool: tool, selectedPresetId: tool.defaultPresetId);
  }

  final ToolDefinition tool;
  final String selectedPresetId;
  final List<MediaFile> selectedFiles;
  final String? selectionSourceLabel;
  final String? commandPreview;
  final bool isStarting;
}
