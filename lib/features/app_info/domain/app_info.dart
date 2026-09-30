import 'package:kfs/core/config/flavor.dart';

/// Build and environment information shown in "Acerca de".
class AppInfo {
  const AppInfo({
    required this.appName,
    required this.version,
    required this.buildNumber,
    required this.flavor,
    required this.studioBaseUrl,
  });

  final String appName;
  final String version;
  final String buildNumber;
  final Flavor flavor;
  final String studioBaseUrl;

  String get fullVersion => '$version+$buildNumber';
}
