import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'implementations/method_channel_intune.dart';

/// The interface that implementations of intune must implement.
///
/// Platform implementations should extend this class rather than implement it
/// as `intune` does not consider newly added methods to be breaking
/// changes. Extending this class (using `extends`) ensures that the subclass
/// will get the default implementation, while platform implementations that
/// `implements` this interface will be broken by newly added
/// [IntunePlatform] methods.
abstract class IntunePlatform extends PlatformInterface {
  /// Constructs a IntunePlatform.
  IntunePlatform() : super(token: _token);

  static final Object _token = Object();

  static IntunePlatform _instance = MethodChannelIntune();

  /// The default instance of [IntunePlatform] to use.
  ///
  /// Defaults to [MethodChannelIntune].
  static IntunePlatform get instance => _instance;

  /// Platform-specific plugins should set this with their own
  /// platform-specific class that extends [IntunePlatform] when they
  /// register themselves.
  static set instance(IntunePlatform instance) {
    PlatformInterface.verify(instance, _token);
    _instance = instance;
  }

  Future<bool> registerAuthentication() {
    throw UnimplementedError(
        'registerAuthentication() has not been implemented.');
  }

  Future<bool> registerAccountForMAM(
    String upn,
    String aadId,
    String tenantId,
    String authorityURL,
  ) {
    throw UnimplementedError(
        'registerAccountForMAM() has not been implemented.');
  }

  Future<bool> unregisterAccountFromMAM(
    String upn,
    String aadId,
  ) {
    throw UnimplementedError(
        'unregisterAccountFromMAM() has not been implemented.');
  }
}
