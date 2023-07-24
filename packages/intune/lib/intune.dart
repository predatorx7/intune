import 'package:flutter/foundation.dart';
import 'package:intune_android/intune_android.dart';
import 'package:intune_android/messages.g.dart';
import 'package:intune_platform_interface/intune_platform_interface.dart';

export 'package:intune_android/messages.g.dart';
export 'package:intune_platform_interface/intune_platform_interface.dart'
    show IntunePlatform;
export 'package:intune_android/intune_android.dart'
    show IntuneAndroid, IntuneAndroidCallback;
export 'package:intune_ios/intune_ios.dart' show IntuneIos;

IntunePlatform get _platform => IntunePlatform.instance;

class Intune {
  Intune();

  Future<bool> registerAuthentication() {
    return _platform.registerAuthentication();
  }

  Future<bool> registerAccount(
    String upn,
    String aadId,
    String tenantId,
    String authorityURL,
  ) {
    return _platform.registerAccountForMAM(
      upn,
      aadId,
      tenantId,
      authorityURL,
    );
  }

  Future<bool> unregisterAccount(
    String upn,
    String aadId,
  ) {
    return _platform.unregisterAccountFromMAM(
      upn,
      aadId,
    );
  }

  void registerReceivers(IntuneAndroidCallback receiver) {
    final platform = _platform;
    if (platform is IntuneAndroid) {
      platform.setAndroidReceiver(receiver);
    }
  }

  void unregisterReceivers() {
    final platform = _platform;
    if (platform is IntuneAndroid) {
      platform.removeAndroidReceiver();
    }
  }

  void signIn(SignInParams params) {
    final platform = _platform;
    if (platform is IntuneAndroid) {
      platform.signIn(params);
    }
  }

  void signOut(String? aadId) {
    final platform = _platform;
    if (platform is IntuneAndroid) {
      platform.signOut(aadId);
    }
  }

  void createMicrosoftPublicClientApplication({
    required Map<String?, Object?> publicClientApplicationConfiguration,
    bool enableLogs = kDebugMode,
  }) {
    final platform = _platform;
    if (platform is IntuneAndroid) {
      platform.createMicrosoftPublicClientApplication(
          publicClientApplicationConfiguration, enableLogs);
    }
  }
}
