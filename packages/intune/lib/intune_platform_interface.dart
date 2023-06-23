import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'intune_method_channel.dart';

abstract class IntunePlatform extends PlatformInterface {
  /// Constructs a IntunePlatform.
  IntunePlatform() : super(token: _token);

  static final Object _token = Object();

  static IntunePlatform _instance = MethodChannelIntune();

  /// The default instance of [IntunePlatform] to use.
  ///
  /// Defaults to [MethodChannelIntune].
  static IntunePlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [IntunePlatform] when
  /// they register themselves.
  static set instance(IntunePlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
