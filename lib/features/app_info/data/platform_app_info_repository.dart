import 'package:flutter/services.dart';
import 'package:kfs/core/config/app_config.dart';
import 'package:kfs/core/errors/failure.dart';
import 'package:kfs/core/errors/result.dart';
import 'package:kfs/features/app_info/domain/app_info.dart';
import 'package:kfs/features/app_info/domain/app_info_repository.dart';
import 'package:package_info_plus/package_info_plus.dart';

/// Reads version data from the platform and environment from [AppConfig].
class PlatformAppInfoRepository implements AppInfoRepository {
  PlatformAppInfoRepository(
    this._config, {
    Future<PackageInfo> Function()? packageInfo,
  }) : _packageInfo = packageInfo ?? PackageInfo.fromPlatform;

  final AppConfig _config;
  final Future<PackageInfo> Function() _packageInfo;

  @override
  Future<Result<AppInfo>> load() async {
    try {
      final info = await _packageInfo();
      return Ok(
        AppInfo(
          appName: info.appName,
          version: info.version,
          buildNumber: info.buildNumber,
          flavor: _config.flavor,
          studioBaseUrl: _config.studioBaseUrl,
        ),
      );
    } on PlatformException catch (e) {
      return Err(UnexpectedFailure(e.message ?? 'Package info unavailable'));
    }
  }
}
