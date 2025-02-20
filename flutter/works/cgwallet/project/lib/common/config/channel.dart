part of 'config.dart';

class _Channel {
  // 原生通道
  final MethodChannel channelDeviceInfo = const MethodChannel('com.cgwallet.app.channel/device_info');
  final MethodChannel channelImage = const MethodChannel('com.cgwallet.app.channel/image');
  final MethodChannel channelQiChat = const MethodChannel('com.cgwallet.app.channel/qichat');
  final MethodChannel channelDeepLink = const MethodChannel('com.cgwallet.app.channel/deeplink');
}