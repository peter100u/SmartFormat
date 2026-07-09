import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../tool_registry/mvp_tools.dart';
import '../tool_registry/tool_registry.dart';

final toolRegistryProvider = Provider<ToolRegistry>((ref) {
  return ToolRegistry(mvpTools);
});
