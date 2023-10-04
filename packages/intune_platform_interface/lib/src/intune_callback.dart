// Copyright 2023, Mushaheed Syed. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'pigeon/messages.pigeon.dart';

abstract class IntuneCallback {
  void onEnrollmentNotification(MAMEnrollmentStatusResult enrollmentResult);

  void onUnexpectedEnrollmentNotification();

  void onErrorType(MSALErrorResponse response);

  void onMsalException(MSALApiException exception);

  void onUserAuthenticationDetails(MSALUserAuthenticationDetails details);

  void onSignOut();
}
