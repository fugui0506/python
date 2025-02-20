# 活体检测
根据提示做出相应动作，SDK 实时采集动态信息，判断用户是否为活体、真人

## 平台支持（兼容性）
  | Android|iOS|  
  |  ----  |  -----  |
  | 适用版本区间：4.4以上 |适用版本区间：9 - 14|

## 环境准备

[ CocoaPods 安装教程](https://guides.cocoapods.org/using/getting-started.html)

## 资源引入/集成
在 pubspec.yaml 中添加
```
dependencies:
    alive_flutter_plugin: ^0.2.0
```
### 项目开发配置

#### Android 配置
在 flutter 工程对应的 android/app/build.gradle 文件的 android 域中添加

```
repositories {
    flatDir {
        dirs project(':alive_flutter_plugin').file('libs')
    }
}
```

插件依赖于相机权限，需要动态申请！可以引入 permission_handler: ^8.1.6 插件动态申请 camera 权限

```
//当前权限
Permission permission = Permission.camera;
//权限的状态
PermissionStatus status = await permission.status;
if (status.isUndetermined) {
  //发起权限申请
  PermissionStatus status = await permission.request();
  if (status.isGranted) {
    return true;
  }
} else {
  return true;
}
```
release 包需要添加混淆规则

```
-keep class com.netease.nis.alivedetected.entity.*{*;}
-keep class com.netease.nis.alivedetected.AliveDetector  {
    public <methods>;
    public <fields>;
}
-keep class com.netease.nis.alivedetected.DetectedEngine{
    native <methods>;
}
-keep class com.netease.nis.alivedetected.NISCameraPreview  {
    public <methods>;
}
-keep class com.netease.nis.alivedetected.DetectedListener{*;}
-keep class com.netease.nis.alivedetected.ActionType{ *;}
```
#### iOS 配置
在 flutter 工程对应的 example/ios/Runner/info.plist 里 ，添加

```
<key>NSPhotoLibraryUsageDescription</key> 
<string></string> 
<key>NSCameraUsageDescription</key>
<string></string>

```

## 调用示例

```
class LiveDetectExample extends StatefulWidget {
  @override
  _LiveDetectExampleState createState() => _LiveDetectExampleState();
}

class _LiveDetectExampleState extends State<LiveDetectExample> {
  final AliveFlutterPlugin aliveFlutterPlugin = new AliveFlutterPlugin();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      aliveFlutterPlugin.init("易盾业务id", 30);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('易盾活体检测'),
        ),
        body: new SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: new Center(
            child: Center(
              child: new Column(
                children: [showFaceImageWidget(), startDetectButton()],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget showFaceImageWidget() {
    if (defaultTargetPlatform == TargetPlatform.android) {
      return new Center(
        child: Container(
            width: 300,
                height: 400,
                child: PlatformViewLink(
                  viewType: "platform-view-alive",
                  surfaceFactory: (context, controller) {
                    return AndroidViewSurface(
                      controller: controller as AndroidViewController,
                      gestureRecognizers: const <
                          Factory<OneSequenceGestureRecognizer>>{},
                      hitTestBehavior: PlatformViewHitTestBehavior.opaque,
                    );
                  },
                  onCreatePlatformView: (params) {
                    return PlatformViewsService.initExpensiveAndroidView(
                      id: params.id,
                      viewType: "platform-view-alive",
                      layoutDirection: TextDirection.ltr,
                      creationParams: {"width": 300, "height": 400, "backgroundColor":"#ffffff"},
                      creationParamsCodec: const StandardMessageCodec(),
                      onFocus: () {
                        params.onFocusChanged(true);
                      },
                    )
                      ..addOnPlatformViewCreatedListener(
                          params.onPlatformViewCreated)
                      ..create();
                  },
                ),
                alignment: Alignment.center),
      );
    } else if (defaultTargetPlatform == TargetPlatform.iOS) {
      return new Center(
        child: Container(
          width: 200,
          height: 200,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(100))),
          child: UiKitView(
            viewType: 'com.flutter.alive.imageview',
            creationParams: {
              "width": "200",
              "height": "200",
              "radius": "100",
            },
            //参数的编码方式
            creationParamsCodec: const StandardMessageCodec(),
          ),
        ),
      );
    }
    return Text('$defaultTargetPlatform is not yet supported by this plugin');
  }

  Widget startDetectButton() {
    return new Container(
      child: SizedBox(
        child: new TextButton(
          onPressed: () {
            startLive();
          },
          child: Text("开始检测"),
        ),
        width: double.infinity,
        height: 49,
      ),
      margin: EdgeInsets.fromLTRB(40, 5, 40, 5),
    );
  }

  void startLive() {
    aliveFlutterPlugin.startLiveDetect().then((value) {
      /**
       * action表示返回的动作，动作状态表示：0——正面，1——右转，2——左转，3——张嘴，4——眨眼。
       */
      var method = value["method"];
      var data = value["data"];
      print("当前阶段为：" + method);
      print("下发的动作序列为：" + data["actions"]);
    });
  }
}
```
更多使用场景请参考 [demo](https://pub.dev/packages/alive_flutter_plugin/example)

## SDK 方法说明

### 1 初始化活体检测

#### 代码说明：
```
// 初始化对象
final AliveFlutterPlugin aliveFlutterPlugin = new AliveFlutterPlugin(); 
aliveFlutterPlugin.init("businessID", “timeout”);
```
#### 参数说明：
* options 基础参数：

    |参数|类型|是否必填|默认值|描述|
    |----|----|--------|------|----|
    |businessID|String|是|无|易盾分配的业务id|
    |timeout|int|否|30秒|活体检测超时时间|
    |isDebug|bool|否|false|是否打开debug开关|

### 2 开始活体检测验证

#### 代码说明：
```
aliveFlutterPlugin.startLiveDetect().then((value) {
    var method = value["method"];
    var data = value["data"];
    var actions = data["actions"];
});
```
#### 回调参数说明
* 回调参数说明

    |参数|类型|描述|
    |---|----|-----|
	|method|String|值为onConfig，表示当前为动作下发阶段|
	|actions|String|所有待检测动作 0：正视前方 1：向右转头 2：向左转头 3：张嘴动作 4：眨眼动作，例如：actions = "123",表示需要做向右转头、向左转头、张嘴动作三个动作|

### 3 停止活体检测

#### 代码说明：
```
aliveFlutterPlugin.stopLiveDetect();
```
### 4 检测状态监听

#### 代码说明：
```
var eventChannel = const EventChannel("yd_alive_flutter_event_channel")

eventChannel.receiveBroadcastStream().listen(_onData, onError: _onError);
   
void _onData(response) {
    if (response is Map) {
        setState(() {
            var method = response["method"];
            var data = response["data"];
            if (method == "onChecking") {
                _currentStep = data["currentStep"];
                _result = data["message"];
            } else if (method == "onChecked") {
                _result = data["message"];
                _currentStep = 0;
                stopLive();
            } else if (method == "onError") {
             _result = response["message"];
            }
         }
    }
```

* response 监听回调类型说明

    | method | 所处阶段 | data中的字段说明 |
    |---|----|-----|
	| onReady | 初始化引擎  |initResult：引擎初始化结果 true表现引擎初始化成功、false表示失败|
    | onChecking | 检测中 |currentStep：当前检测动作 0：正视前方 1：向右转头 2：向左转头 3：张嘴动作 4：眨眼动作 message：动作描述信息 |
    | onChecked | 检测完成 |isPassed：是否通过 token：校验码，用于二次校验|
    | onError |发生异常| code：错误码 message：错误信息 |
    | overTime |超时，超过设置的限制时间  |

### 5 资源释放
Android 特有，建议放在 dispose 生命周期
#### 代码说明：
``` 
void dispose() {
    if (defaultTargetPlatform == TargetPlatform.android) {
      //android需要释放资源，否则会引发内存泄露
      aliveFlutterPlugin.destroy();
    }
    super.dispose();
  }
```
退出有残影的话建议 MaterialApp 外面用 WillPopScope 包装，并在 WillPopScope 的 onWillPop 回调中调用 stopLiveDetect 和 destroy
