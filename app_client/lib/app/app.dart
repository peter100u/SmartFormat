import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../shared/providers/app_preferences_providers.dart';
import 'router.dart';
import 'theme.dart';
import '../l10n/app_localizations.dart';

class MovaApp extends ConsumerWidget {
  const MovaApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);
    final localeState = ref.watch(appLocaleControllerProvider);
    final locale = localeState is AsyncData<Locale> ? localeState.value : null;

    return MaterialApp.router(
      title: 'Mova',
      debugShowCheckedModeBanner: false,
      theme: buildLightTheme(),
      routerConfig: router,
      locale: locale,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
    );
  }
}
