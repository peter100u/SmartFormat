import 'package:hive_ce/hive_ce.dart';

import 'task_models.dart';
import 'tool_models.dart';

@GenerateAdapters([
  AdapterSpec<TaskRecord>(),
  AdapterSpec<TaskStatus>(),
], firstTypeId: 32)
part 'task_hive_adapters.g.dart';
