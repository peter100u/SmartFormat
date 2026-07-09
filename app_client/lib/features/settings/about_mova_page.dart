import 'package:flutter/material.dart';

import '../../l10n/app_localizations.dart';

/// 展示应用简介和关于 Mova 的静态说明内容。
class AboutMovaPage extends StatelessWidget {
  const AboutMovaPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.settingsAboutMova)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text('Mova', style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 12),
          Text(
            l10n.aboutMovaDescription,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ],
      ),
    );
  }
}
