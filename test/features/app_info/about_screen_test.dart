import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kfs/core/config/flavor.dart';
import 'package:kfs/core/errors/failure.dart';
import 'package:kfs/features/app_info/domain/app_info.dart';
import 'package:kfs/features/app_info/presentation/about_screen.dart';
import 'package:kfs/features/app_info/presentation/app_info_providers.dart';

import '../../helpers/pump_app.dart';

void main() {
  const info = AppInfo(
    appName: 'KFS Dev',
    version: '0.1.0',
    buildNumber: '7',
    flavor: Flavor.dev,
    studioBaseUrl: 'http://studio.test',
  );

  testWidgets('shows version, build, flavor and server', (tester) async {
    await tester.pumpLocalized(
      const AboutScreen(),
      overrides: [appInfoProvider.overrideWith((ref) async => info)],
    );
    await tester.pumpAndSettle();

    expect(find.text('Acerca de'), findsOneWidget);
    expect(find.text('0.1.0'), findsOneWidget);
    expect(find.text('7'), findsOneWidget);
    expect(find.text('dev'), findsOneWidget);
    expect(find.text('http://studio.test'), findsOneWidget);
  });

  testWidgets('shows an error with retry when loading fails', (tester) async {
    await tester.pumpLocalized(
      const AboutScreen(),
      overrides: [
        appInfoProvider.overrideWith(
          (ref) async => throw const UnexpectedFailure('boom'),
        ),
      ],
    );
    await tester.pumpAndSettle();

    expect(
      find.text('Ocurrió un error inesperado. Intenta de nuevo.'),
      findsOneWidget,
    );
    expect(find.widgetWithText(FilledButton, 'Reintentar'), findsOneWidget);
  });
}
