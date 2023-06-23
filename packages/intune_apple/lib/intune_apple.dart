
import 'intune_apple_platform_interface.dart';

class IntuneApple {
  Future<String?> getPlatformVersion() {
    return IntuneApplePlatform.instance.getPlatformVersion();
  }
}
