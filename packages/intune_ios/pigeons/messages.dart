import 'package:pigeon/pigeon.dart';

@ConfigurePigeon(PigeonOptions(
  input: 'pigeons/messages.dart',
  dartOut: 'lib/messages.g.dart',
  dartTestOut: 'test/messages_test.g.dart',
  swiftOut: 'ios/Classes/Messages.g.swift',
))
@HostApi()
abstract class IntuneApi {
  @async
  String ping(String hello);
}
