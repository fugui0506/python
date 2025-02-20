// ignore_for_file: avoid_print

import 'package:cgwallet/common/common.dart';
import 'package:flutter/services.dart';
import 'package:jpush_flutter/jpush_flutter.dart';

class MyJPush {
  MyJPush._internal();
  static final _instance = MyJPush._internal();
  factory MyJPush() => _instance;
  final JPush jPush = JPush();
  Future<void> initPlatformState() async {
    String? platformVersion;
    try {
      jPush.addEventHandler(
        onReceiveNotification: (message) async {
          print("flutter onReceiveNotification: $message");
        },
        onOpenNotification: (message) async {
          print("flutter onOpenNotification: $message");
        },
        onReceiveMessage: (message) async {
          print("flutter onReceiveMessage: $message");
        },
        onReceiveNotificationAuthorization: (message) async {
          print("flutter onReceiveNotificationAuthorization: $message");
        },
        onConnected: (message) {
          print("flutter onConnected: $message");
          return Future(() => null);
        },
      );
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
      print(platformVersion);
    }
    jPush.isNotificationEnabled().then((bool value) {
      print("通知授权是否打开: $value");
      if (!value) {
        print("没有通知权限,点击跳转打开通知设置界面");
        // jPush.openSettingsForNotification();
      }
    }).catchError((onError) {
      print("通知授权是否打开: ${onError.toString()}");
    });
    jPush.enableAutoWakeup(enable: true);
    jPush.setup(
      appKey: MyConfig.key.jpushAppKey,
      production: true,
      channel: "theChannel",
      debug: const String.fromEnvironment('ENVIRONMENT', defaultValue: 'test') == 'rel' ? false : true,
    );
    jPush.applyPushAuthority(
      const NotificationSettingsIOS(
        sound: true,
        alert: true,
        badge: true,
      ),
    );
    final rid = await jPush.getRegistrationID();
    print("flutter getRegistrationID: $rid");
  }

  setAlias(String aliasStr) {
    final alias = jPush.setAlias(aliasStr);
    print("Alias is $alias");
  }
}
