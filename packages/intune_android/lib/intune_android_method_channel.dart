import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'intune_android_platform_interface.dart';

/// An implementation of [IntuneAndroidPlatform] that uses method channels.
class MethodChannelIntuneAndroid extends IntuneAndroidPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('intune_android');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
