// Copyright 2023, Mushaheed Syed. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import '../intune_platform_interface.dart';
import '../pigeon/messages.pigeon.dart' as messages;
import 'intune_flutter_api.dart';

/// An implementation of [IntunePlatformInterface] that uses [messages.IntuneApi].
class IntunePlatform extends IntunePlatformInterface {
  IntunePlatform([
    messages.IntuneApi? api,
  ]) : _api = api ?? messages.IntuneApi();

  final messages.IntuneApi _api;

  @override
  void setReceiver(IntuneCallback receiver) {
    messages.IntuneFlutterApi.setup(InternalIntuneFlutterApi(receiver));
  }

  @override
  void removeReceiver() {
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
  ) {
    return _api.unregisterAccountFromMAM(upn);
  }

  @override
  Future<messages.MAMEnrollmentStatusResult> getRegisteredAccountStatus(
    String upn,
  ) {
    return _api.getRegisteredAccountStatus(upn);
  }

  @override
  Future<bool> createMicrosoftPublicClientApplication(
    Map<String?, Object?> publicClientApplicationConfiguration,
    bool forceCreation,
    bool enableLogs,
  ) {
    return _api.createMicrosoftPublicClientApplication(
      publicClientApplicationConfiguration,
      forceCreation,
      enableLogs,
    );
  }

  @override
  Future<List<messages.MSALUserAccount?>> getAccounts() {
    return _api.getAccounts();
  }

  @override
  Future<bool> acquireToken(messages.AcquireTokenParams params) {
    return _api.acquireToken(params);
  }

  @override
  Future<bool> acquireTokenSilently(
      messages.AcquireTokenSilentlyParams params) {
    return _api.acquireTokenSilently(params);
  }

  @override
  Future<bool> signOut(
    String? aadId,
    messages.SignoutIOSParameters iosParameters,
  ) {
    return _api.signOut(aadId, iosParameters);
  }
}
