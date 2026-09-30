import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kfs/core/errors/failure.dart';
import 'package:kfs/core/network/dio_client.dart';
import 'package:kfs/core/storage/secure_store.dart';

void main() {
  final options = RequestOptions(path: '/api/test');

  DioException badResponse(int status) => DioException(
    requestOptions: options,
    type: DioExceptionType.badResponse,
    response: Response<void>(requestOptions: options, statusCode: status),
  );

  group('mapDioException', () {
    test('timeouts and connection errors are NetworkFailure', () {
      for (final type in [
        DioExceptionType.connectionTimeout,
        DioExceptionType.sendTimeout,
        DioExceptionType.receiveTimeout,
        DioExceptionType.transformTimeout,
        DioExceptionType.connectionError,
      ]) {
        final failure = mapDioException(
          DioException(requestOptions: options, type: type),
        );
        expect(failure, isA<NetworkFailure>(), reason: type.name);
      }
    });

    test('401 is UnauthorizedFailure', () {
      expect(mapDioException(badResponse(401)), isA<UnauthorizedFailure>());
    });

    test('other statuses are ServerFailure with the code', () {
      final failure = mapDioException(badResponse(503));
      expect(failure, isA<ServerFailure>());
      expect((failure as ServerFailure).statusCode, 503);
    });
  });

  group('AuthInterceptor', () {
    test('adds the bearer header when a token is stored', () async {
      final store = MemorySecureStore();
      await store.write(accessTokenKey, 'abc');
      final request = RequestOptions(path: '/api/account');
      final handler = _CapturingHandler();

      await AuthInterceptor(store).onRequest(request, handler);

      expect(handler.options?.headers['Authorization'], 'Bearer abc');
    });

    test('leaves the request untouched without a token', () async {
      final request = RequestOptions(path: '/api/account');
      final handler = _CapturingHandler();

      await AuthInterceptor(MemorySecureStore()).onRequest(request, handler);

      expect(handler.options?.headers.containsKey('Authorization'), isFalse);
    });
  });
}

class _CapturingHandler extends RequestInterceptorHandler {
  RequestOptions? options;

  @override
  void next(RequestOptions requestOptions) => options = requestOptions;
}
