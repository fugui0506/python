export 'captcha_plugin_config.dart';
import 'package:flutter/services.dart';

class CaptchaPluginFlutter {
  static const MethodChannel _channel =
      MethodChannel('yd_captcha_flutter_method_channel');

  static const EventChannel _eventChannel =
  EventChannel("yd_captcha_flutter_event_channel");

  static bool _eventChannelReadied = false;

  static Function()? _verifyOnLoaded;
  static Function(dynamic)? _verifyOnSuccess;
  static Function(dynamic)? _verifyOnClose;
  static Function(dynamic)? _verifyOnError;

  void init(Map options) {
    _channel.invokeMethod("init", options);
  }

  void showCaptcha({
    Function()? onLoaded,
    Function(dynamic data)? onSuccess,
    Function(dynamic data)? onClose,
    Function(dynamic data)? onError,
}) async {
    if (_eventChannelReadied != true) {
      _eventChannel.receiveBroadcastStream().listen(_handleVerifyOnEvent);
      _eventChannelReadied = true;
    }

    _verifyOnLoaded = onLoaded;
    _verifyOnSuccess = onSuccess;
    _verifyOnClose = onClose;
    _verifyOnError = onError;

    return await _channel.invokeMethod("showCaptcha");
  }

  static _handleVerifyOnEvent(dynamic event) {
    String method = '${event['method']}';
    dynamic data = event['data'];

    switch (method) {
      case 'onLoaded':
        if (_verifyOnLoaded != null) _verifyOnLoaded!();
        break;
      case 'onSuccess':
        if (_verifyOnSuccess != null) _verifyOnSuccess!(data);
        break;
      case 'onClose':
        if (_verifyOnClose != null) _verifyOnClose!(data);
        break;
      case 'onError':
        if (_verifyOnError != null) _verifyOnError!(data);
        break;
    }
  }

  void destroyCaptcha() {
    _channel.invokeMethod("destroyCaptcha");
  }
}
