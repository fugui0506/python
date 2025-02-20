import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:captcha_plugin_flutter/captcha_plugin_flutter.dart';
import 'package:cgwallet/common/common.dart';
import 'package:get/get.dart';


void showCaptcha({void Function(String)? onSuccess, void Function()? onError, void Function()? onClose}) async {
  final CaptchaPluginFlutter captchaPlugin = CaptchaPluginFlutter();
  final   captchaKeyModel = CaptchaKeyModel.empty();
  CaptchaPluginConfig styleConfig = CaptchaPluginConfig(
      radius: 10,
      capBarTextColor: "#25D4D0",
      capBarTextSize: 18,
      capBarTextWeight: "bold",
      borderColor: "#25D4D0",
      borderRadius:10,
      backgroundMoving: "#DC143C",
      executeBorderRadius:10,
      executeBackground: "#DC143C",
      capBarTextAlign: "center",
      capPaddingTop: 10,
      capPaddingRight: 10,
      capPaddingBottom: 10,
      capPaddingLeft: 10,
      paddingTop: 15,
      paddingBottom: 15
  );

  String languageType = 'zh-CN';
  if (Get.locale != MyLang.defaultLocale) {
    languageType = 'zh-CN';
  }

  await captchaKeyModel.update();

  captchaPlugin.init({
    "captcha_id": captchaKeyModel.captchaId,
    "is_debug": false,
    "dimAmount": 0.8,
    "is_touch_outside_disappear": true,
    "timeout": 8000,
    "is_hide_close_button": false,
    "use_default_fallback": true,
    "failed_max_retry_count": 4,
    "language_type": languageType,
    "is_close_button_bottom":true,
    "styleConfig":styleConfig.toJson(),
  });

  captchaPlugin.showCaptcha(
      onLoaded: () {
        MyLogger.w('网易行为式验证码初始化完毕...');
      },
      onSuccess: (dynamic data) {
        MyLogger.w('网易行为式验证成功...');
        MyLogger.w('$data');
        onSuccess?.call(data['validate']);
      },
      onClose: (dynamic data) {
        MyLogger.w('网易行为式验证退出...');
        onClose?.call();
      },
      onError: (dynamic data) {
        MyLogger.w('网易行为式验证出现错误...');
        onError?.call();
      });
}

class MyTools {
  /// 字符串转二进制数组
  static Uint8List encode(dynamic data) {
    String jsonString;

    // 根据输入类型转换为 JSON 字符串
    if (data is Map || data is List) {
      jsonString = jsonEncode(data);
    } else if (data is int || data is double || data is bool) {
      jsonString = data.toString();
    } else if (data is String) {
      jsonString = data;
    } else {
      throw ArgumentError('Unsupported input type');
    }

    // 使用 Gzip 压缩字符串
    List<int> stringBytes = utf8.encode(jsonString);
    List<int> compressedBytes = gzip.encode(stringBytes);

    return Uint8List.fromList(compressedBytes);
  }

  /// 二进制数组转字符串
  static String decode(Uint8List data) {
    // 尝试解压缩数据
    List<int> decompressedData = zlib.decode(data);
    String jsonString = utf8.decode(decompressedData);
    // Map<String,dynamic> jsonData = json.decode(jsonString);

    // 将解压缩后的数据转换为字符串
    return jsonString;
  }
}