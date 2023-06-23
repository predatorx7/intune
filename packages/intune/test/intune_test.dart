import 'package:flutter_test/flutter_test.dart';
import 'package:intune/intune.dart';
import 'package:intune/intune_platform_interface.dart';
import 'package:intune/intune_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockIntunePlatform
    with MockPlatformInterfaceMixin
    implements IntunePlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final IntunePlatform initialPlatform = IntunePlatform.instance;

  test('$MethodChannelIntune is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelIntune>());
  });

  test('getPlatformVersion', () async {
    Intune intunePlugin = Intune();
    MockIntunePlatform fakePlatform = MockIntunePlatform();
    IntunePlatform.instance = fakePlatform;

    expect(await intunePlugin.getPlatformVersion(), '42');
  });
}
