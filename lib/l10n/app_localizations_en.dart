// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Kalitron Measurement';

  @override
  String get homeTitle => 'Home';

  @override
  String get homeTemplateNotice =>
      'Base version of the app: architecture, environments, CI and release. No business logic yet.';

  @override
  String get homeAboutButton => 'About the app';

  @override
  String get aboutTitle => 'About';

  @override
  String get aboutVersion => 'Version';

  @override
  String get aboutBuild => 'Build';

  @override
  String get aboutFlavor => 'Environment';

  @override
  String get aboutServer => 'Studio server';

  @override
  String get loading => 'Loading…';

  @override
  String get errorGeneric => 'An unexpected error occurred. Please try again.';

  @override
  String get retry => 'Retry';
}
