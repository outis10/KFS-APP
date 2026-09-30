import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:kfs/app/app.dart';
import 'package:kfs/core/config/app_config.dart';
import 'package:kfs/core/config/flavor.dart';

/// Runs on a device/emulator:
/// flutter test integration_test --flavor dev --dart-define-from-file=env/dev.json
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('app starts and opens About with real platform info', (
    tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          appConfigProvider.overrideWithValue(
            AppConfig.fromEnvironment(Flavor.dev),
          ),
        ],
        child: const KfsApp(),
      ),
    );
    await tester.pumpAndSettle();

    // Icon instead of text: device locale may be es or en.
    await tester.tap(find.byIcon(Icons.info_outline));
    await tester.pumpAndSettle();

    expect(find.text(Flavor.dev.name), findsOneWidget);
  });
}
