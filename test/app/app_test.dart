import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kfs/app/app.dart';
import 'package:kfs/core/config/flavor.dart';
import 'package:kfs/features/app_info/domain/app_info.dart';
import 'package:kfs/features/app_info/presentation/app_info_providers.dart';

import '../helpers/pump_app.dart';

void main() {
  testWidgets('home navigates to About', (tester) async {
    tester.platformDispatcher.localesTestValue = const [Locale('es', 'MX')];
    addTearDown(tester.platformDispatcher.clearLocalesTestValue);

    await tester.pumpWidget(
      ProviderScope(
        retry: noRetry,
        overrides: [
          ...baseOverrides(),
          appInfoProvider.overrideWith(
            (ref) async => const AppInfo(
              appName: 'KFS Dev',
              version: '0.1.0',
              buildNumber: '1',
              flavor: Flavor.dev,
              studioBaseUrl: 'http://studio.test',
            ),
          ),
        ],
        child: const KfsApp(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Kalitron Medición'), findsOneWidget);

    await tester.tap(find.text('Acerca de la app'));
    await tester.pumpAndSettle();

    expect(find.text('Acerca de'), findsOneWidget);
    expect(find.text('0.1.0'), findsOneWidget);
  });
}
