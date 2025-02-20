import 'dart:convert';

import 'package:cgwallet/common/common.dart';
import 'package:dio/dio.dart';  
Future<void> getEnvironment() async {
  const String environment = String.fromEnvironment('ENVIRONMENT', defaultValue: 'test');
  MyLogger.w('正在读取外部参数: $environment');

  UserController.to.baseUrlList.clear();
  UserController.to.wssUrlList.clear();
  UserController.to.baseUrl = '';
  UserController.to.wssUrl = '';
  
  switch (environment) {
    case 'test':
      await getUrls(MyConfig.urls.testUrls);
      break;
    case 'pre':
      await getUrls(MyConfig.urls.preUrls);
      break;
    case 'rel':
      await getUrls(MyConfig.urls.relUrls);
      break;
    case 'grey':
      await getUrls(MyConfig.urls.greyUrls);
      break;
    default:
      await getUrls(MyConfig.urls.testUrls);
  }

  // MyLogger.w('qiliaoBaseUrl: ${UserController.to.qiliaoBaseUrl}', isNewline: false);
}

Future<void> getUrls(List<String> jsonUrls) async {
  // for (String url in qiliaoUrls) {
  //   final urlIsCanUserd = await checkUrlIsValid(url);
  //   if (urlIsCanUserd) {
  //     UserController.to.qiliaoBaseUrl = url;
  //     break;
  //   }
  // }
  await Future.any(jsonUrls.map((url) async {
    MyLogger.w('正在读取配置：$url', isNewline: false);
    await _getConfig(url);

    // final urlIsCanUserd = await checkUrlIsValid(url);
    // if (urlIsCanUserd) {
    //   MyLogger.w('配置文件的链接有效：$url，尝试获取配置信息...', isNewline: false);
    //   await _getConfig(url);
    // } else {
    //   await Future.delayed(MyConfig.app.timeHeartbeat);
    // }
  }).toList());
}

Future<void> _getConfig(String url) async {
  Dio dio = Dio();

  try {
    final response = await dio.get(url,
      options: Options(responseType: ResponseType.plain),
    ).timeout(MyConfig.app.timeOutCheck);

    if (response.statusCode! >= 200 && response.statusCode! < 300) {
      final data = response.data.toString().decrypt(MyConfig.key.aesKey);
      final json = jsonDecode(data);

      MyLogger.w('配置信息获取成功：${response.data}', isNewline: false);
      MyLogger.w('配置信息：$json', isNewline: false);

      final List<dynamic> baseUrls = json['api'];
      for (var element in baseUrls) {
        MyLogger.w('检测到 API 地址 --> $element', isNewline: false);
        UserController.to.baseUrlList.add(element);
      }

      final List<dynamic> wss = json['ws'];
      for (var element in wss) {
        MyLogger.w('检测到 WSS 地址 --> $element', isNewline: false);
        UserController.to.wssUrlList.add(element);
      }

      dio.close();
    } else {
      MyLogger.w('获取配置发生了错误 --> 没有找到可用的配置链接', isNewline: false);
      await Future.delayed(MyConfig.app.timeOutCheck);
    }
  } catch (e) {
    MyLogger.w('获取配置发生了错误 --> $e', isNewline: false);
    await Future.delayed(MyConfig.app.timeOutCheck);
  }
}
