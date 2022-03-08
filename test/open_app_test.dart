import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:open_app/open_app.dart';

void main() {
  const MethodChannel channel = MethodChannel('open_app');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('getPlatformVersion', () async {
    expect(await OpenApp.platformVersion, '42');
  });
}
