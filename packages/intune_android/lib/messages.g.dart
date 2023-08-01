// Autogenerated from Pigeon (v10.1.4), do not edit directly.
// See also: https://pub.dev/packages/pigeon
// ignore_for_file: public_member_api_docs, non_constant_identifier_names, avoid_as, unused_import, unnecessary_parenthesis, prefer_null_aware_operators, omit_local_variable_types, unused_shown_name, unnecessary_import

import 'dart:async';
import 'dart:typed_data' show Float64List, Int32List, Int64List, Uint8List;

import 'package:flutter/foundation.dart' show ReadBuffer, WriteBuffer;
import 'package:flutter/services.dart';

enum MSALLoginPrompt {
  consent,
  create,
  login,
  selectAccount,
  whenRequired,
}

enum MAMEnrollmentStatus {
  AUTHORIZATION_NEEDED,
  NOT_LICENSED,
  ENROLLMENT_SUCCEEDED,
  ENROLLMENT_FAILED,
  WRONG_USER,
  /// Removed in android
  MDM_ENROLLED,
  UNENROLLMENT_SUCCEEDED,
  UNENROLLMENT_FAILED,
  PENDING,
  COMPANY_PORTAL_REQUIRED,
}

enum MSALErrorType {
  intuneAppProtectionPolicyRequired,
  userCancelledSignInRequest,
  unknown,
}

class AcquireTokenParams {
  AcquireTokenParams({
    required this.scopes,
    this.correlationId,
    this.authority,
    this.loginHint,
    this.prompt,
    this.extraScopesToConsent,
  });

  List<String?> scopes;

  String? correlationId;

  String? authority;

  String? loginHint;

  MSALLoginPrompt? prompt;

  List<String?>? extraScopesToConsent;

  Object encode() {
    return <Object?>[
      scopes,
      correlationId,
      authority,
      loginHint,
      prompt?.index,
      extraScopesToConsent,
    ];
  }

  static AcquireTokenParams decode(Object result) {
    result as List<Object?>;
    return AcquireTokenParams(
      scopes: (result[0] as List<Object?>?)!.cast<String?>(),
      correlationId: result[1] as String?,
      authority: result[2] as String?,
      loginHint: result[3] as String?,
      prompt: result[4] != null
          ? MSALLoginPrompt.values[result[4]! as int]
          : null,
      extraScopesToConsent: (result[5] as List<Object?>?)?.cast<String?>(),
    );
  }
}

class AcquireTokenSilentlyParams {
  AcquireTokenSilentlyParams({
    required this.aadId,
    required this.scopes,
    this.correlationId,
  });

  String aadId;

  List<String?> scopes;

  String? correlationId;

  Object encode() {
    return <Object?>[
      aadId,
      scopes,
      correlationId,
    ];
  }

  static AcquireTokenSilentlyParams decode(Object result) {
    result as List<Object?>;
    return AcquireTokenSilentlyParams(
      aadId: result[0]! as String,
      scopes: (result[1] as List<Object?>?)!.cast<String?>(),
      correlationId: result[2] as String?,
    );
  }
}

class MAMEnrollmentStatusResult {
  MAMEnrollmentStatusResult({
    this.result,
  });

  MAMEnrollmentStatus? result;

  Object encode() {
    return <Object?>[
      result?.index,
    ];
  }

  static MAMEnrollmentStatusResult decode(Object result) {
    result as List<Object?>;
    return MAMEnrollmentStatusResult(
      result: result[0] != null
          ? MAMEnrollmentStatus.values[result[0]! as int]
          : null,
    );
  }
}

class MSALApiException {
  MSALApiException({
    required this.errorCode,
    this.message,
    required this.stackTraceAsString,
  });

  String errorCode;

  String? message;

  String stackTraceAsString;

  Object encode() {
    return <Object?>[
      errorCode,
      message,
      stackTraceAsString,
    ];
  }

  static MSALApiException decode(Object result) {
    result as List<Object?>;
    return MSALApiException(
      errorCode: result[0]! as String,
      message: result[1] as String?,
      stackTraceAsString: result[2]! as String,
    );
  }
}

class MSALErrorResponse {
  MSALErrorResponse({
    required this.errorType,
  });

  MSALErrorType errorType;

  Object encode() {
    return <Object?>[
      errorType.index,
    ];
  }

  static MSALErrorResponse decode(Object result) {
    result as List<Object?>;
    return MSALErrorResponse(
      errorType: MSALErrorType.values[result[0]! as int],
    );
  }
}

class MSALUserAccount {
  MSALUserAccount({
    required this.authority,
    required this.id,
    this.idToken,
    required this.tenantId,
    required this.username,
  });

  String authority;

  /// aadid
  String id;

  String? idToken;

  String tenantId;

  /// upn
  String username;

  Object encode() {
    return <Object?>[
      authority,
      id,
      idToken,
      tenantId,
      username,
    ];
  }

  static MSALUserAccount decode(Object result) {
    result as List<Object?>;
    return MSALUserAccount(
      authority: result[0]! as String,
      id: result[1]! as String,
      idToken: result[2] as String?,
      tenantId: result[3]! as String,
      username: result[4]! as String,
    );
  }
}

class MSALUserAuthenticationDetails {
  MSALUserAuthenticationDetails({
    required this.accessToken,
    required this.account,
    required this.authenticationScheme,
    this.correlationId,
    required this.expiresOnISO8601,
    required this.scope,
  });

  String accessToken;

  MSALUserAccount account;

  String authenticationScheme;

  int? correlationId;

  String expiresOnISO8601;

  List<String?> scope;

  Object encode() {
    return <Object?>[
      accessToken,
      account.encode(),
      authenticationScheme,
      correlationId,
      expiresOnISO8601,
      scope,
    ];
  }

  static MSALUserAuthenticationDetails decode(Object result) {
    result as List<Object?>;
    return MSALUserAuthenticationDetails(
      accessToken: result[0]! as String,
      account: MSALUserAccount.decode(result[1]! as List<Object?>),
      authenticationScheme: result[2]! as String,
      correlationId: result[3] as int?,
      expiresOnISO8601: result[4]! as String,
      scope: (result[5] as List<Object?>?)!.cast<String?>(),
    );
  }
}

class _IntuneApiCodec extends StandardMessageCodec {
  const _IntuneApiCodec();
  @override
  void writeValue(WriteBuffer buffer, Object? value) {
    if (value is AcquireTokenParams) {
      buffer.putUint8(128);
      writeValue(buffer, value.encode());
    } else if (value is AcquireTokenSilentlyParams) {
      buffer.putUint8(129);
      writeValue(buffer, value.encode());
    } else if (value is MAMEnrollmentStatusResult) {
      buffer.putUint8(130);
      writeValue(buffer, value.encode());
    } else if (value is MSALApiException) {
      buffer.putUint8(131);
      writeValue(buffer, value.encode());
    } else if (value is MSALErrorResponse) {
      buffer.putUint8(132);
      writeValue(buffer, value.encode());
    } else if (value is MSALUserAccount) {
      buffer.putUint8(133);
      writeValue(buffer, value.encode());
    } else if (value is MSALUserAuthenticationDetails) {
      buffer.putUint8(134);
      writeValue(buffer, value.encode());
    } else {
      super.writeValue(buffer, value);
    }
  }

  @override
  Object? readValueOfType(int type, ReadBuffer buffer) {
    switch (type) {
      case 128: 
        return AcquireTokenParams.decode(readValue(buffer)!);
      case 129: 
        return AcquireTokenSilentlyParams.decode(readValue(buffer)!);
      case 130: 
        return MAMEnrollmentStatusResult.decode(readValue(buffer)!);
      case 131: 
        return MSALApiException.decode(readValue(buffer)!);
      case 132: 
        return MSALErrorResponse.decode(readValue(buffer)!);
      case 133: 
        return MSALUserAccount.decode(readValue(buffer)!);
      case 134: 
        return MSALUserAuthenticationDetails.decode(readValue(buffer)!);
      default:
        return super.readValueOfType(type, buffer);
    }
  }
}

class IntuneApi {
  /// Constructor for [IntuneApi].  The [binaryMessenger] named argument is
  /// available for dependency injection.  If it is left null, the default
  /// BinaryMessenger will be used which routes to the host platform.
  IntuneApi({BinaryMessenger? binaryMessenger})
      : _binaryMessenger = binaryMessenger;
  final BinaryMessenger? _binaryMessenger;

  static const MessageCodec<Object?> codec = _IntuneApiCodec();

  Future<bool> registerAuthentication() async {
    final BasicMessageChannel<Object?> channel = BasicMessageChannel<Object?>(
        'dev.flutter.pigeon.intune_android.IntuneApi.registerAuthentication', codec,
        binaryMessenger: _binaryMessenger);
    final List<Object?>? replyList =
        await channel.send(null) as List<Object?>?;
    if (replyList == null) {
      throw PlatformException(
        code: 'channel-error',
        message: 'Unable to establish connection on channel.',
      );
    } else if (replyList.length > 1) {
      throw PlatformException(
        code: replyList[0]! as String,
        message: replyList[1] as String?,
        details: replyList[2],
      );
    } else if (replyList[0] == null) {
      throw PlatformException(
        code: 'null-error',
        message: 'Host platform returned null value for non-null return value.',
      );
    } else {
      return (replyList[0] as bool?)!;
    }
  }

  Future<bool> registerAccountForMAM(String arg_upn, String arg_aadId, String arg_tenantId, String arg_authorityURL) async {
    final BasicMessageChannel<Object?> channel = BasicMessageChannel<Object?>(
        'dev.flutter.pigeon.intune_android.IntuneApi.registerAccountForMAM', codec,
        binaryMessenger: _binaryMessenger);
    final List<Object?>? replyList =
        await channel.send(<Object?>[arg_upn, arg_aadId, arg_tenantId, arg_authorityURL]) as List<Object?>?;
    if (replyList == null) {
      throw PlatformException(
        code: 'channel-error',
        message: 'Unable to establish connection on channel.',
      );
    } else if (replyList.length > 1) {
      throw PlatformException(
        code: replyList[0]! as String,
        message: replyList[1] as String?,
        details: replyList[2],
      );
    } else if (replyList[0] == null) {
      throw PlatformException(
        code: 'null-error',
        message: 'Host platform returned null value for non-null return value.',
      );
    } else {
      return (replyList[0] as bool?)!;
    }
  }

  Future<bool> unregisterAccountFromMAM(String arg_upn, String arg_aadId) async {
    final BasicMessageChannel<Object?> channel = BasicMessageChannel<Object?>(
        'dev.flutter.pigeon.intune_android.IntuneApi.unregisterAccountFromMAM', codec,
        binaryMessenger: _binaryMessenger);
    final List<Object?>? replyList =
        await channel.send(<Object?>[arg_upn, arg_aadId]) as List<Object?>?;
    if (replyList == null) {
      throw PlatformException(
        code: 'channel-error',
        message: 'Unable to establish connection on channel.',
      );
    } else if (replyList.length > 1) {
      throw PlatformException(
        code: replyList[0]! as String,
        message: replyList[1] as String?,
        details: replyList[2],
      );
    } else if (replyList[0] == null) {
      throw PlatformException(
        code: 'null-error',
        message: 'Host platform returned null value for non-null return value.',
      );
    } else {
      return (replyList[0] as bool?)!;
    }
  }

  Future<MAMEnrollmentStatusResult> getRegisteredAccountStatus(String arg_upn, String arg_aadId) async {
    final BasicMessageChannel<Object?> channel = BasicMessageChannel<Object?>(
        'dev.flutter.pigeon.intune_android.IntuneApi.getRegisteredAccountStatus', codec,
        binaryMessenger: _binaryMessenger);
    final List<Object?>? replyList =
        await channel.send(<Object?>[arg_upn, arg_aadId]) as List<Object?>?;
    if (replyList == null) {
      throw PlatformException(
        code: 'channel-error',
        message: 'Unable to establish connection on channel.',
      );
    } else if (replyList.length > 1) {
      throw PlatformException(
        code: replyList[0]! as String,
        message: replyList[1] as String?,
        details: replyList[2],
      );
    } else if (replyList[0] == null) {
      throw PlatformException(
        code: 'null-error',
        message: 'Host platform returned null value for non-null return value.',
      );
    } else {
      return (replyList[0] as MAMEnrollmentStatusResult?)!;
    }
  }

  Future<bool> createMicrosoftPublicClientApplication(Map<String?, Object?> arg_publicClientApplicationConfiguration, bool arg_forceCreation, bool arg_enableLogs) async {
    final BasicMessageChannel<Object?> channel = BasicMessageChannel<Object?>(
        'dev.flutter.pigeon.intune_android.IntuneApi.createMicrosoftPublicClientApplication', codec,
        binaryMessenger: _binaryMessenger);
    final List<Object?>? replyList =
        await channel.send(<Object?>[arg_publicClientApplicationConfiguration, arg_forceCreation, arg_enableLogs]) as List<Object?>?;
    if (replyList == null) {
      throw PlatformException(
        code: 'channel-error',
        message: 'Unable to establish connection on channel.',
      );
    } else if (replyList.length > 1) {
      throw PlatformException(
        code: replyList[0]! as String,
        message: replyList[1] as String?,
        details: replyList[2],
      );
    } else if (replyList[0] == null) {
      throw PlatformException(
        code: 'null-error',
        message: 'Host platform returned null value for non-null return value.',
      );
    } else {
      return (replyList[0] as bool?)!;
    }
  }

  Future<List<MSALUserAccount?>> getAccounts(String? arg_aadId) async {
    final BasicMessageChannel<Object?> channel = BasicMessageChannel<Object?>(
        'dev.flutter.pigeon.intune_android.IntuneApi.getAccounts', codec,
        binaryMessenger: _binaryMessenger);
    final List<Object?>? replyList =
        await channel.send(<Object?>[arg_aadId]) as List<Object?>?;
    if (replyList == null) {
      throw PlatformException(
        code: 'channel-error',
        message: 'Unable to establish connection on channel.',
      );
    } else if (replyList.length > 1) {
      throw PlatformException(
        code: replyList[0]! as String,
        message: replyList[1] as String?,
        details: replyList[2],
      );
    } else if (replyList[0] == null) {
      throw PlatformException(
        code: 'null-error',
        message: 'Host platform returned null value for non-null return value.',
      );
    } else {
      return (replyList[0] as List<Object?>?)!.cast<MSALUserAccount?>();
    }
  }

  Future<bool> acquireToken(AcquireTokenParams arg_params) async {
    final BasicMessageChannel<Object?> channel = BasicMessageChannel<Object?>(
        'dev.flutter.pigeon.intune_android.IntuneApi.acquireToken', codec,
        binaryMessenger: _binaryMessenger);
    final List<Object?>? replyList =
        await channel.send(<Object?>[arg_params]) as List<Object?>?;
    if (replyList == null) {
      throw PlatformException(
        code: 'channel-error',
        message: 'Unable to establish connection on channel.',
      );
    } else if (replyList.length > 1) {
      throw PlatformException(
        code: replyList[0]! as String,
        message: replyList[1] as String?,
        details: replyList[2],
      );
    } else if (replyList[0] == null) {
      throw PlatformException(
        code: 'null-error',
        message: 'Host platform returned null value for non-null return value.',
      );
    } else {
      return (replyList[0] as bool?)!;
    }
  }

  Future<bool> acquireTokenSilently(AcquireTokenSilentlyParams arg_params) async {
    final BasicMessageChannel<Object?> channel = BasicMessageChannel<Object?>(
        'dev.flutter.pigeon.intune_android.IntuneApi.acquireTokenSilently', codec,
        binaryMessenger: _binaryMessenger);
    final List<Object?>? replyList =
        await channel.send(<Object?>[arg_params]) as List<Object?>?;
    if (replyList == null) {
      throw PlatformException(
        code: 'channel-error',
        message: 'Unable to establish connection on channel.',
      );
    } else if (replyList.length > 1) {
      throw PlatformException(
        code: replyList[0]! as String,
        message: replyList[1] as String?,
        details: replyList[2],
      );
    } else if (replyList[0] == null) {
      throw PlatformException(
        code: 'null-error',
        message: 'Host platform returned null value for non-null return value.',
      );
    } else {
      return (replyList[0] as bool?)!;
    }
  }

  Future<bool> signOut(String? arg_aadId) async {
    final BasicMessageChannel<Object?> channel = BasicMessageChannel<Object?>(
        'dev.flutter.pigeon.intune_android.IntuneApi.signOut', codec,
        binaryMessenger: _binaryMessenger);
    final List<Object?>? replyList =
        await channel.send(<Object?>[arg_aadId]) as List<Object?>?;
    if (replyList == null) {
      throw PlatformException(
        code: 'channel-error',
        message: 'Unable to establish connection on channel.',
      );
    } else if (replyList.length > 1) {
      throw PlatformException(
        code: replyList[0]! as String,
        message: replyList[1] as String?,
        details: replyList[2],
      );
    } else if (replyList[0] == null) {
      throw PlatformException(
        code: 'null-error',
        message: 'Host platform returned null value for non-null return value.',
      );
    } else {
      return (replyList[0] as bool?)!;
    }
  }
}

class _IntuneFlutterApiCodec extends StandardMessageCodec {
  const _IntuneFlutterApiCodec();
  @override
  void writeValue(WriteBuffer buffer, Object? value) {
    if (value is MAMEnrollmentStatusResult) {
      buffer.putUint8(128);
      writeValue(buffer, value.encode());
    } else if (value is MSALApiException) {
      buffer.putUint8(129);
      writeValue(buffer, value.encode());
    } else if (value is MSALErrorResponse) {
      buffer.putUint8(130);
      writeValue(buffer, value.encode());
    } else if (value is MSALUserAccount) {
      buffer.putUint8(131);
      writeValue(buffer, value.encode());
    } else if (value is MSALUserAuthenticationDetails) {
      buffer.putUint8(132);
      writeValue(buffer, value.encode());
    } else {
      super.writeValue(buffer, value);
    }
  }

  @override
  Object? readValueOfType(int type, ReadBuffer buffer) {
    switch (type) {
      case 128: 
        return MAMEnrollmentStatusResult.decode(readValue(buffer)!);
      case 129: 
        return MSALApiException.decode(readValue(buffer)!);
      case 130: 
        return MSALErrorResponse.decode(readValue(buffer)!);
      case 131: 
        return MSALUserAccount.decode(readValue(buffer)!);
      case 132: 
        return MSALUserAuthenticationDetails.decode(readValue(buffer)!);
      default:
        return super.readValueOfType(type, buffer);
    }
  }
}

abstract class IntuneFlutterApi {
  static const MessageCodec<Object?> codec = _IntuneFlutterApiCodec();

  void onEnrollmentNotification(MAMEnrollmentStatusResult enrollmentResult);

  void onUnexpectedEnrollmentNotification();

  void onMsalException(MSALApiException exception);

  void onErrorType(MSALErrorResponse response);

  void onUserAuthenticationDetails(MSALUserAuthenticationDetails details);

  void onSignOut();

  static void setup(IntuneFlutterApi? api, {BinaryMessenger? binaryMessenger}) {
    {
      final BasicMessageChannel<Object?> channel = BasicMessageChannel<Object?>(
          'dev.flutter.pigeon.intune_android.IntuneFlutterApi.onEnrollmentNotification', codec,
          binaryMessenger: binaryMessenger);
      if (api == null) {
        channel.setMessageHandler(null);
      } else {
        channel.setMessageHandler((Object? message) async {
          assert(message != null,
          'Argument for dev.flutter.pigeon.intune_android.IntuneFlutterApi.onEnrollmentNotification was null.');
          final List<Object?> args = (message as List<Object?>?)!;
          final MAMEnrollmentStatusResult? arg_enrollmentResult = (args[0] as MAMEnrollmentStatusResult?);
          assert(arg_enrollmentResult != null,
              'Argument for dev.flutter.pigeon.intune_android.IntuneFlutterApi.onEnrollmentNotification was null, expected non-null MAMEnrollmentStatusResult.');
          api.onEnrollmentNotification(arg_enrollmentResult!);
          return;
        });
      }
    }
    {
      final BasicMessageChannel<Object?> channel = BasicMessageChannel<Object?>(
          'dev.flutter.pigeon.intune_android.IntuneFlutterApi.onUnexpectedEnrollmentNotification', codec,
          binaryMessenger: binaryMessenger);
      if (api == null) {
        channel.setMessageHandler(null);
      } else {
        channel.setMessageHandler((Object? message) async {
          // ignore message
          api.onUnexpectedEnrollmentNotification();
          return;
        });
      }
    }
    {
      final BasicMessageChannel<Object?> channel = BasicMessageChannel<Object?>(
          'dev.flutter.pigeon.intune_android.IntuneFlutterApi.onMsalException', codec,
          binaryMessenger: binaryMessenger);
      if (api == null) {
        channel.setMessageHandler(null);
      } else {
        channel.setMessageHandler((Object? message) async {
          assert(message != null,
          'Argument for dev.flutter.pigeon.intune_android.IntuneFlutterApi.onMsalException was null.');
          final List<Object?> args = (message as List<Object?>?)!;
          final MSALApiException? arg_exception = (args[0] as MSALApiException?);
          assert(arg_exception != null,
              'Argument for dev.flutter.pigeon.intune_android.IntuneFlutterApi.onMsalException was null, expected non-null MSALApiException.');
          api.onMsalException(arg_exception!);
          return;
        });
      }
    }
    {
      final BasicMessageChannel<Object?> channel = BasicMessageChannel<Object?>(
          'dev.flutter.pigeon.intune_android.IntuneFlutterApi.onErrorType', codec,
          binaryMessenger: binaryMessenger);
      if (api == null) {
        channel.setMessageHandler(null);
      } else {
        channel.setMessageHandler((Object? message) async {
          assert(message != null,
          'Argument for dev.flutter.pigeon.intune_android.IntuneFlutterApi.onErrorType was null.');
          final List<Object?> args = (message as List<Object?>?)!;
          final MSALErrorResponse? arg_response = (args[0] as MSALErrorResponse?);
          assert(arg_response != null,
              'Argument for dev.flutter.pigeon.intune_android.IntuneFlutterApi.onErrorType was null, expected non-null MSALErrorResponse.');
          api.onErrorType(arg_response!);
          return;
        });
      }
    }
    {
      final BasicMessageChannel<Object?> channel = BasicMessageChannel<Object?>(
          'dev.flutter.pigeon.intune_android.IntuneFlutterApi.onUserAuthenticationDetails', codec,
          binaryMessenger: binaryMessenger);
      if (api == null) {
        channel.setMessageHandler(null);
      } else {
        channel.setMessageHandler((Object? message) async {
          assert(message != null,
          'Argument for dev.flutter.pigeon.intune_android.IntuneFlutterApi.onUserAuthenticationDetails was null.');
          final List<Object?> args = (message as List<Object?>?)!;
          final MSALUserAuthenticationDetails? arg_details = (args[0] as MSALUserAuthenticationDetails?);
          assert(arg_details != null,
              'Argument for dev.flutter.pigeon.intune_android.IntuneFlutterApi.onUserAuthenticationDetails was null, expected non-null MSALUserAuthenticationDetails.');
          api.onUserAuthenticationDetails(arg_details!);
          return;
        });
      }
    }
    {
      final BasicMessageChannel<Object?> channel = BasicMessageChannel<Object?>(
          'dev.flutter.pigeon.intune_android.IntuneFlutterApi.onSignOut', codec,
          binaryMessenger: binaryMessenger);
      if (api == null) {
        channel.setMessageHandler(null);
      } else {
        channel.setMessageHandler((Object? message) async {
          // ignore message
          api.onSignOut();
          return;
        });
      }
    }
  }
}
