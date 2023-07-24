import 'intune_android_callback.dart';
import 'messages.g.dart';

class InternalIntuneFlutterApi extends IntuneFlutterApi {
  final IntuneAndroidCallback _delegate;

  InternalIntuneFlutterApi(this._delegate);

  @override
  void onEnrollmentNotification(String enrollmentResult) {
    return _delegate.onEnrollmentNotification(enrollmentResult);
  }

  @override
  void onUnexpectedEnrollmentNotification() {
    return _delegate.onUnexpectedEnrollmentNotification();
  }

  @override
  void onErrorType(MSALErrorResponse response) {
    return _delegate.onErrorType(response);
  }

  @override
  void onMsalException(MSALApiException exception) {
    return _delegate.onMsalException(exception);
  }

  @override
  void onUserAuthenticationDetails(MSALUserAuthenticationDetails details) {
    return _delegate.onUserAuthenticationDetails(details);
  }
}
