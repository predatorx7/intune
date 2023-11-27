// Copyright 2023, Mushaheed Syed. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'implementations/intune_platform.dart';
import 'intune_callback.dart';
import 'pigeon/messages.pigeon.dart';

export 'intune_callback.dart';

/// The interface that implementations of intune must implement.
///
/// Platform implementations should extend this class rather than implement it
/// as `intune` does not consider newly added methods to be breaking
/// changes. Extending this class (using `extends`) ensures that the subclass
/// will get the default implementation, while platform implementations that
/// `implements` this interface will be broken by newly added
/// [IntunePlatformInterface] methods.
abstract class IntunePlatformInterface extends PlatformInterface {
  /// Constructs a IntunePlatform.
  IntunePlatformInterface() : super(token: _token);

  static final Object _token = Object();

  static IntunePlatformInterface _instance = IntunePlatform();

  /// The default instance of [IntunePlatformInterface] to use.
  ///
  /// Defaults to [IntunePlatform].
  static IntunePlatformInterface get instance => _instance;

  /// Platform-specific plugins should set this with their own
  /// platform-specific class that extends [IntunePlatformInterface] when they
  /// register themselves.
  static set instance(IntunePlatformInterface instance) {
    PlatformInterface.verify(instance, _token);
    _instance = instance;
  }

  void setReceiver(IntuneCallback receiver);

  void removeReceiver();

  Future<bool> registerAuthentication();

  Future<bool> registerAccountForMAM(
    String upn,
    String aadId,
    String tenantId,
    String authorityURL,
  );

  Future<bool> unregisterAccountFromMAM(String upn, String aadId);

  Future<MAMEnrollmentStatusResult> getRegisteredAccountStatus(
    String upn,
    String aadId,
  );

  Future<bool> createMicrosoftPublicClientApplication(
    Map<String?, Object?> publicClientApplicationConfiguration,
    bool forceCreation,
    bool enableLogs,
  );

  Future<List<MSALUserAccount?>> getAccounts();

  Future<bool> acquireToken(AcquireTokenParams params);

  Future<bool> acquireTokenSilently(AcquireTokenSilentlyParams params);

  Future<bool> signOut(String? aadId, SignoutIOSParameters iosParameters);
}
