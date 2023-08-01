import 'package:flutter/foundation.dart';
import 'package:intune_platform_interface/intune_platform_interface.dart';
import './intune_android.dart';

export 'package:intune_platform_interface/intune_platform_interface.dart'
    show IntunePlatform;

IntunePlatform get _platform => IntunePlatform.instance;

typedef PublicClientApplicationConfiguration = Map<String?, Object?>;

class AndroidPublicClientApplication {
  AndroidPublicClientApplication();

  IntuneAndroid get _intune => _platform as IntuneAndroid;

  Future<bool> updateConfiguration({
    required PublicClientApplicationConfiguration
        publicClientApplicationConfiguration,
    bool forceCreation = false,
    bool enableLogs = kDebugMode,
  }) {
    return _intune.createMicrosoftPublicClientApplication(
      publicClientApplicationConfiguration,
      forceCreation,
      enableLogs,
    );
  }

  Future<Iterable<MSALUserAccount>> getAccounts(
    String? aadId,
  ) {
    return _intune.getAccounts(aadId);
  }

  Future<bool> signIn(AcquireTokenParams params) {
    return _intune.signIn(params);
  }

  Future<bool> signInSilently(AcquireTokenSilentlyParams params) {
    return _intune.signInSilently(params);
  }

  Future<bool> signOut(
    String? aadId,
  ) {
    return _intune.signOut(aadId);
  }
}

class AndroidEnrollmentManager {
  IntuneAndroid get _intune => _platform as IntuneAndroid;

  Future<bool> registerAuthentication() {
    return _intune.registerAuthentication();
  }

  void setAndroidReceiver(IntuneAndroidCallback receiver) {
    return _intune.setAndroidReceiver(receiver);
  }

  void removeAndroidReceiver() {
    return _intune.removeAndroidReceiver();
  }

  Future<bool> registerAccountForMAM(
    String upn,
    String aadId,
    String tenantId,
    String authorityURL,
  ) {
    return _intune.registerAccountForMAM(upn, aadId, tenantId, authorityURL);
  }

  Future<bool> unregisterAccountFromMAM(
    String upn,
    String aadId,
  ) {
    return _intune.unregisterAccountFromMAM(upn, aadId);
  }
}
