import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'tool_controller.dart';

class ToolDetailPage extends ConsumerWidget {
  const ToolDetailPage({required this.toolId, super.key});

  final String toolId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(toolFlowControllerProvider(toolId));
    final controller = ref.read(toolFlowControllerProvider(toolId).notifier);

    return Scaffold(
      appBar: AppBar(title: Text(state.tool.title)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            state.tool.description,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: 20),
          FilledButton.icon(
            onPressed: state.isStarting ? null : controller.selectFiles,
            icon: const Icon(Icons.file_open_outlined),
            label: const Text('选择文件'),
          ),
          if (state.selectedFiles.isNotEmpty) ...[
            const SizedBox(height: 16),
            Text('已选文件', style: Theme.of(context).textTheme.titleMedium),
            if (state.selectionSourceLabel != null) ...[
              const SizedBox(height: 4),
              Text('来源：${state.selectionSourceLabel}'),
            ],
            const SizedBox(height: 8),
            for (final file in state.selectedFiles)
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.insert_drive_file_outlined),
                title: Text(file.displayName),
                subtitle: Text(file.path ?? '仅保留文件句柄'),
              ),
          ],
          if (state.commandPreview != null) ...[
            const SizedBox(height: 16),
            Text('命令预览', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            SelectableText(state.commandPreview!),
          ],
          const SizedBox(height: 16),
          Text('推荐参数', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          RadioGroup<String>(
            groupValue: state.selectedPresetId,
            onChanged: (value) {
              if (value != null) {
                controller.updatePreset(value);
              }
            },
            child: Column(
              children: [
                for (final preset in state.tool.presets)
                  RadioListTile<String>(
                    value: preset.id,
                    title: Text(preset.title),
                    subtitle: Text('输出 .${preset.outputExtension}'),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          FilledButton(
            onPressed: state.isStarting || state.selectedFiles.isEmpty
                ? null
                : controller.startTasks,
            child: const Text('开始任务'),
          ),
        ],
      ),
    );
  }
}
