import 'package:kfs/core/errors/result.dart';
import 'package:kfs/features/app_info/domain/app_info.dart';

abstract interface class AppInfoRepository {
  Future<Result<AppInfo>> load();
}
