// Copyright 2023, Mushaheed Syed. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import '../intune_callback.dart';
import '../pigeon/messages.pigeon.dart';

class InternalIntuneFlutterApi extends IntuneFlutterApi {
  final IntuneCallback _delegate;

  InternalIntuneFlutterApi(this._delegate);

  @override
  void onEnrollmentNotification(MAMEnrollmentStatusResult enrollmentResult) {
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

  @override
  void onSignOut() {
    return _delegate.onSignOut();
  }
}
