import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'intune_apple_method_channel.dart';

abstract class IntuneApplePlatform extends PlatformInterface {
  /// Constructs a IntuneApplePlatform.
  IntuneApplePlatform() : super(token: _token);

  static final Object _token = Object();

  static IntuneApplePlatform _instance = MethodChannelIntuneApple();

  /// The default instance of [IntuneApplePlatform] to use.
  ///
  /// Defaults to [MethodChannelIntuneApple].
  static IntuneApplePlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [IntuneApplePlatform] when
  /// they register themselves.
  static set instance(IntuneApplePlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
