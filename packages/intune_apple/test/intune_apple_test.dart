import 'package:flutter_test/flutter_test.dart';
import 'package:intune_apple/intune_apple.dart';
import 'package:intune_apple/intune_apple_platform_interface.dart';
import 'package:intune_apple/intune_apple_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockIntuneApplePlatform
    with MockPlatformInterfaceMixin
    implements IntuneApplePlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final IntuneApplePlatform initialPlatform = IntuneApplePlatform.instance;

  test('$MethodChannelIntuneApple is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelIntuneApple>());
  });

  test('getPlatformVersion', () async {
    IntuneApple intuneApplePlugin = IntuneApple();
    MockIntuneApplePlatform fakePlatform = MockIntuneApplePlatform();
    IntuneApplePlatform.instance = fakePlatform;

    expect(await intuneApplePlugin.getPlatformVersion(), '42');
  });
}
