// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appTitle => 'Kalitron Medición';

  @override
  String get homeTitle => 'Inicio';

  @override
  String get homeTemplateNotice =>
      'Versión base de la app: arquitectura, ambientes, CI y release. Sin lógica de negocio todavía.';

  @override
  String get homeAboutButton => 'Acerca de la app';

  @override
  String get aboutTitle => 'Acerca de';

  @override
  String get aboutVersion => 'Versión';

  @override
  String get aboutBuild => 'Compilación';

  @override
  String get aboutFlavor => 'Ambiente';

  @override
  String get aboutServer => 'Servidor Studio';

  @override
  String get loading => 'Cargando…';

  @override
  String get errorGeneric => 'Ocurrió un error inesperado. Intenta de nuevo.';

  @override
  String get retry => 'Reintentar';
}
