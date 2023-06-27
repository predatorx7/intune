import 'package:intune_platform_interface/intune_platform_interface.dart';
import 'messages.g.dart' as messages;

/// The Android implementation of [IntunePlatform].
class IntuneAndroid extends IntunePlatform {
  IntuneAndroid([
    messages.IntuneApi? api,
  ]) : _api = api ?? messages.IntuneApi();

  final messages.IntuneApi _api;

  /// Registers this class as the default instance of [IntunePlatform].
  static void registerWith() {
    IntunePlatform.instance = IntuneAndroid();
  }

  @override
  Future<String> ping(String hello) {
    return _api.ping(hello);
  }
}
