import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kfs/core/config/app_config.dart';
import 'package:kfs/core/errors/result.dart';
import 'package:kfs/features/app_info/data/platform_app_info_repository.dart';
import 'package:kfs/features/app_info/domain/app_info.dart';
import 'package:kfs/features/app_info/domain/app_info_repository.dart';

final appInfoRepositoryProvider = Provider<AppInfoRepository>(
  (ref) => PlatformAppInfoRepository(ref.watch(appConfigProvider)),
);

/// Throws the failure so the UI can use `AsyncValue.when(error: …)`.
final appInfoProvider = FutureProvider<AppInfo>((ref) async {
  final result = await ref.watch(appInfoRepositoryProvider).load();
  return switch (result) {
    Ok(:final value) => value,
    Err(:final failure) => throw failure,
  };
});
