import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../l10n/app_localizations.dart';
import '../../shared/providers/app_preferences_providers.dart';

/// 展示应用内语言选择项，并将选择结果持久化。
class LanguageSettingsPage extends ConsumerWidget {
  const LanguageSettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final localeState = ref.watch(appLocaleControllerProvider);
    final locale = localeState is AsyncData<Locale>
        ? localeState.value
        : const Locale('zh');
    final controller = ref.read(appLocaleControllerProvider.notifier);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.settingsLanguage)),
      body: ListView(
        children: [
          RadioGroup<String>(
            groupValue: locale.languageCode,
            onChanged: (value) {
              if (value == null) {
                return;
              }
              controller.setLocale(Locale(value));
            },
            child: Column(
              children: [
                RadioListTile<String>(
                  value: 'zh',
                  title: Text(l10n.languageChinese),
                ),
                RadioListTile<String>(
                  value: 'en',
                  title: Text(l10n.languageEnglish),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
