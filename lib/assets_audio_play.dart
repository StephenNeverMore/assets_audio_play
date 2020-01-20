import 'dart:async';

import 'package:flutter/services.dart';

class AssetsAudioPlay {
  static const MethodChannel _channel =
      const MethodChannel('assets_audio_play');

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  static Future<int> play(String path) async {
    final int result = await _channel.invokeMethod('play', <String, dynamic>{
      "path": path,
    });
    return result;
  }

  static Future<int> pause() async {
    final int result = await _channel.invokeMethod('pause');
    return result;
  }
}
