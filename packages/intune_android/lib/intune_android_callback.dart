import 'messages.g.dart';

abstract class IntuneAndroidCallback {
  Future<String?> acquireTokenSilent(
    String upn,
    String aadId,
    Iterable<String> scopes,
  );

  void onEnrollmentNotification(MAMEnrollmentStatusResult enrollmentResult);

  void onUnexpectedEnrollmentNotification();

  void onErrorType(MSALErrorResponse response);

  void onMsalException(MSALApiException exception);

  void onUserAuthenticationDetails(MSALUserAuthenticationDetails details);

  void onSignOut();
}
