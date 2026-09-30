/// Domain-level error returned by repositories instead of throwing.
/// Implements [Exception] so it can also be thrown into `AsyncValue.error`.
sealed class Failure implements Exception {
  const Failure(this.message);

  final String message;

  @override
  String toString() => 'Failure: $message';
}

/// No connectivity, DNS failure or timeout.
final class NetworkFailure extends Failure {
  const NetworkFailure(super.message);
}

/// 401 — session expired or revoked.
final class UnauthorizedFailure extends Failure {
  const UnauthorizedFailure(super.message);
}

/// Any other non-2xx response from Studio.
final class ServerFailure extends Failure {
  const ServerFailure(super.message, {this.statusCode});

  final int? statusCode;
}

/// Local persistence error (database, secure storage).
final class StorageFailure extends Failure {
  const StorageFailure(super.message);
}

/// Bug or unexpected state.
final class UnexpectedFailure extends Failure {
  const UnexpectedFailure(super.message);
}
