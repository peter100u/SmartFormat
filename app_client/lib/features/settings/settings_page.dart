import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/router.dart';
import '../../core/utils/file_size_formatter.dart';
import '../../l10n/app_localizations.dart';
import 'settings_controller.dart';

/// Mova 的设置与信任信息页面。
///
/// 边界：
/// - 这个页面用于承载产品文档中定义的 MVP 信任与维护入口。
/// - 反馈和缓存清理通过 controller 调用 service。
/// - 二级内容页面通过路由展示，而不是内联堆在一个页面里。
class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final state = ref.watch(settingsControllerProvider);
    final controller = ref.read(settingsControllerProvider.notifier);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.settingsTitle)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          SettingsSection(
            title: l10n.settingsGeneral,
            children: [
              SettingsTile(
                title: l10n.settingsLanguage,
                subtitle: '${l10n.languageChinese} / ${l10n.languageEnglish}',
                onTap: () => context.pushNamed(AppRoutes.settingsLanguage),
              ),
            ],
          ),
          SettingsSection(
            title: l10n.settingsSupport,
            children: [
              SettingsTile(
                title: l10n.settingsFeedback,
                subtitle: l10n.settingsFeedbackSubtitle,
                enabled: !state.isSendingFeedback,
                onTap: () async {
                  try {
                    await controller.sendFeedback();
                  } catch (_) {
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(l10n.feedbackUnavailableMessage),
                        ),
                      );
                    }
                  }
                },
              ),
            ],
          ),
          SettingsSection(
            title: l10n.settingsPrivacyAndLegal,
            children: [
              SettingsTile(
                title: l10n.settingsPrivacyPolicy,
                onTap: () => _openLegalDocument(context, 'privacy-policy'),
              ),
              SettingsTile(
                title: l10n.settingsUserAgreement,
                onTap: () => _openLegalDocument(context, 'user-agreement'),
              ),
              SettingsTile(
                title: l10n.settingsLicense,
                subtitle: l10n.settingsLicenseSubtitle,
                onTap: () => _openLegalDocument(context, 'license'),
              ),
            ],
          ),
          SettingsSection(
            title: l10n.settingsStorage,
            children: [
              SettingsTile(
                title: l10n.settingsClearCache,
                enabled: !state.isClearingCache,
                onTap: () => _confirmClearCache(context, ref, l10n),
              ),
            ],
          ),
          SettingsSection(
            title: l10n.settingsAboutSection,
            children: [
              SettingsTile(
                title: l10n.settingsAppVersion,
                onTap: () => context.pushNamed(AppRoutes.settingsAppVersion),
              ),
              SettingsTile(
                title: l10n.settingsAboutMova,
                onTap: () => context.pushNamed(AppRoutes.settingsAbout),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _openLegalDocument(BuildContext context, String documentType) {
    context.pushNamed(
      AppRoutes.settingsLegal,
      pathParameters: {'documentType': documentType},
    );
  }

  Future<void> _confirmClearCache(
    BuildContext context,
    WidgetRef ref,
    AppLocalizations l10n,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.cacheClearConfirmTitle),
        content: Text(l10n.cacheClearConfirmMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(l10n.cacheClearCancelledAction),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(l10n.cacheClearConfirmAction),
          ),
        ],
      ),
    );

    if (confirmed != true || !context.mounted) {
      return;
    }

    try {
      final result = await ref
          .read(settingsControllerProvider.notifier)
          .clearCache();
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              l10n.cacheClearSuccessMessage(
                formatFileSize(result.bytesRemoved),
              ),
            ),
          ),
        );
      }
    } catch (_) {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(l10n.cacheClearErrorMessage)));
      }
    }
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
          Card(
            clipBehavior: Clip.antiAlias,
            child: Column(children: children),
          ),
        ],
      ),
    );
  }
}

class SettingsTile extends StatelessWidget {
  const SettingsTile({
    required this.title,
    this.subtitle,
    this.onTap,
    this.enabled = true,
    super.key,
  });

  final String title;
  final String? subtitle;
  final VoidCallback? onTap;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      enabled: enabled,
      onTap: onTap,
      title: Text(title),
      subtitle: subtitle == null ? null : Text(subtitle!),
      trailing: const Icon(Icons.chevron_right),
    );
  }
}
