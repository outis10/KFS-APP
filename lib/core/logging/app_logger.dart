import 'dart:developer' as developer;

import 'package:kfs/core/config/flavor.dart';
import 'package:logging/logging.dart';

/// Configures the root logger once at startup.
///
/// Rule: never log tokens, passwords or client personal data.
void setupLogging(Flavor flavor) {
  Logger.root.level = flavor.isProduction ? Level.INFO : Level.ALL;
  Logger.root.onRecord.listen((record) {
    developer.log(
      record.message,
      time: record.time,
      level: record.level.value,
      name: record.loggerName,
      error: record.error,
      stackTrace: record.stackTrace,
    );
  });
}
