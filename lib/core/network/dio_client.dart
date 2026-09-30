import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kfs/core/config/app_config.dart';
import 'package:kfs/core/errors/failure.dart';
import 'package:kfs/core/storage/secure_store.dart';
import 'package:logging/logging.dart';

/// Key under which the access token is stored (auth is implemented in M1 #6).
const accessTokenKey = 'auth.accessToken';

final dioProvider = Provider<Dio>((ref) {
  final config = ref.watch(appConfigProvider);
  final dio = Dio(
    BaseOptions(
      baseUrl: config.studioBaseUrl,
      connectTimeout: config.connectTimeout,
      receiveTimeout: config.receiveTimeout,
      headers: {'Accept': 'application/json'},
    ),
  );
  dio.interceptors.addAll([
    AuthInterceptor(ref.watch(secureStoreProvider)),
    if (!config.flavor.isProduction) SafeLogInterceptor(),
  ]);
  return dio;
});

/// Adds `Authorization: Bearer <token>` when a token is stored.
class AuthInterceptor extends Interceptor {
  AuthInterceptor(this._store);

  final SecureStore _store;

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final token = await _store.read(accessTokenKey);
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }
}

/// Logs method, path and status only — never headers or bodies (tokens, PII).
class SafeLogInterceptor extends Interceptor {
  final _log = Logger('http');

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    _log.fine('→ ${options.method} ${options.path}');
    handler.next(options);
  }

  @override
  void onResponse(
    Response<dynamic> response,
    ResponseInterceptorHandler handler,
  ) {
    _log.fine(
      '← ${response.statusCode} ${response.requestOptions.method} '
      '${response.requestOptions.path}',
    );
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    _log.warning(
      '✕ ${err.response?.statusCode ?? err.type.name} '
      '${err.requestOptions.method} ${err.requestOptions.path}',
    );
    handler.next(err);
  }
}

/// Maps transport errors to domain failures.
Failure mapDioException(DioException e) {
  switch (e.type) {
    case DioExceptionType.connectionTimeout:
    case DioExceptionType.sendTimeout:
    case DioExceptionType.receiveTimeout:
    case DioExceptionType.transformTimeout:
    case DioExceptionType.connectionError:
      return const NetworkFailure('No connection to Studio');
    case DioExceptionType.badResponse:
      final status = e.response?.statusCode;
      if (status == 401) {
        return const UnauthorizedFailure('Session expired');
      }
      return ServerFailure('Studio responded $status', statusCode: status);
    case DioExceptionType.cancel:
    case DioExceptionType.badCertificate:
    case DioExceptionType.unknown:
      return UnexpectedFailure(e.message ?? 'Unexpected network error');
  }
}
