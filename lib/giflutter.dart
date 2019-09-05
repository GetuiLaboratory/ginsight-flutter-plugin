import 'dart:async';

import 'package:flutter/services.dart';

class Giflutter {
  static const MethodChannel _channel = const MethodChannel('giflutter');

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  static Future<String> get version async {
    final String result = await _channel.invokeMethod("version");
    return result;
  }

  static Future<Map<dynamic, dynamic>> initGInsightSDK(String appid, String channel) async {
    final dynamic result = await _channel.invokeMethod("init", {'appid': appid, 'channel': channel});
    return result;
  }

  //android
  static void setInstallChannel(String channel) {
    _channel.invokeMethod('setInstallChannel', {'channel': channel});
  }
}
