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
  List<MSALUserAccount?> getAccounts(String? aadId);

  @async
  bool signIn(SignInParams params);

  @async
  bool signOut(String? aadId);
}

class MSALApiException {
  // java MsalException
  final String errorCode;
  final String? message;
  final String stackTraceAsString;

  const MSALApiException(this.errorCode, this.message, this.stackTraceAsString);
}

enum MSALErrorType {
  intuneAppProtectionPolicyRequired,
  userCancelledSignInRequest,
  unknown,
}

class MSALErrorResponse {
  final MSALErrorType errorType;

  const MSALErrorResponse(this.errorType);
}

class MSALUserAccount {
  final String authority;

  /// aadid
  final String id;
  final String? idToken;
  final String tenantId;

  /// upn
  final String username;

  const MSALUserAccount({
    required this.authority,
    required this.id,
    this.idToken,
    required this.tenantId,
    required this.username,
  });
}

class MSALUserAuthenticationDetails {
  final String accessToken;
  final MSALUserAccount account;
  final String authenticationScheme;
  final int? correlationId;
  final String expiresOnISO8601;
  final List<String?> scope;

  const MSALUserAuthenticationDetails({
    required this.accessToken,
    required this.account,
    required this.authenticationScheme,
    this.correlationId,
    required this.expiresOnISO8601,
    required this.scope,
  });
}

@FlutterApi()
abstract class IntuneFlutterApi {
  void onEnrollmentNotification(String enrollmentResult);

  void onUnexpectedEnrollmentNotification();

  void onMsalException(MSALApiException exception);

  void onErrorType(MSALErrorResponse response);

  void onUserAuthenticationDetails(MSALUserAuthenticationDetails details);
}
