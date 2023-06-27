import 'package:intune_platform_interface/intune_platform_interface.dart';
import 'messages.g.dart' as messages;

class IntuneIos extends IntunePlatform {
  IntuneIos([
    messages.IntuneApi? api,
  ]) : _api = api ?? messages.IntuneApi();

  final messages.IntuneApi _api;

  /// Registers this class as the default instance of [IntunePlatform].
  static void registerWith() {
    IntunePlatform.instance = IntuneIos();
  }

  @override
  Future<String> ping(String hello) {
    return _api.ping(hello);
  }
}
