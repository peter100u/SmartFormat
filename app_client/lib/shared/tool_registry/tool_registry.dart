import '../models/tool_models.dart';

class ToolRegistry {
  ToolRegistry(List<ToolDefinition> tools) : _tools = List.unmodifiable(tools);

  final List<ToolDefinition> _tools;

  List<ToolDefinition> get all => _tools;

  List<ToolDefinition> byCategory(MediaKind category) {
    return _tools.where((tool) => tool.category == category).toList();
  }

  ToolDefinition? findById(String id) {
    for (final tool in _tools) {
      if (tool.id == id) {
        return tool;
      }
    }
    return null;
  }

  ToolDefinition requireById(String id) {
    final tool = findById(id);
    if (tool == null) {
      throw ArgumentError.value(id, 'id', 'Unknown Mova tool id');
    }
    return tool;
  }
}
