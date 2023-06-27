import 'package:pigeon/pigeon.dart';

@ConfigurePigeon(PigeonOptions(
  input: 'pigeons/messages.dart',
  dartOut: 'lib/messages.g.dart',
  dartTestOut: 'test/messages_test.g.dart',
  kotlinOptions: KotlinOptions(
    package: 'com.hdfc.flutter_plugins.intune_android',
  ),
  kotlinOut:
      'android/src/main/kotlin/com/hdfc/flutter_plugins/intune_android/Messages.kt',
))
@HostApi()
abstract class IntuneApi {
  @async
  String ping(String hello);
}
