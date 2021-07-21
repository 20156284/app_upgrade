import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:app_upgrade/app_upgrade.dart';

void main() {
  const MethodChannel channel = MethodChannel('app_upgrade');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  // test('getPlatformVersion', () async {
  //   expect(await AppUpgrade.platformVersion, '42');
  // });
}
