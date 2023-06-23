import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'intune_platform_interface.dart';

/// An implementation of [IntunePlatform] that uses method channels.
class MethodChannelIntune extends IntunePlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('intune');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
