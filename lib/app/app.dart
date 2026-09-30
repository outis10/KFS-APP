import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kfs/app/router.dart';
import 'package:kfs/app/theme.dart';
import 'package:kfs/l10n/app_localizations.dart';

class KfsApp extends ConsumerWidget {
  const KfsApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp.router(
      onGenerateTitle: (context) => AppLocalizations.of(context).appTitle,
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      routerConfig: ref.watch(routerProvider),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      // Spanish (Mexico) is the product language; fall back to it.
      localeResolutionCallback: (locale, supported) {
        for (final candidate in supported) {
          if (candidate.languageCode == locale?.languageCode) {
            return candidate;
          }
        }
        return const Locale('es');
      },
      debugShowCheckedModeBanner: false,
    );
  }
}
