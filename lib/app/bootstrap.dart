import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kfs/app/app.dart';
import 'package:kfs/core/config/app_config.dart';
import 'package:kfs/core/config/flavor.dart';
import 'package:kfs/core/logging/app_logger.dart';
import 'package:logging/logging.dart';

/// Shared startup for every flavor entry point.
Future<void> bootstrap(Flavor flavor) async {
  WidgetsFlutterBinding.ensureInitialized();

  final config = AppConfig.fromEnvironment(flavor);
  setupLogging(flavor);
  final log = Logger('app')..info('Starting KFS (${flavor.name})');

  FlutterError.onError = (details) {
    log.severe('Flutter error', details.exception, details.stack);
    if (!flavor.isProduction) {
      FlutterError.presentError(details);
    }
  };
  PlatformDispatcher.instance.onError = (error, stack) {
    log.severe('Uncaught error', error, stack);
    return true;
  };

  // Riverpod 3 retries failed providers with exponential backoff by default;
  // override `retry` here (or per provider) when a feature needs otherwise.
  runApp(
    ProviderScope(
      overrides: [appConfigProvider.overrideWithValue(config)],
      child: const KfsApp(),
    ),
  );
}
