import 'package:intune_platform_interface/intune_platform_interface.dart';

export 'package:intune_platform_interface/intune_platform_interface.dart'
    show IntunePlatform;
export 'package:intune_android/intune_android.dart' show IntuneAndroid;
export 'package:intune_ios/intune_ios.dart' show IntuneIos;

IntunePlatform get _platform => IntunePlatform.instance;

class Intune {
  Future<String> ping(String hello) {
    return _platform.ping(hello);
  }
}
