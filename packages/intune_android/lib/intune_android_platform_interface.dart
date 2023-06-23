import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'intune_android_method_channel.dart';

abstract class IntuneAndroidPlatform extends PlatformInterface {
  /// Constructs a IntuneAndroidPlatform.
  IntuneAndroidPlatform() : super(token: _token);

  static final Object _token = Object();

  static IntuneAndroidPlatform _instance = MethodChannelIntuneAndroid();

  /// The default instance of [IntuneAndroidPlatform] to use.
  ///
  /// Defaults to [MethodChannelIntuneAndroid].
  static IntuneAndroidPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [IntuneAndroidPlatform] when
  /// they register themselves.
  static set instance(IntuneAndroidPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
