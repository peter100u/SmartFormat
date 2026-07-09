import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../l10n/app_localizations.dart';
import '../../shared/providers/service_providers.dart';

/// 展示当前应用版本、构建号和包名信息。
class AppVersionPage extends ConsumerWidget {
  const AppVersionPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.settingsAppVersion)),
      body: FutureBuilder(
        future: ref.read(appInfoServiceProvider).load(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final appInfo = snapshot.data!;
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              ListTile(
                title: Text(l10n.appVersionLabel),
                subtitle: Text(appInfo.version),
              ),
              ListTile(
                title: Text(l10n.appBuildNumberLabel),
                subtitle: Text(appInfo.buildNumber),
              ),
              ListTile(
                title: Text(l10n.appPackageNameLabel),
                subtitle: Text(appInfo.packageName),
              ),
            ],
          );
        },
      ),
    );
  }
}
