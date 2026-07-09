import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/router.dart';
import '../../shared/models/tool_models.dart';
import '../../shared/providers/tool_providers.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final registry = ref.watch(toolRegistryProvider);

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Mova'),
          bottom: const TabBar(
            tabs: [
              Tab(text: '视频'),
              Tab(text: '音频'),
              Tab(text: '图片'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            ToolList(tools: registry.byCategory(MediaKind.video)),
            ToolList(tools: registry.byCategory(MediaKind.audio)),
            ToolList(tools: registry.byCategory(MediaKind.image)),
          ],
        ),
      ),
    );
  }
}

class ToolList extends StatelessWidget {
  const ToolList({required this.tools, super.key});

  final List<ToolDefinition> tools;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemBuilder: (context, index) => ToolCard(tool: tools[index]),
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemCount: tools.length,
    );
  }
}

class ToolCard extends StatelessWidget {
  const ToolCard({required this.tool, super.key});

  final ToolDefinition tool;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: () => context.pushNamed(
          AppRoutes.toolDetail,
          pathParameters: {'toolId': tool.id},
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      tool.title,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                  const Icon(Icons.chevron_right),
                ],
              ),
              const SizedBox(height: 6),
              Text(tool.description),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  for (final tag in tool.tags)
                    Chip(
                      label: Text(tag),
                      visualDensity: VisualDensity.compact,
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
