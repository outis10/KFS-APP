import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kfs/core/errors/failure.dart';
import 'package:kfs/core/errors/result.dart';
import 'package:kfs/features/app_info/data/platform_app_info_repository.dart';
import 'package:kfs/features/app_info/domain/app_info.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../../helpers/pump_app.dart';

void main() {
  test('combines package info with the environment config', () async {
    final repository = PlatformAppInfoRepository(
      testConfig,
      packageInfo: () async => PackageInfo(
        appName: 'KFS Dev',
        packageName: 'com.kalitron.kfs.dev',
        version: '0.1.0',
        buildNumber: '1',
      ),
    );

    final result = await repository.load();

    expect(result, isA<Ok<AppInfo>>());
    final info = (result as Ok<AppInfo>).value;
    expect(info.fullVersion, '0.1.0+1');
    expect(info.flavor, testConfig.flavor);
    expect(info.studioBaseUrl, 'http://studio.test');
  });

  test('platform errors become UnexpectedFailure', () async {
    final repository = PlatformAppInfoRepository(
      testConfig,
      packageInfo: () async => throw PlatformException(code: 'x'),
    );

    final result = await repository.load();

    expect((result as Err<AppInfo>).failure, isA<UnexpectedFailure>());
  });
}
