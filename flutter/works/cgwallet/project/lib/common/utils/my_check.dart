import 'package:cgwallet/common/common.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:web_socket_channel/io.dart';

void checkAndUpdateCustomerData() async {
  if (!UserController.to.isCheckSetting) {
    checkApiUrl(onNext: () async {
      if (!UserController.to.isCheckUpdate) {
        checkUpdate();
      }
      if (Get.currentRoute == MyRoutes.loginView && UserController.to.guestCustomerData.value.customer.isEmpty) {
        UserController.to.updateGuestCustomerData();
      }
    });
  } else {
    if (Get.currentRoute == MyRoutes.loginView && UserController.to.guestCustomerData.value.customer.isEmpty) {
      UserController.to.updateGuestCustomerData();
    }
  }
}

Future<bool> checkUrlIsValid(String url) async {
  MyLogger.w('正在检查地址是否合法: $url');

  try {
    final dio = Dio();
    final response = await dio.head(url).timeout(MyConfig.app.timeOutCheck);
    dio.close();
    MyLogger.w('地址合法: $url');
    return response.statusCode != null && response.statusCode! >= 200 && response.statusCode! < 300;
  } catch (e) {
    MyLogger.w('地址不合法: $url');
    return false;
  }
}

Future<bool> checkUrlIsHealth(String url) async {
  try {
    final dio = Dio();
    final response = await dio.get(url + ApiPath.auth.health).timeout(MyConfig.app.timeOutCheck);
    return response.statusCode != null && response.statusCode! >= 200 && response.statusCode! < 300;
  } catch (e) {
    return false;
  }
}

Future<String> getBaseUrl(List<String> urls) async {
  if (UserController.to.baseUrl.isNotEmpty) {
    return UserController.to.baseUrl;
  }
  List<String> baseUrlList = urls.toSet().toList();
  MyLogger.w('baseUrlList: $baseUrlList');

  UserController.to.baseUrlList = baseUrlList;

  String baseUrl = '';
  showLoading();
  await Future.any(baseUrlList.map((e) async {
    MyLogger.w('正在检查 ${e + ApiPath.auth.health} 是否为健康的链接');
    final eisCanUsedUrl = await checkUrlIsHealth(e);
    if (eisCanUsedUrl) {
      MyLogger.w('检查 $e 是否为健康的链接 -> 成功');
      if(baseUrl.isEmpty) baseUrl = e;
    } else {
      MyLogger.w('检查 $e 是否为健康的链接 -> 失败');
      await Future.delayed(MyConfig.app.timeOutCheck);
    }
  }).toList());
  hideLoading();
  return baseUrl;
}

Future<bool> checkWsUrl(String url) async {  MyLogger.w('👀ws👀 正在尝试连接: $url');
  IOWebSocketChannel? wsTemp;
  try {
    wsTemp = IOWebSocketChannel.connect(
      Uri.parse('$url/?X-token=${UserController.to.userInfo.value.token}'),
      headers: {
        'X-token': UserController.to.userInfo.value.token,
      },
      pingInterval: const Duration(seconds: 5),
      connectTimeout: const Duration(seconds: 10),
    );
    await wsTemp.ready;
  } catch (e) {
    MyLogger.w('👀ws👀 连接失败: $url --> $e');
    return false;
  }
  await wsTemp.sink.close(1000,'测试完毕，主动关闭此通道: $url');
  wsTemp = null;
  MyLogger.w('👀ws👀 连接成功: $url');
  return true;
}

Future<UrlLatency> checkLatency(Dio dio, String url) async {
  MyLogger.w('正在检测请求延迟: $url');

  Stopwatch stopwatch = Stopwatch()..start();
  try {
    await dio.head(url).timeout(MyConfig.app.timeOutCheck);
  } catch (e) {
    stopwatch.stop();
    return UrlLatency(url, const Duration(days: 1));
  }

  stopwatch.stop();
  MyLogger.w('请求时长: ${stopwatch.elapsed.inMilliseconds} 毫秒');

  return UrlLatency(url, stopwatch.elapsed);
}

Future<void> redo({void Function()? onNext}) async {
  showLoading();
  await getEnvironment();
  hideLoading();
  await checkApiUrl(onNext: onNext);
}

void showDialogBaseUrlFailed({void Function()? onNext}) {
  MyAlert.dialog(
    title: Lang.settingApiErrorTitle.tr,
    content: Lang.settingApiErrorContent.tr,
    isDismissible: false,
    showCancelButton: false,
    confirmText: Lang.retry.tr,
    onConfirm: () async {
      // Get.back();
      await checkApiUrl(onNext: onNext);
    }
  );
}

void showDialogSettingFailed({void Function()? onNext}) {
  MyAlert.dialog(
    title: Lang.settingErrorTitle.tr,
    content: Lang.settingErrorContent.tr,
    isDismissible: false,
    showCancelButton: false,
    confirmText: Lang.retry.tr,
    onConfirm: () async {
      // Get.back();
      await redo(onNext: onNext);
    }
  );
}

void showDialogWssUrlFailed({void Function()? onNext}) {
  MyAlert.dialog(
    title: Lang.settingWssErrorTitle.tr,
    content: Lang.settingWssErrorContent.tr,
    isDismissible: false,
    showCancelButton: false,
    confirmText: Lang.retry.tr,
    onConfirm: () async {
      await redo(onNext: onNext);
    }
  );
}

Future<void> checkApiUrl({void Function()? onNext}) async {
  if (!UserController.to.isCheckSetting) {
    UserController.to.isCheckSetting = true;
    await redo(onNext: onNext);
  } else if (UserController.to.baseUrlList.isEmpty || UserController.to.wssUrlList.isEmpty) {
    showDialogSettingFailed(onNext: onNext);
  } else {
    MyLogger.w('已获取到可用的配置...');

    final baseUrl = await getBaseUrl(UserController.to.baseUrlList);
    
    if (baseUrl.isEmpty) {
      showDialogBaseUrlFailed(onNext: onNext);
    } else {
      MyLogger.w('app 的 baseUrl 为 -> $baseUrl');
      UserController.to.baseUrl = baseUrl; 
      setMyDio();
      getWssUrl(wssUrlList: UserController.to.wssUrlList, onNext: onNext);
    }
  }
}

void setMyDio() {
  UserController.to.dio = MyDio(
    baseUrl: UserController.to.baseUrl, 
    token: UserController.to.userInfo.value.token, 
    time: DateTime.now().microsecondsSinceEpoch.toString(), 
    device: DeviceService.to.deviceId,
  );
}

Future<void> getWssUrl({
  void Function()? onNext,
  required List<String> wssUrlList
}) async {
  final urlList = wssUrlList.toSet().toList();
  MyLogger.w('wssUrlList: $urlList', isNewline: false);

  UserController.to.wssUrlList = urlList;

  if ([MyRoutes.loginView, MyRoutes.indexView].contains(Get.currentRoute)) {
    onNext?.call();
  } else {
    if (UserController.to.userInfo.value.token.isNotEmpty && UserController.to.wssUrl.isEmpty) {
      showLoading();
      await UserController.to.dio?.post(ApiPath.base.checkToken, onSuccess: (code, msg, data) async {
        await Future.any(urlList.asMap().entries.map((e) async {
          MyLogger.w('😊😊😊😊😊 正在测试第 ${e.key + 1} / ${urlList.length} 个ws链接 ${e.value}');
          final isGood = await checkWsUrl(e.value);
          if (isGood && UserController.to.wssUrl.isEmpty) {
            UserController.to.wssUrl = e.value;
          } else {
            await Future.delayed(MyConfig.app.timeOutCheck);
          }
        }).toList());
        if (UserController.to.wssUrl.isEmpty && ![MyRoutes.loginView, MyRoutes.indexView].contains(Get.currentRoute)) {
          // UserController.to.goLoginView();
          // await Future.delayed(MyConfig.app.timePageTransition);
          // MyAlert.snackbar(Lang.tokenError.tr);
          showDialogWssUrlFailed(onNext: onNext);
        } else {
          onNext?.call();
        }
      });
      hideLoading();

    } else {
      onNext?.call();
    }
  }
}