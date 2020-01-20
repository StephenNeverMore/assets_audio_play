import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:assets_audio_play/assets_audio_play.dart';

void main() {
  const MethodChannel channel = MethodChannel('assets_audio_play');

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
    expect(await AssetsAudioPlay.platformVersion, '42');
  });
}
