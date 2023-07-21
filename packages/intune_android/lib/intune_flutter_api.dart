import 'intune_android_callback.dart';
import 'messages.g.dart';

class InternalIntuneFlutterApi extends IntuneFlutterApi {
  final IntuneAndroidCallback _delegate;

  InternalIntuneFlutterApi(this._delegate);

  @override
  Future<String?> acquireTokenSilent(
    String upn,
    String aadId,
    List<String?> scopes,
  ) {
    return _delegate.acquireTokenSilent(upn, aadId, scopes.whereType<String>());
  }

  @override
  void onEnrollmentNotification(String enrollmentResult) {
    return _delegate.onEnrollmentNotification(enrollmentResult);
  }

  @override
  void onUnexpectedEnrollmentNotification() {
    return _delegate.onUnexpectedEnrollmentNotification();
  }
}
