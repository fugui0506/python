import 'dart:async';
import 'dart:ui';

import 'package:cgwallet/common/common.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:device_info_plus/device_info_plus.dart';



class DeviceService extends GetxService with WidgetsBindingObserver {
  static DeviceService get to => Get.find();
  
  // 初始化等待方法
  final Completer<void> _initCompleter = Completer<void>();
  Future<void> get initComplete => _initCompleter.future;

  // 设备信息
  String deviceId = '';
  String platform = '';
  String osVersion = '';
  String model = '';

  // 主题模式：系统，亮色，暗色
  // 0:跟随系统
  // 1:暗色模式
  // 2:亮色模式
  final themeMode = '2'.obs;

  // 语言设置
  final locale = const Locale('zh', 'CN').obs;
  final localeName = Lang.languageChinese.tr.obs;

  // 定时器
  // Timer? _timerHotUpdate;
  // final _shorebirdUpdater = ShorebirdUpdater();


  // 包信息
  PackageInfo packageInfo = PackageInfo(
    appName: '',
    packageName: '',
    version: '',
    buildNumber: '',
  );

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    // 监视 App 是否切换到后台
    switch (state) {
      case AppLifecycleState.resumed:
        MyLogger.w('app 切换到了前台');
        UserController.to.wss?.connect();
        _setAndroid();
        MyLang.initLocale();
        break;
      case AppLifecycleState.paused:
        MyLogger.w('app 切换到了后台');
        UserController.to.wss?.close();
        break;
      default:
        break;
    }
    super.didChangeAppLifecycleState(state);
  }

  // @override
  // void didChangePlatformBrightness() {
  //   super.didChangePlatformBrightness();
  //   _setAndroid();
  // }

  @override
  void onInit() async {
    super.onInit();
    themeMode.value = await MyShared.to.get(MyConfig.shard.themeModeKey);
    themeMode.value = "2";
    
    WidgetsBinding.instance.addObserver(this);
    
    // 设置主题
    await MyTheme.changeThemeMode(themeMode.value);
    
    // 读取设备信息
    await _readDeviceInfo();

    // 获取包信息
    packageInfo = await PackageInfo.fromPlatform();
    MyLogger.w('APP包信息 --> APP名称: ${packageInfo.appName}', isNewline: false);
    MyLogger.w('APP包信息 --> 版本号: ${packageInfo.version}', isNewline: false);

    // 设置竖屏
    await MyTheme.setPreferredOrientations();
    MyLogger.w('强制竖屏：设置完成...', isNewline: false);

    // 极光推送
    // await MyJPush().initPlatformState();

    // 初始化
    await initPlatformState();
    _initCompleter.complete();
  }

  @override
  void onReady() async {
    super.onReady();
    await MyLang.initLocale();
    checkForUpdates();
  }

  // Future<void> checkUserToken({required Future<void> Function() onNext}) async {
  //   final userInfoJson = await MyShared.to.get(MyConfig.shard.userInfoKey);
  //   if (userInfoJson.isNotEmpty) {
  //     final userInfo = UserInfoModel.fromJson(json.decode(userInfoJson));
  //     final nowTimeUTC = DateTime.now().toUtc();
  //     final createTimeUTC = DateTime.fromMillisecondsSinceEpoch(userInfo.createAt).toUtc();
  //     final days = nowTimeUTC.difference(createTimeUTC).inDays;
  //     // print('登录时间-->${ DateTime.fromMillisecondsSinceEpoch(userInfo.createAt)}');
  //     // print('days --> $days');
  //     // print('tokenSaveDays --> ${MyConfig.app.tokenSaveDays}');
  //     // print('是否过期 --> ${days >= MyConfig.app.tokenSaveDays}');
  //     if (days >= MyConfig.app.tokenSaveDays) {
  //       MyLogger.w('用户信息已过期，清理用户信息...');
  //       await onNext();
  //     }
  //   }
  // }

  Future<void> initPlatformState() async {

    final versionShard = await MyShared.to.get(MyConfig.shard.versionKey);
    final environmentShard = await MyShared.to.get(MyConfig.shard.environmentKey);
    const String environment = String.fromEnvironment('ENVIRONMENT', defaultValue: 'test');

    if (versionShard != packageInfo.version || environmentShard != environment) {
      MyLogger.w('版本信息不匹配，清理所有数据...');
      await MyShared.to.deleteAll();
      MyShared.to.set(MyConfig.shard.versionKey, packageInfo.version);
      MyShared.to.set(MyConfig.shard.environmentKey, environment);
    }
  }

  // 获取安卓设备号
  Future<String> _getAndroidId() async {
    String androidId;
    try {
      final String result = await MyConfig.channel.channelDeviceInfo.invokeMethod('getAndroidId');
      androidId = result;
    } on PlatformException catch (e) {
      androidId = "Failed to get Android ID: '${e.message}'.";
    }
    return androidId;
  }

  // 读取设备信息
  Future<void> _readDeviceInfo() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();

    if (GetPlatform.isAndroid) {
      await _setAndroidInfo(deviceInfo);
    } else if (GetPlatform.isIOS) {
      await _setIOSInfo(deviceInfo);
    }

    MyLogger.w('设备信息：$deviceId', isNewline: false);
  }

  // 设置设备信息：安卓
  Future<void> _setAndroidInfo(DeviceInfoPlugin deviceInfo) async {
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    final androidId = await _getAndroidId();
    platform = 'Android';
    osVersion = 'Android ${androidInfo.version.sdkInt}';
    model = androidInfo.model;
    deviceId = '$platform.${androidInfo.brand}.$model.${androidInfo.id}.$androidId';
    
    // 隐藏安卓手机的底部导航栏
    await MyTheme.removeNavigationBar();
    MyLogger.w('安卓透明状态栏：设置完成...', isNewline: false);
  }

  // 设置设备信息：IOS
  Future<void> _setIOSInfo(DeviceInfoPlugin deviceInfo) async {
    IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
    platform = 'IOS';
    osVersion = 'IOS ${iosInfo.utsname.version}';
    model = iosInfo.model;
    deviceId = iosInfo.identifierForVendor ?? '';
    deviceId = '$platform-$model-$deviceId';
  }

  /// 设置安卓状态栏
  Future<void> _setAndroid() async {
    Brightness brightness;
    switch (themeMode.value) {
      case '1':
        brightness = Brightness.light;
        break;
      case '2':
        brightness = Brightness.dark;
        break;
      default:
        brightness = PlatformDispatcher.instance.platformBrightness == Brightness.dark
            ? Brightness.light
            : Brightness.dark;
    }
    await MyTheme.setAndroidDeviceBar(brightness);
  }

  Future<void> checkForUpdates() async {
    // _timerHotUpdate?.cancel();
    // _timerHotUpdate = Timer.periodic(const Duration(minutes: 1), (timer) async {
    //   final status = await _shorebirdUpdater.checkForUpdate();
    //   if (status == UpdateStatus.outdated) {
    //     await _shorebirdUpdater.update();
    //     await MyAlert.dialog(
    //       title: Lang.restartTitle.tr,
    //       content: Lang.restartContent.tr,
    //       confirmText: Lang.restartButton.tr,
    //       cancelText: Lang.cancel.tr,
    //       onConfirm: () {
    //         MyDeviceInfo.restartApp(
    //           notificationTitle: Lang.restartNoticeTitle.tr,
    //           notificationBody: Lang.restartNoticeContent.tr,
    //         );
    //       },
    //     );
    //   }
    // });
  }
}
