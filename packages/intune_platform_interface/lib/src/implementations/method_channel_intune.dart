import 'package:flutter/services.dart';

import '../intune_platform_interface.dart';

/// The method channel used to interact with the native platform.
const _kMethodChannel = MethodChannel('flutter_plugins.hdfc.com/intune');

/// An implementation of [IntunePlatform] that uses method channels.
class MethodChannelIntune extends IntunePlatform {
  @override
  Future<String> ping(String hello) async {
    return _kMethodChannel
        .invokeMethod<String>(
          'ping',
          hello,
        )
        .then((value) => value ?? '');
  }
}
