import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kfs/core/config/flavor.dart';

/// Runtime configuration resolved at startup.
///
/// Values come from `--dart-define-from-file=env/<flavor>.json`; nothing
/// secret belongs here (the repository is public and values are embedded in
/// the binary).
class AppConfig {
  const AppConfig({
    required this.flavor,
    required this.studioBaseUrl,
    this.connectTimeout = const Duration(seconds: 15),
    this.receiveTimeout = const Duration(seconds: 60),
  });

  factory AppConfig.fromEnvironment(Flavor flavor) {
    const baseUrl = String.fromEnvironment('STUDIO_BASE_URL');
    return AppConfig(
      flavor: flavor,
      studioBaseUrl: baseUrl.isEmpty ? defaultStudioBaseUrl : baseUrl,
    );
  }

  /// Android emulator loopback to the host machine (Studio on :8080).
  static const defaultStudioBaseUrl = 'http://10.0.2.2:8080';

  final Flavor flavor;
  final String studioBaseUrl;
  final Duration connectTimeout;
  final Duration receiveTimeout;
}

/// Overridden in `bootstrap` with the real configuration.
final appConfigProvider = Provider<AppConfig>(
  (ref) => throw UnimplementedError('appConfigProvider must be overridden'),
);
