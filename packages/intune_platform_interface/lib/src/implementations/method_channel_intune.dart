import 'package:flutter/services.dart';

import '../intune_platform_interface.dart';

/// The method channel used to interact with the native platform.
const _kMethodChannel = MethodChannel('plugins.flutter.hdfc.com/intune');

/// An implementation of [IntunePlatform] that uses method channels.
class MethodChannelIntune extends IntunePlatform {
  @override
  Future<bool> doSomething() async {
    return (await _kMethodChannel.invokeMethod<bool>(
      'doSomething',
    ))!;
  }
}
