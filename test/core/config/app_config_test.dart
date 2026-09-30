import 'package:flutter_test/flutter_test.dart';
import 'package:kfs/core/config/app_config.dart';
import 'package:kfs/core/config/flavor.dart';

void main() {
  group('AppConfig.fromEnvironment', () {
    test('falls back to the emulator loopback when no define is set', () {
      final config = AppConfig.fromEnvironment(Flavor.dev);

      expect(config.flavor, Flavor.dev);
      expect(config.studioBaseUrl, AppConfig.defaultStudioBaseUrl);
    });
  });

  group('Flavor', () {
    test('only prod is production', () {
      expect(Flavor.prod.isProduction, isTrue);
      expect(Flavor.dev.isProduction, isFalse);
      expect(Flavor.staging.isProduction, isFalse);
    });
  });
}
