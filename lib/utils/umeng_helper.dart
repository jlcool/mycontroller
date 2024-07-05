import 'dart:async';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:umeng_common_sdk/umeng_common_sdk.dart';
import 'package:umeng_push_sdk/umeng_push_sdk.dart';

class UmengHelper {
  static const MethodChannel _channel = MethodChannel('u-push-helper');
  static Future<void> registerPush() async {
    UmengPushSdk.setLogEnable(true);
    UmengCommonSdk.initCommon(
        const String.fromEnvironment("androidAppkey"),
        const String.fromEnvironment("iosAppkey"),
        const String.fromEnvironment("channel"),
        const String.fromEnvironment("pushSecret"));
    UmengPushSdk.register(const String.fromEnvironment("iosAppkey"), const String.fromEnvironment("channel"));
  }
  static Future<void> agree() async {
    if (Platform.isAndroid) {
      return await _channel.invokeMethod("agree");
    } else {
      return;
    }
  }

  static Future<bool?> isAgreed() async {
    if (Platform.isAndroid) {
      return await _channel.invokeMethod("isAgreed");
    } else {
      return false;
    }
  }

}
