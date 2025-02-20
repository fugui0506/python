import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:cgwallet/common/common.dart';
// import 'package:cgwallet/common/global/init.dart';
import 'package:get/get.dart';
// import 'package:get/get_core/src/get_main.dart';
// import 'package:cgwallet/views/frame/home/home_controller.dart';
// import 'package:get/get.dart';
import 'package:web_socket_channel/io.dart';

class MyWss {
  // WebSocket 连接对象
  IOWebSocketChannel? _webSocketChannel;

  // 心跳定时器 和 发送心跳的时间
  Timer? _heartbeatTimer;

  // 延迟重连的定时器
  Timer? _retryTimer;

  // 连接状态
  bool _isConnected = false;
  bool _isConnecting = false;

  // 是否主动断开用户主动断开连接
  // 如果是主动断开的，就不重连了
  bool _isClosedByUser = false;

  // 重连相关
  int _retryAttempts = 0;

  // ws 重置到初始化状态
  Future<void> connect() async {
    if (UserController.to.userInfo.value.token.isEmpty || UserController.to.wssUrl.isEmpty) return;
    await checkToken();
  }

  // checkToken
  Future<void> checkToken() async {
    return UserController.to.dio?.post(ApiPath.base.checkToken,
      onSuccess: (code, message, data) async {
        await close();
        _retryAttempts = 0;
        _retryConnection();
      }
    );
  }

  /// WebSocket 连接方法
  Future<void> _connectWebSocket() async {
    if (_isConnected || _isConnecting) return;
    _isConnecting = true;
    try {
      _webSocketChannel = IOWebSocketChannel.connect(
          Uri.parse('${UserController.to.wssUrl}/?X-token=${UserController.to.userInfo.value.token}'),
          headers: {
            'x-token': UserController.to.userInfo.value.token,
          },
          pingInterval: const Duration(seconds: 5),
          connectTimeout: const Duration(seconds: 10),
          customClient: HttpClient()..badCertificateCallback = (X509Certificate cert, String host, int port) => true
      );

      await _webSocketChannel?.ready;

      _webSocketChannel?.stream.listen(
        _onMessageReceived,
        onDone: _onConnectionDone,
        onError: _onConnectionError,
        cancelOnError: true,
      );

      _isConnected = true;
      _isClosedByUser = false;
      _isConnecting = false;
      _retryAttempts = 0;
      _cancelTimer(_retryTimer);
      _sendHeartBeat();

      MyLogger.w('✅✅✅✅✅ WebSocket 连接成功 --- ${DateTime.now()}', isNewline: false);
    } catch (e) {
      MyLogger.w('😭😭😭😭😭 WebSocket 连接失败 -- ${DateTime.now()}', isNewline: false);
      MyLogger.w(e, isNewline: false);
      _isClosedByUser = false;
      _isConnecting = false;
      _cancelTimer(_retryTimer);
      _retryConnection();
    }
  }

  void _cancelTimer(Timer? timer) {
    timer?.cancel();
    timer = null;
  }

  /// 处理接收到的消息
  void _onMessageReceived(message) {
    final messageDecode = MyTools.decode(message);
    // MyLogger.w(jsonDecode(messageDecode));
    final data = WebsocketMsgModel.fromJson(jsonDecode(messageDecode));
    // MyLogger.logJson('🆕${data.ext.msgType}🆕 ws服务器消息 (${DateTime.now()})', data.ext.toJson());

    if ([1014, 1024].contains(data.ext.msgType)) {
      UserController.to.updateUserInfo();
    } else if ([1018, 1020, 1012, 1021, 1022, 1027, 1028, 1029].contains(data.ext.msgType)) {
      MyLogger.logJson('🆕${data.ext.msgType}🆕 ws服务器消息 (${DateTime.now()})', data.ext.toJson());
      UserController.to.goSellOrderInfoView(data);
    } else if ([1003, 1006, 1015, 1016, 1017, 1007, 1019, 1023, 1027, 1010].contains(data.ext.msgType)) {
      // MyLogger.logJson('🆕${data.ext.msgType}🆕 ws服务器消息 (${DateTime.now()})', data.ext.toJson());
      UserController.to.goBuyOrderInfoView(data);
    } else if ([1025].contains(data.ext.msgType)) {
      UserController.to.goFlashOrderInfoView(data);
    } else if ([1002].contains(data.ext.msgType)) {
      UserController.to.riskCommon(data);
    } else if ([1005].contains(data.ext.msgType)) {
      UserController.to.notifyCommon(data);
    } else if ([1026].contains(data.ext.msgType)) {
      UserController.to.transferCommon(data);
    } else if ([1013].contains(data.ext.msgType)) {
      UserController.to.updateOrderMarket(data);
    } else if ([1030].contains(data.ext.msgType)) {
      MyLogger.logJson('🆕${data.ext.msgType}🆕 ws服务器消息 (${DateTime.now()})', data.ext.toJson());
      UserController.to.showBankNotify(data);
    }
  }

  /// WebSocket 连接关闭时处理
  void _onConnectionDone() {
    MyLogger.w('❌❌❌❌❌ WebSocket 已经关闭 -- ${DateTime.now()}');
    if (!_isClosedByUser) connect();
  }

  /// WebSocket 连接错误时处理
  void _onConnectionError(error) {
    MyLogger.w('❌❌❌❌❌ WebSocket 连接错误 -- ${DateTime.now()}');
    MyLogger.w(error.toString());
    connect();
  }

  /// 重连机制
  void _retryConnection() {
    if (_retryAttempts < MyConfig.app.maxRetryAttempts) {
      _retryAttempts++;
      MyLogger.w('🔄🔄🔄🔄🔄 尝试连接 -- 第$_retryAttempts次 -- ${DateTime.now()}');
      // _retryTimer = Future.delayed(_retryInterval * (_retryAttempts - 1), () => _connectWebSocket());
      _retryTimer = Timer(MyConfig.app.timeRetry * (_retryAttempts - 1), () async {
        if (_isConnecting) {
          MyLogger.w('👋👋👋👋👋 正在连接中。。。 -- ${DateTime.now()}', isNewline: false);
          _retryConnection();
          return;
        }
        if (UserController.to.userInfo.value.token.isEmpty) {
          MyLogger.w('😭😭😭😭😭 未获取到 token -- ${DateTime.now()}', isNewline: false);
          _retryConnection();
          return;
        }
        await _connectWebSocket();
      });
    } else {
      _cancelTimer(_retryTimer);
      _cancelTimer(_heartbeatTimer);
      MyLogger.w('🛑🛑🛑🛑🛑 达到最大重连次数，开始重置 -- ${DateTime.now()}');
      // connect();
      if (![MyRoutes.indexView, MyRoutes.loginView].contains(Get.currentRoute)) {
        showDialogWssUrlFailed(onNext: connect);
      }
    }
  }

  /// 发送心跳包
  void _sendHeartBeat() {
    _cancelTimer(_heartbeatTimer);
    _heartbeatTimer = Timer.periodic(MyConfig.app.timeHeartbeat, (timer) {
      send(MyTools.encode({"type": 9}));
    });
  }

  /// 断开 WebSocket 连接
  Future<void> close() async {
    _isClosedByUser = true;
    _cancelTimer(_retryTimer);
    _cancelTimer(_heartbeatTimer);
    _isConnected = false;
    _retryAttempts = MyConfig.app.maxRetryAttempts;
    try {
      await _webSocketChannel?.sink.close().timeout(MyConfig.app.timeRetry, onTimeout: () {
        MyLogger.w('>>>>> ⏰ ws 关闭操作超时 ${DateTime.now()} )');
        return null;
      });
    } catch (e) {
      MyLogger.w('>>>>> ❌ ws 关闭时发生错误: $e');
    } finally {
      _webSocketChannel = null;
    }
  }

  /// 发送消息
  void send(data) {
    if (_isConnected && _webSocketChannel != null) {
      try {
        _webSocketChannel?.sink.add(data);
        // MyLogger.w('>>>>> 🆕 消息发送成功（ ${DateTime.now()} ) --> ${MyTools.decode(data)}');
      } catch (e) {
        MyLogger.w('>>>>> 😔 消息发送失败（ ${DateTime.now()} ) --> $e', isNewline: false);
        _retryConnection();
      }
    } else {
      _retryConnection();
    }
  }
}