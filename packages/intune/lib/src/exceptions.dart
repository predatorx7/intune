import 'package:intune_platform_interface/intune_platform_interface.dart';

class IntuneSetupException implements Exception {
  final String message;
  final Object? internalException;

  const IntuneSetupException(this.message, [this.internalException]);

  @override
  String toString() {
    return 'IntuneSetupException: $message';
  }
}

abstract class IntuneAuthenticationException implements Exception {
  final Object? internalException;

  const IntuneAuthenticationException([this.internalException]);
}

class IntuneAuthenticationResponseException
    extends IntuneAuthenticationException {
  final MSALErrorResponse response;

  const IntuneAuthenticationResponseException(
    this.response, [
    super.internalException,
  ]);

  @override
  String toString() {
    return 'Auth Error: ${response.errorType.name}';
  }
}

class IntuneAuthenticationApiException extends IntuneAuthenticationException {
  final MSALApiException response;

  const IntuneAuthenticationApiException(
    this.response, [
    super.internalException,
  ]);

  @override
  String toString() {
    return 'Auth Exception: ${response.message} (${response.errorCode})';
  }
}
