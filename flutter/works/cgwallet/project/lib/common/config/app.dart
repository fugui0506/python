part of 'config.dart';

class _App {
  // 请求超时时间-获取配置
  final Duration timeOutCheck = const Duration(minutes: 1);
  // 请求超时默认
  final Duration timeOutDefault = const Duration(minutes: 60);
  // 等待时间
  final Duration timeWait = const Duration(seconds: 2);
  // 心跳间隔
  final Duration timeHeartbeat = const Duration(seconds: 10);
  // 重连间隔的基数
  final Duration timeRetry = const Duration(seconds: 1);
  // 页面切换动画时长
  final Duration timePageTransition = const Duration(milliseconds: 300);
  // 冷却时长
  final Duration timeCooling = const Duration(milliseconds: 100);
  // 防抖时长
  final Duration timeDebounce = const Duration(seconds: 1);
  // 缓存时间
  final Duration timeCache = const Duration(days: 1);

  // 最大重连次数
  final int maxRetryAttempts = 3;

  // token 保存时长
  final int tokenSaveDays = 5;

  // 底部高度
  final double bottomHeight = 58.0;
}