import 'package:flutter_test/flutter_test.dart';
import 'package:intune_android/intune_android.dart';
import 'package:intune_android/intune_android_platform_interface.dart';
import 'package:intune_android/intune_android_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockIntuneAndroidPlatform
    with MockPlatformInterfaceMixin
    implements IntuneAndroidPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final IntuneAndroidPlatform initialPlatform = IntuneAndroidPlatform.instance;

  test('$MethodChannelIntuneAndroid is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelIntuneAndroid>());
  });

  test('getPlatformVersion', () async {
    IntuneAndroid intuneAndroidPlugin = IntuneAndroid();
    MockIntuneAndroidPlatform fakePlatform = MockIntuneAndroidPlatform();
    IntuneAndroidPlatform.instance = fakePlatform;

    expect(await intuneAndroidPlugin.getPlatformVersion(), '42');
  });
}
