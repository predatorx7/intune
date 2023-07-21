import 'package:pigeon/pigeon.dart';

class SignInParams {
  final List<String?> scopes;
  final String? correlationId;
  final String? authority;
  final String? loginHint;
  final MSALLoginPrompt? prompt;
  final List<String?>? extraScopesToConsent;

  const SignInParams({
    required this.scopes,
    this.correlationId,
    this.authority,
    this.loginHint,
    this.prompt,
    this.extraScopesToConsent,
  });
}

enum MSALLoginPrompt {
  consent,
  create,
  login, 
  selectAccount,
  whenRequired,
}

@ConfigurePigeon(PigeonOptions(
  input: 'pigeons/messages.dart',
  dartOut: 'lib/messages.g.dart',
  dartTestOut: 'test/messages_test.g.dart',
  kotlinOptions: KotlinOptions(
    package: 'com.hdfc.flutter_plugins.intune_android',
  ),
  kotlinOut:
      'android/src/main/kotlin/com/hdfc/flutter_plugins/intune_android/Messages.kt',
))
@HostApi()
abstract class IntuneApi {
  // MAM
  @async
  bool registerAuthentication();

  @async
  bool registerAccountForMAM(
      String upn, String aadId, String tenantId, String authorityURL);

  @async
  bool unregisterAccountFromMAM(String upn, String aadId);

  // MSAL
  @async
  bool createMicrosoftPublicClientApplication(
    Map<String, Object?> publicClientApplicationConfiguration,
    bool enableLogs,
  );

  @async
  bool signIn(SignInParams params);
}

class MSALApiException {
  // java MsalException
  final String errorCode;
  final String? message;
  final String stackTraceAsString;

  const MSALApiException(this.errorCode, this.message, this.stackTraceAsString);
}

@FlutterApi()
abstract class IntuneFlutterApi {
  @async
  String? acquireTokenSilent(String upn, String aadId, List<String> scopes);

  void onEnrollmentNotification(String enrollmentResult);

  void onUnexpectedEnrollmentNotification();

  void onMsalException(MSALApiException exception);
}
