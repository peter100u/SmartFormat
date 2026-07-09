import 'package:flutter/material.dart';

/// Settings and trust surface for Mova.
///
/// Boundary:
/// - This page lists MVP trust and maintenance entries from the product docs.
/// - Feedback, cache cleanup, legal pages, and app-info loading need controllers/services.
/// - Static tiles here are placeholders until those flows are wired.
class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('设置')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          SettingsSection(
            title: '通用',
            children: [SettingsTile(title: '多语言', subtitle: '中文 / English')],
          ),
          // TODO(mvp): Wire language selection to persisted locale preferences.
          SettingsSection(
            title: '支持',
            children: [SettingsTile(title: '意见反馈', subtitle: '发送问题和建议')],
          ),
          // TODO(mvp): Connect feedback to FeedbackService and failed-task context.
          SettingsSection(
            title: '隐私与法律',
            children: [
              SettingsTile(title: '隐私政策'),
              SettingsTile(title: '用户协议'),
              SettingsTile(title: '许可证', subtitle: '开源组件、FFmpegKit 和第三方许可说明'),
            ],
          ),
          // TODO(mvp): Add privacy policy, user agreement, and license disclosure pages.
          SettingsSection(
            title: '存储',
            children: [SettingsTile(title: '清理缓存')],
          ),
          // TODO(mvp): Add cache size calculation and safe temporary-result cleanup.
          SettingsSection(
            title: '关于',
            children: [
              SettingsTile(title: 'App 版本', subtitle: '1.0.0'),
              SettingsTile(title: '关于 Mova'),
            ],
          ),
          // TODO(mvp): Load app version from AppInfoService and add About Mova content.
        ],
      ),
    );
  }
}

class SettingsSection extends StatelessWidget {
  const SettingsSection({
    required this.title,
    required this.children,
    super.key,
  });

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 4, bottom: 8),
            child: Text(title, style: Theme.of(context).textTheme.labelLarge),
          ),
          Card(child: Column(children: children)),
        ],
      ),
    );
  }
}

class SettingsTile extends StatelessWidget {
  const SettingsTile({required this.title, this.subtitle, super.key});

  final String title;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title),
      subtitle: subtitle == null ? null : Text(subtitle!),
      trailing: const Icon(Icons.chevron_right),
    );
  }
}
