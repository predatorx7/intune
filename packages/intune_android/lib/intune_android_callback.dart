abstract class IntuneAndroidCallback {
  Future<String?> acquireTokenSilent(
    String upn,
    String aadId,
    Iterable<String> scopes,
  );

  void onEnrollmentNotification(String enrollmentResult);

  void onUnexpectedEnrollmentNotification();
}
