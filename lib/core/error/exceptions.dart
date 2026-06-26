class AppException implements Exception {
  final String message;
  final String? code;

  AppException(this.message, [this.code]);

  @override
  String toString() => message;
}

class InvalidDocumentException extends AppException {
  InvalidDocumentException([
    super.message =
        "This doesn't look like a receipt or warranty document. Please try again with a clear photo of your receipt.",
  ]);
}

class NetworkException extends AppException {
  NetworkException([
    super.message = "Network error occurred. Please check your connection.",
  ]);
}

class AuthenticationException extends AppException {
  AuthenticationException([
    super.message = "Authentication failed. Please sign in again.",
  ]);
}
