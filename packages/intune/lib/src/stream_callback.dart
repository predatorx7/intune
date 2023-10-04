import 'dart:async';

import 'package:intune_platform_interface/intune_platform_interface.dart';

import 'exceptions.dart';

class StreamIntuneCallback extends IntuneCallback {
  final _enrollmentNotificationStreamController =
      StreamController<MAMEnrollmentStatusResult>();
  final _msalUserStreamController =
      StreamController<MSALUserAuthenticationDetails?>();
  final _exceptionStreamController =
      StreamController<IntuneAuthenticationException>();

  Stream<MAMEnrollmentStatus?> get enrollmentStatusStream =>
      _enrollmentNotificationStreamController.stream
          .map((event) => event.result);
  Stream<MSALUserAuthenticationDetails?> get authenticationStream =>
      _msalUserStreamController.stream;
  Stream<IntuneAuthenticationException?> get pluginExceptionsStream =>
      _exceptionStreamController.stream;

  void dispose() {
    _enrollmentNotificationStreamController.close();
    _msalUserStreamController.close();
  }

  @override
  void onEnrollmentNotification(MAMEnrollmentStatusResult enrollmentResult) {
    _enrollmentNotificationStreamController.sink.add(enrollmentResult);
  }

  @override
  void onUnexpectedEnrollmentNotification() {
    _enrollmentNotificationStreamController.sink.add(MAMEnrollmentStatusResult(
      result: MAMEnrollmentStatus.UNEXPECTED,
    ));
  }

  @override
  void onErrorType(MSALErrorResponse response) {
    _exceptionStreamController.sink.add(
      IntuneAuthenticationResponseException(response),
    );
  }

  @override
  void onMsalException(MSALApiException exception) {
    _exceptionStreamController.sink.add(
      IntuneAuthenticationApiException(exception),
    );
  }

  @override
  void onSignOut() {
    _msalUserStreamController.sink.add(null);
  }

  @override
  void onUserAuthenticationDetails(MSALUserAuthenticationDetails details) {
    _msalUserStreamController.sink.add(details);
  }
}
