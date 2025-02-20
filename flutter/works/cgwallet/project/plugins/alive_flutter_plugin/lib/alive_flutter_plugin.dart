// ignore_for_file: avoid_print

import 'dart:async';

import 'package:flutter/services.dart';

class AliveFlutterPlugin {
  final String flutterLog = "| JVER | Flutter | ";

  static const MethodChannel _channel =
      MethodChannel('alive_flutter_plugin');

  /*
  * 初始化活体检测SDK 业务ID：businessID，timeout: 设置活体检测的超时时间 请传入10-120范围内的时间值，默认30，单位s
  * */
  void init(String businessID, int timeout, [bool? isDebug]) {
    print("$flutterLog init");
    var param = {
      "businessID": businessID,
      "timeout": timeout,
      "isDebug": isDebug
    };
    _channel.invokeMethod("init", param);
  }

  /*
  * 开始活体检测
  * result 然后活体检测的动作 动作状态表示：0——正面，1——右转，2——左转，3——张嘴，4——眨眼。
  * */
  Future<Map<dynamic, dynamic>> startLiveDetect() async {
    print("$flutterLog startLiveDetect");

    String method = "startLiveDetect";
    var result = await _channel.invokeMethod(method);
    return result;
  }

  /*
  * 停止活体检测
  * */
  void stopLiveDetect() {
    print("$flutterLog stopLiveDetect");
    _channel.invokeMethod("stopLiveDetect");
  }

  /// 释放资源
  void destroy() {
    _channel.invokeMethod("destroy");
  }
}
