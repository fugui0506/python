import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';

class MyLogger {
  static final List<String> _logQueue = [];
  static bool _isLogging = false;

  static void _processLogQueue() async {
    if (_isLogging) return;
    _isLogging = true;
    while (_logQueue.isNotEmpty) {
      final logMessage = _logQueue.removeAt(0);
      log(logMessage);
      await Future.delayed(const Duration(milliseconds: 50));
    }
    _isLogging = false;
  }

  static void w(dynamic text, {bool isNewline = true}) {
    if (text == null) {
      _logQueue.add('-----------------------------------------------------------------------------');
    } else {
      if (isNewline) {
        _logQueue.add('-----------------------------------------------------------------------------');
      }
      _logQueue.add('=> $text');
    }
    _processLogQueue();
  }

  static void logJson(String type, dynamic jsonData) {
    String formattedJson = const JsonEncoder.withIndent('  ').convert(jsonData);
    w('$type $formattedJson', isNewline: false);
  }

  static void http(Response response) {
    String headers = const JsonEncoder.withIndent('  ').convert(response.requestOptions.headers);
    String parameters = const JsonEncoder.withIndent('  ').convert(response.requestOptions.data ?? response.requestOptions.queryParameters);
    String data = const JsonEncoder.withIndent('  ').convert(response.data);

    log("=" * 160);
    log("✅ 请求地址 => ${response.requestOptions.uri}");
    log("✅ 请求方式 => ${response.requestOptions.method}");
    log("✅ 请求头${headers == '{}' ? ' => $headers': ':$headers'}");
    log("✅ 请求参数${parameters == '{}' ? ' => $parameters': ':$parameters'}");
    log("✅ 返回数据${data == '{}' ? ' => $data': ':$data'}");
    log("=" * 160);
  }

  static void dioErr(DioException err) {
    String headers = const JsonEncoder.withIndent('  ').convert(err.requestOptions.headers);
    String data = const JsonEncoder.withIndent('  ').convert(err.requestOptions.data ?? err.requestOptions.queryParameters);
    log("=" * 160);
    log("❌ 请求地址 => ${err.requestOptions.uri}");
    log("❌ 请求方式 => ${err.requestOptions.method}");
    log("❌ 请求头${headers == '{}' ? ' => $headers': ':$headers'}");
    log("❌ 请求参数${data == '{}' ? ' => $data': ':$data'}");
    log("❌ 错误信息 => ${err.message}");
    log("❌ ${err.error}");
    log("=" * 160);
  }
}
