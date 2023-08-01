import 'package:pigeon/pigeon.dart';

enum MSALLoginPrompt {
  consent,
  create,
  login,
  selectAccount,
  whenRequired,
}

enum MAMEnrollmentStatus {
  AUTHORIZATION_NEEDED(0),
  NOT_LICENSED(1),
  ENROLLMENT_SUCCEEDED(2),
  ENROLLMENT_FAILED(3),
  WRONG_USER(4),
  @Deprecated('')
  MDM_ENROLLED(5),
  UNENROLLMENT_SUCCEEDED(6),
  UNENROLLMENT_FAILED(7),
  PENDING(8),
  COMPANY_PORTAL_REQUIRED(9);

  final int mCode;

  const MAMEnrollmentStatus(this.mCode);
}

enum MSALErrorType {
  intuneAppProtectionPolicyRequired,
  userCancelledSignInRequest,
  unknown,
}

class AcquireTokenParams {
  final List<String?> scopes;
  final String? correlationId;
  final String? authority;
  final String? loginHint;
  final MSALLoginPrompt? prompt;
  final List<String?>? extraScopesToConsent;

  const AcquireTokenParams({
    required this.scopes,
    this.correlationId,
    this.authority,
    this.loginHint,
    this.prompt,
    this.extraScopesToConsent,
  });
}

class AcquireTokenSilentlyParams {
  final String aadId;
  final List<String?> scopes;
  final String? correlationId;

  const AcquireTokenSilentlyParams({
    required this.aadId,
    required this.scopes,
    this.correlationId,
  });
}

class MAMEnrollmentStatusResult {
  final MAMEnrollmentStatus? result;

  const MAMEnrollmentStatusResult(this.result);
}

class MSALApiException {
  // java MsalException
  final String errorCode;
  final String? message;
  final String stackTraceAsString;

  const MSALApiException(this.errorCode, this.message, this.stackTraceAsString);
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

@ConfigurePigeon(PigeonOptions(
  input: 'pigeons/messages.dart',
  dartOut: 'lib/intune/messages.g.dart',
  dartTestOut: 'test/messages_test.g.dart',
  kotlinOptions: KotlinOptions(
    package: 'com.hdfc.irm',
  ),
  kotlinOut: 'android/app/src/main/kotlin/com/hdfc/irm/Messages.kt',
))
@HostApi()
abstract class IntuneApi {
  // MAM
  @async
  bool registerAuthentication();

  @async
  bool registerAccountForMAM(
    String upn,
    String aadId,
    String tenantId,
    String authorityURL,
  );

  @async
  bool unregisterAccountFromMAM(String upn, String aadId);

  @async
  MAMEnrollmentStatusResult getRegisteredAccountStatus(
    String upn,
    String aadId,
  );

  // MSAL
  @async
  bool createMicrosoftPublicClientApplication(
    Map<String, Object?> publicClientApplicationConfiguration,
    bool forceCreation,
    bool enableLogs,
  );

  @async
  List<MSALUserAccount?> getAccounts(String? aadId);

  @async
  bool acquireToken(AcquireTokenParams params);

  @async
  bool acquireTokenSilently(AcquireTokenSilentlyParams params);

  @async
  bool signOut(String? aadId);
}

@FlutterApi()
abstract class IntuneFlutterApi {
  void onEnrollmentNotification(MAMEnrollmentStatusResult enrollmentResult);

  void onUnexpectedEnrollmentNotification();

  void onMsalException(MSALApiException exception);

  void onErrorType(MSALErrorResponse response);

  void onUserAuthenticationDetails(MSALUserAuthenticationDetails details);

  void onSignOut();
}
