import 'package:alive_flutter_plugin/alive_flutter_plugin.dart';
import 'package:cgwallet/common/common.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

void checkRealName(void Function() common) {
  if (![1, 3].contains(UserController.to.userInfo.value.user.isAuth)) {
    MyAlert.dialog(
      title: Lang.realNameViewTitle.tr,
      content: Lang.realNameAlert.tr,
      confirmText: Lang.goRealName.tr,
      showCancelButton: false,
      onConfirm: () {
        Get.toNamed(MyRoutes.realNameVerifiedView);
      },
    );
  } else {
    common.call();
  }
}

Future<void> realNameVerify(String token, {
  void Function()? onSuccess,
  void Function()? onError,
}) async{
  await UserController.to.dio?.post(ApiPath.auth.check,
    onSuccess: (code, msg, results) async {
      await Get.toNamed(MyRoutes.verifiedResultView, arguments: true);
      await UserController.to.updateUserInfo();
      onSuccess?.call();
    }, 
    onError: () async {
      await Get.toNamed(MyRoutes.verifiedResultView, arguments: false);
      await UserController.to.updateUserInfo();
      onError?.call();
    }, 
    data:  {
      "token": token,
      "realName": UserController.to.userInfo.value.user.realName,
      "idCardNo": UserController.to.userInfo.value.user.identityId,
    }
  );
}

class FaceVerifiedStatefulView extends StatefulWidget {
  const FaceVerifiedStatefulView({super.key});

  @override
  State<FaceVerifiedStatefulView> createState() => _FaceVerifiedStatefulViewState();
}

class _FaceVerifiedStatefulViewState extends State<FaceVerifiedStatefulView> {
 final AliveFlutterPlugin aliveFlutterPlugin = AliveFlutterPlugin();

  String _result = "";
  int _currentStep = 0;
  bool _mastVisible = true;
  bool _isButtonDisable = false;
  bool _isError = false;

  var eventChannel = const EventChannel("yd_alive_flutter_event_channel");

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => initController());
    eventChannel.receiveBroadcastStream().listen(_onData, onError: _onError);
  }

  void _onData(response) {
    if (response is Map && mounted) {
      setState(() {
        var method = response["method"];
        var data = response["data"];

        if (method == "onReady") {
          MyLogger.w("初始化引擎是否成功：${data["initResult"]}");
        } else if (method == "onChecking") {
          _currentStep = data["currentStep"];
          _result = data["message"];
        } else if (method == "onChecked") {
          Get.back(result: data["token"]);
          // stopLive();
        } else if (method == "onError") {
          _result = data["message"];
        } else if (method == "overTime"){
          // Get.back();
          _currentStep = 0;
          stopLive();
          _mastVisible = true;
          _isError = true;
          _isButtonDisable = false;
        }
      });
    }
  }

  void _onError(Object error) {
    Object exception = error;
    MyLogger.w(exception);
  }

  @override
  Widget build(BuildContext context) {
    return _buildBody(context);
  }

  Widget _buildBody(BuildContext context) {
    return PopScope(
      child:  Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
        child: _buildContent(context)
      ),
      onPopInvoked: (value) async {
        // Android放在这里提前处理，否则有残影
        if (GetPlatform.isAndroid) {
          aliveFlutterPlugin.stopLiveDetect();
          //android需要释放资源，否则会引发内存泄露
          aliveFlutterPlugin.destroy();
        }
      },
    );
  }

  @override
  void dispose() {
    if (GetPlatform.isIOS) {
      aliveFlutterPlugin.stopLiveDetect();
    }
    super.dispose();
  }

  void initController() {
    aliveFlutterPlugin.init(MyConfig.key.faceKey, 40);
  }

  void startLive() async {
    setState(() {
      _isButtonDisable = true;
    });

    MyRequest.to.requestCameraPermission().then((_) => aliveFlutterPlugin.startLiveDetect().then((value) {
      var method = value["method"];
      var data = value["data"];
      MyLogger.w("当前阶段为：$method");
      MyLogger.w("下发的动作序列为：$data['actions']");
      setState(() {
        _mastVisible = false;
        _isError = false;
      });
    }));
  }

  void stopLive() {
    _currentStep = 0;
    aliveFlutterPlugin.stopLiveDetect();
  }

  Widget _buildContent(BuildContext context) {
    return Stack(children: [
      SingleChildScrollView(child: Column(children: [
        showDetailText(),
        if (GetPlatform.isIOS) const SizedBox(height: 20),
        showFaceImageWidget(),
        if (GetPlatform.isIOS) const SizedBox(height: 40),
        showAnimatedGif(context),
      ])),
      Visibility(
        visible: _mastVisible,
        child: Container(
          width: double.infinity,
          height: double.infinity,
          color: Theme.of(context).myColors.background,
          child: Center(child: Column(children: [
            const Spacer(),
            SizedBox(width: Get.width * 0.55, child: Theme.of(context).myIcons.face),
            const Spacer(),
            if(Get.arguments != null)
              Text(UserController.to.userInfo.value.user.riskMessage, style: Theme.of(context).myStyles.contentSmall, textAlign: TextAlign.center),
            if(Get.arguments != null)
              Text(Lang.faceVerifiedViewNotice.tr, style: Theme.of(context).myStyles.contentSmall, textAlign: TextAlign.center),
            if(Get.arguments != null)
              const SizedBox(height: 32),
            SafeArea(top: false, left: false, right: false, child: startDetectButton())
          ])),
        )
      ),
    ]);
  }

  Widget showDetailText() {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      width: 300,
      height: 40,
      child: Text(_result, textAlign: TextAlign.center),
    );
  }

  Widget showFaceImageWidget() {
    if (GetPlatform.isAndroid) {
      return  Container(
        width: 300,
        height: 400,
        alignment: Alignment.center,
        child: PlatformViewLink(
          viewType: "platform-view-alive",
          surfaceFactory: (context, controller) {
            return AndroidViewSurface(
              controller: controller as AndroidViewController,
              gestureRecognizers: const <Factory<OneSequenceGestureRecognizer>>{},
              hitTestBehavior: PlatformViewHitTestBehavior.opaque,
            );
          },
          onCreatePlatformView: (params) {
            return PlatformViewsService.initExpensiveAndroidView(
              id: params.id,
              viewType: "platform-view-alive",
              layoutDirection: TextDirection.ltr,
              creationParams: {"width": 300, "height": 400},
              creationParamsCodec: const StandardMessageCodec(),
              onFocus: () {
                params.onFocusChanged(true);
              },
            ) ..addOnPlatformViewCreatedListener(params.onPlatformViewCreated)
              ..create();
          },
      ));
    } else if (GetPlatform.isIOS) {
      return Container(
        width: 240,
        height: 240,
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(120)),
          color: Theme.of(context).myColors.dark
        ),
        child: const UiKitView(
          viewType: 'com.flutter.alive.imageview',
          creationParams: {
            "width": "240",
            "height": "240",
            "radius": "120",
          },
          //参数的编码方式
          creationParamsCodec: StandardMessageCodec(),
        ),
      );
    }
    return const Text('Not yet supported by this plugin');
  }

  Widget startDetectButton() {
    return  MyButton.filedLong(
      onPressed: _isButtonDisable ? null : startLive,
      text: _isError ? Lang.verifiedResultViewAgain.tr : Lang.faceVerifiedViewButton.tr,
    );
  }

  Widget showAnimatedGif(BuildContext context) {
    /**
     * _currentStep == 1 右转
     * _currentStep == 2 左转
     * _currentStep == 3 张嘴
     * _currentStep == 4 眨眼
     */
    var image = Theme.of(context).myIcons.picFront;
    if (_currentStep == 1) {
      image = Theme.of(context).myIcons.turnRight;
    } else if (_currentStep == 2) {
      image = Theme.of(context).myIcons.turnLeft;
    } else if (_currentStep == 3) {
      image = Theme.of(context).myIcons.openMouth;
    } else if (_currentStep == 4) {
      image = Theme.of(context).myIcons.openEyes;
    } 
    return  SizedBox(width: 120, height: 120, child: image);
  }
}
