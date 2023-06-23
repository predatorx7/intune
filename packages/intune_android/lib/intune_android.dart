
import 'intune_android_platform_interface.dart';

class IntuneAndroid {
  Future<String?> getPlatformVersion() {
    return IntuneAndroidPlatform.instance.getPlatformVersion();
  }
}
