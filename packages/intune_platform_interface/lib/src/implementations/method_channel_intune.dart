import 'package:flutter/services.dart';

import '../intune_platform_interface.dart';

/// The method channel used to interact with the native platform.
const _kMethodChannel = MethodChannel('flutter_plugins.hdfc.com/intune');

/// An implementation of [IntunePlatform] that uses method channels.
class MethodChannelIntune extends IntunePlatform {
  @override
  Future<bool> registerAuthentication() {
    return _kMethodChannel
        .invokeMethod<bool>(
          'registerAuthentication',
        )
        .then((value) => value == true);
  }

  @override
  Future<bool> registerAccountForMAM(
    String upn,
    String aadId,
    String tenantId,
    String authorityURL,
  ) {
    return _kMethodChannel.invokeMethod<bool>(
      'registerAccountForMAM',
      [
        upn,
        aadId,
        tenantId,
        authorityURL,
      ],
    ).then((value) => value == true);
  }

  @override
  Future<bool> unregisterAccountFromMAM(
    String upn,
    String aadId,
  ) {
    return _kMethodChannel.invokeMethod<bool>(
      'unregisterAccountFromMAM',
      [
        upn,
        aadId,
      ],
    ).then((value) => value == true);
  }
}
