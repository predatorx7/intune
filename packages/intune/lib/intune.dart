// Copyright 2023, Mushaheed Syed. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:intune_platform_interface/intune_platform_interface.dart';

import 'src/stream_callback.dart';
import 'src/exceptions.dart';

export 'package:intune_platform_interface/intune_platform_interface.dart';
export 'src/exceptions.dart';

IntunePlatformInterface get _instance => IntunePlatformInterface.instance;

class Intune {
  final MicrosoftAuthenticationLibrary msal;
  final MicrosoftAppManagement mam;
  final StreamIntuneCallback _streamIntuneCallback;

  Intune({
    this.msal = const MicrosoftAuthenticationLibrary(),
    this.mam = const MicrosoftAppManagement(),
    StreamIntuneCallback? streamCallback,
  }) : _streamIntuneCallback = streamCallback ?? StreamIntuneCallback();

  Stream<MAMEnrollmentStatus?> get enrollmentStatusStream =>
      _streamIntuneCallback.enrollmentStatusStream;
  Stream<IntuneAuthenticationException?> get pluginExceptionsStream =>
      _streamIntuneCallback.pluginExceptionsStream;
  Stream<MSALUserAuthenticationDetails?> get authenticationStream =>
      _streamIntuneCallback.authenticationStream;

  Future<void> setup({
    required PublicClientApplicationConfiguration configuration,
    bool forceCreation = false,
    bool enableLogs = kDebugMode,
    bool setupMAM = true,
  }) async {
    try {
      _instance.setReceiver(_streamIntuneCallback);
    } catch (e) {
      throw IntuneSetupException(
        'Failed to setup intune callback receiver',
        e,
      );
    }
    try {
      if (!await msal.setup(
        configuration: configuration,
        forceCreation: forceCreation,
        enableLogs: enableLogs,
      )) {
        throw const IntuneSetupException(
          'Failed to setup intune msal',
        );
      }
    } on IntuneSetupException {
      rethrow;
    } catch (e) {
      throw IntuneSetupException(
        'Failed to setup intune msal',
        e,
      );
    }
    if (setupMAM) {
      try {
        if (!await mam.setup()) {
          throw const IntuneSetupException(
            'Failed to setup intune mam',
          );
        }
      } on IntuneSetupException {
        rethrow;
      } catch (e) {
        throw IntuneSetupException(
          'Failed to setup intune mam',
          e,
        );
      }
    }
  }

  void dispose() {
    _instance.removeReceiver();
    _streamIntuneCallback.dispose();
  }
}

typedef PublicClientApplicationConfiguration = Map<String, Object?>;

class MicrosoftAuthenticationLibrary {
  const MicrosoftAuthenticationLibrary();

  /// Configures the public client application from msal
  Future<bool> setup({
    required PublicClientApplicationConfiguration configuration,
    bool forceCreation = false,
    bool enableLogs = kDebugMode,
  }) {
    return _instance.createMicrosoftPublicClientApplication(
      configuration,
      forceCreation,
      enableLogs,
    );
  }

  Future<Iterable<MSALUserAccount>> getAccounts() {
    return _instance.getAccounts().then((e) => e.whereType<MSALUserAccount>());
  }

  Future<bool> acquireToken(AcquireTokenParams params) {
    return _instance.acquireToken(params);
  }

  Future<bool> acquireTokenSilently(AcquireTokenSilentlyParams params) {
    return _instance.acquireTokenSilently(params);
  }

  Future<bool> signOut(
    String? aadId, {
    required SignoutIOSParameters iosParameters,
  }) {
    return _instance.signOut(aadId, iosParameters);
  }
}

class MicrosoftAppManagement {
  const MicrosoftAppManagement();

  Future<bool> setup() {
    return _instance.registerAuthentication();
  }

  Future<bool> registerAccountForMAM(
    String upn,
    String aadId,
    String tenantId,
    String authorityURL,
  ) {
    return _instance.registerAccountForMAM(upn, aadId, tenantId, authorityURL);
  }

  Future<bool> unregisterAccountFromMAM(
    String upn,
  ) {
    return _instance.unregisterAccountFromMAM(upn);
  }

  Future<MAMEnrollmentStatusResult> getRegisteredAccountStatus(
    String upn,
  ) {
    return _instance.getRegisteredAccountStatus(upn);
  }
}
