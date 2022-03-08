
import 'dart:async';

import 'package:flutter/services.dart';

class OpenApp {
  static const MethodChannel _channel = MethodChannel('open_app');

  static Future<String?> get platformVersion async {
    final String? version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

    static Future<String>  open(String url) async {
    final String data = await _channel.invokeMethod('openApp',{
      "openUrl":url,
    });
    return data;
  }
}
