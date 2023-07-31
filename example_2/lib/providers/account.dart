import 'package:example/intune/messages.g.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../intune/intune.dart';
import '../intune/intune_android_callback.dart';

class AccountController extends Notifier<MSALUserAuthenticationDetails?>
    implements IntuneAndroidCallback {
  @override
  void onEnrollmentNotification(MAMEnrollmentStatusResult enrollmentResult) {
    print('enrollmentResult: $enrollmentResult');
    snack.msg('MAMEnrollmentStatusResult ${enrollmentResult.result}');
    ref.read(enrollmentStatusProvider.notifier).msg(enrollmentResult);
  }

  @override
  void onUnexpectedEnrollmentNotification() {
    print('onUnexpectedEnrollmentNotification');
    snack.msg('MSAL onUnexpectedEnrollmentNotification');
  }

  @override
  void onErrorType(MSALErrorResponse response) {
    print(response.errorType);
    snack.msg('MSAL error type ${response.errorType}');
  }

  @override
  void onMsalException(MSALApiException exception) {
    print(exception);
    snack.msg('MSAL Exception $exception');
  }

  @override
  void onUserAuthenticationDetails(MSALUserAuthenticationDetails details) {
    final account = details.account;
    update(details);
    enrMgr.registerAccountForMAM(
      account.username,
      account.id,
      account.tenantId,
      account.authority,
    );
    snack.msg('registered from mam ${account.username}');
  }

  AndroidEnrollmentManager get enrMgr => ref.read(enrollmentManagerProvider);
  SnackBarNotifier get snack => ref.read(snackbarMessageProvider.notifier);

  @override
  void onSignOut() {
    final a = state?.account;
    if (a == null) return;
    enrMgr.unregisterAccountFromMAM(a.username, a.id);
    snack.msg('unregistered from mam');
  }

  @override
  MSALUserAuthenticationDetails? build() {
    return null;
  }

  void update(MSALUserAuthenticationDetails details) {
    state = details;
  }
}

final accountProvider = NotifierProvider<AccountController, MSALUserAuthenticationDetails?>(
    AccountController.new);
final enrollmentManagerProvider = Provider((ref) => AndroidEnrollmentManager());
final publicClientApplicationProvider =
    Provider((ref) => AndroidPublicClientApplication());

class SnackBarNotifier extends Notifier<String?> {
  @override
  String? build() {
    return null;
  }

  void msg(String value) {
    state = value;
  }
}
class MAMEnrollmentStatusNotifier extends Notifier<MAMEnrollmentStatusResult?> {
  @override
  MAMEnrollmentStatusResult? build() {
    return null;
  }

  void msg(MAMEnrollmentStatusResult value) {
    state = value;
  }
}

final snackbarMessageProvider =
    NotifierProvider<SnackBarNotifier, String?>(SnackBarNotifier.new);
final enrollmentStatusProvider =
    NotifierProvider<MAMEnrollmentStatusNotifier, MAMEnrollmentStatusResult?>(MAMEnrollmentStatusNotifier.new);
