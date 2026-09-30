import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kfs/core/config/app_config.dart';
import 'package:kfs/core/config/flavor.dart';
import 'package:kfs/core/storage/secure_store.dart';
import 'package:kfs/l10n/app_localizations.dart';

const testConfig = AppConfig(
  flavor: Flavor.dev,
  studioBaseUrl: 'http://studio.test',
);

/// Riverpod 3 retries failed providers automatically; tests disable it so
/// error states are observable deterministically.
Duration? noRetry(int retryCount, Object error) => null;

/// Default overrides for widget tests: test config and in-memory secrets.
List<Override> baseOverrides() => [
  appConfigProvider.overrideWithValue(testConfig),
  secureStoreProvider.overrideWithValue(MemorySecureStore()),
];

extension PumpApp on WidgetTester {
  /// Pumps [widget] inside MaterialApp with localizations (Spanish).
  Future<void> pumpLocalized(
    Widget widget, {
    List<Override> overrides = const [],
  }) {
    return pumpWidget(
      ProviderScope(
        retry: noRetry,
        overrides: [...baseOverrides(), ...overrides],
        child: MaterialApp(
          locale: const Locale('es'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: widget,
        ),
      ),
    );
  }
}
