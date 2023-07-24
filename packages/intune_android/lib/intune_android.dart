import 'package:intune_platform_interface/intune_platform_interface.dart';
import 'intune_android_callback.dart';
import 'intune_flutter_api.dart';
import 'messages.g.dart' as messages;
import 'messages.g.dart';
export 'intune_android_callback.dart';

/// The Android implementation of [IntunePlatform].
class IntuneAndroid extends IntunePlatform {
  IntuneAndroid([
    messages.IntuneApi? api,
  ]) : _api = api ?? messages.IntuneApi();

  final messages.IntuneApi _api;

  /// Registers this class as the default instance of [IntunePlatform].
  static void registerWith() {
    IntunePlatform.instance = IntuneAndroid();
  }

  void setAndroidReceiver(IntuneAndroidCallback receiver) {
    messages.IntuneFlutterApi.setup(InternalIntuneFlutterApi(receiver));
  }

  void removeAndroidReceiver() {
    messages.IntuneFlutterApi.setup(null);
  }

  @override
  Future<bool> registerAuthentication() {
    return _api.registerAuthentication();
  }

  @override
  Future<bool> registerAccountForMAM(
    String upn,
    String aadId,
    String tenantId,
    String authorityURL,
  ) {
    return _api.registerAccountForMAM(upn, aadId, tenantId, authorityURL);
  }

  @override
  Future<bool> unregisterAccountFromMAM(
    String upn,
    String aadId,
  ) {
    return _api.unregisterAccountFromMAM(upn, aadId);
  }

  Future<bool> createMicrosoftPublicClientApplication(
    Map<String?, Object?> publicClientApplicationConfiguration,
    bool enableLogs,
  ) {
    return _api.createMicrosoftPublicClientApplication(
      publicClientApplicationConfiguration,
      enableLogs,
    );
  }

  Future<Iterable<MSALUserAccount>> getAccounts(
    String? aadId,
  ) {
    return _api
        .getAccounts(aadId)
        .then((value) => value.whereType<MSALUserAccount>());
  }

  Future<bool> signIn(SignInParams params) {
    return _api.signIn(params);
  }

  Future<bool> signOut(
    String? aadId,
  ) {
    return _api.signOut(aadId);
  }
}
