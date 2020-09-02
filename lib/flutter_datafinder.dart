import 'dart:async';

import 'package:flutter/services.dart';

class FlutterDataFinder {
  static const MethodChannel _channel =
      const MethodChannel('flutter_datafinder');

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  static Future<bool> initAndroid(String appId, String appChannel) async {
    if (appId == null) {
      throw Exception('appId must not null');
    }
    if (appChannel == null) {
      throw Exception('appChannel must not null');
    }
    final result = await _channel.invokeMethod(
        'init', <String, dynamic>{'appId': appId, 'appChannel': appChannel});
    return result;
  }

  static Future<bool> initIOS(String appId, String appName) async {
    if (appId == null) {
      throw Exception('appId must not null');
    }
    if (appName == null) {
      throw Exception('appName must not null');
    }
    final result = await _channel.invokeMethod(
        'init', <String, dynamic>{'appId': appId, 'appName': appName});
    return result;
  }

  static Future<bool> setUid(String uid) async {
    if (uid == null) {
      throw Exception('uid must not null');
    }
    final result = await _channel.invokeMethod('setUid', <String, dynamic>{
      'uid': uid,
    });
    return result;
  }

  static Future<bool> event(String eventName,
      {Map<String, dynamic> params}) async {
    if (eventName == null) {
      throw Exception('eventName must not null');
    }
    final result = await _channel.invokeMethod('event', <String, dynamic>{
      'eventName': eventName,
      'params': params ?? {},
    });
    return result;
  }

  static Future<bool> pageStart(String pageName,
      {Map<String, dynamic> params}) async {
    if (pageName == null) {
      throw Exception('pageName must not null');
    }
    final result = await _channel.invokeMethod('pageStart', <String, dynamic>{
      'pageName': pageName,
      'params': params ?? {},
    });
    return result;
  }

  static Future<bool> pageEnd(String pageName,
      {Map<String, dynamic> params}) async {
    if (pageName == null) {
      throw Exception('pageName must not null');
    }
    final result = await _channel.invokeMethod('pageEnd', <String, dynamic>{
      'pageName': pageName,
      'params': params ?? {},
    });
    return result;
  }
}
