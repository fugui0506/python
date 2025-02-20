import 'dart:async';
import 'dart:io';
import 'package:cgwallet/common/common.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get_rx/get_rx.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:get/route_manager.dart';
import 'package:image_picker/image_picker.dart';


import 'index.dart';

class CustomerChatController extends GetxController {
  final state = CustomerChatState();
  final CustomerChatViewArgumentsModel argument = Get.arguments;

  final inputTextController = TextEditingController();
  final inputTextFocusNode = FocusNode();
  final ScrollController scrollController = ScrollController();

  String qiChatToken = '';
  MyDio? myDio;
  final taskQueue = MyTaskQueue();
  Worker? worker;

  @override
  void onReady() async {
    super.onReady();
    await Future.delayed(MyConfig.app.timePageTransition);
    inputTextController.addListener(listener);
    inputTextFocusNode.addListener(focusListener);
    handleMethodCall();
    UserController.to.stopCustomerHistoryTimer();
    await initQichatSDK();
  }
  
  @override
  void onClose() async {
    inputTextController.removeListener(listener);
    inputTextFocusNode.removeListener(focusListener);
    inputTextController.dispose();
    inputTextFocusNode.dispose();
    // UserController.to.lastCustomerOrderId = argument.sysOrderId ?? '';

    final serviceIds = UserController.to.lastCustomerOrderId.split(',');
    final isOrderIdServiced = serviceIds.contains(argument.sysOrderId);
    if (argument.sysOrderId != null && !isOrderIdServiced) {
      UserController.to.lastCustomerOrderId += ',${argument.sysOrderId}';
      MyShared.to.set(MyConfig.shard.serviceChatOrderKey, UserController.to.lastCustomerOrderId);
    }

    setCustomerHistory();

    disconnect();
    super.onClose();
  }

  Future<void> setCustomerHistory() async {
    final history = QichatHistory.empty();

    if (state.queryEntrance.consults.isEmpty) {
      UserController.to.startCustomerHistoryTimer();
      return;
    }
    await history.update(myDio, {
      // "chatId": state.assignWorker.chatId,
      "chatId": 0,
      // "msgId": "0",
      "count": 100,
      "withLastOne": true,
      "workerId": state.assignWorker.workerId,
      "consultId": state.queryEntrance.consults.first.consultId,
      // "userId": argument.userId,
    });
    UserController.to.customerHistoryList.value.update(CustomerHistoryModel(
      cert: argument.cert,
      token: qiChatToken,
      lastMsgId: history.list.isNotEmpty ? history.list.first.msgId : '',
      newLength: 0,
      workerId: state.assignWorker.workerId,
      consultId: state.queryEntrance.consults.first.consultId,
      apiUrl: argument.apiUrl,
    ));

    UserController.to.customerHistoryList.refresh();
    UserController.to.startCustomerHistoryTimer();
  }

  void pickMedia() async {
    Get.focusScope?.unfocus();
    state.isOpenEmoticons = false;
    showBlock();

    final imageFile = await MyGallery.to.pickMedia();

    hideBlock();


    final fileType = imageFile?.path.split('.').last.toLowerCase();

    if (['jpg', 'jpeg', 'png', 'gif', 'bmp'].contains(fileType)) {
      getImage(imageFile);
    } else  if (['mov', 'mp4', 'avi'].contains(fileType)) {
      getVideo(imageFile);
    }
  }

  Future<void> getImage(XFile? imageFile) async {
    if (imageFile != null) {
      final bytes = await imageFile.readAsBytes();
      final sizeB = await imageFile.length();
      final sizeM = sizeB / 1024 / 1024;
      const maxSize = 5;

      final hintText = Lang.fileSizeOut.trArgs(['$maxSize']);

      MyAlert.show(
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Flexible(child: SingleChildScrollView(child: Image.memory(bytes))),
          const SizedBox(height: 16),
          if (sizeM > maxSize) Text(hintText, style: Get.theme.myStyles.labelRed),
          Row(children: [
            Expanded(
              child: MyButton.filedLong(
                onPressed: () => Get.back(), 
                text: Lang.cancel.tr, color: Get.theme.myColors.buttonCancel, 
                textColor: Get.theme.myColors.onButtonCancel,
              )
            ),
            const SizedBox(width: 8),
            Expanded(child: MyButton.filedLong(onPressed: sizeM > maxSize ? null : () async {
              Get.back();

              final userMessage = QichatUserMessageModel.empty().obs;
              final replyMsgId = state.replyMessage.value.msgId;
              userMessage.value.type = QichatType.image;
              userMessage.value.qichatSendingType = QichatSendingType.isLoading;
              userMessage.value.createdTime = MyTimer.getNowTime();
              userMessage.value.bytes = bytes;
              userMessage.value.replyMsgId = replyMsgId;
              state.chatItems.insert(0, userMessage);
              state.chatItems.refresh();
              moveTab();

              clearReply();

              taskQueue.addTask(() async => await upload(myDio, QichatType.image, imageFile.path, userMessage));
              
            }, text: Lang.send.tr)),
          ])
        ]),
      );
    }
  }

  Future<void> getVideo(XFile? imageFile) async {
    if (imageFile != null) {
      final bytes = await imageFile.readAsBytes();
      final sizeB = await imageFile.length();
      final sizeM = sizeB / 1024 / 1024;
      const maxSize = 100;

      final hintText = Lang.fileSizeOut.trArgs(['$maxSize']);

      MyAlert.show(
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          MyVideoPlayer(file: File(imageFile.path)),
          const SizedBox(height: 16),
          if (sizeM > maxSize) Text(hintText, style: Get.theme.myStyles.labelRed),
          if (sizeM > maxSize) const SizedBox(height: 8),

          Row(children: [
            Expanded(
              child: MyButton.filedLong(
                onPressed: () => Get.back(), 
                text: Lang.cancel.tr, color: Get.theme.myColors.buttonCancel, 
                textColor: Get.theme.myColors.onButtonCancel,
              )
            ),
            const SizedBox(width: 8),
            Expanded(child: MyButton.filedLong(onPressed: sizeM > maxSize ? null : () async {
              Get.back();

              final userMessage = QichatUserMessageModel.empty().obs;
              final replyMsgId = state.replyMessage.value.msgId;
              userMessage.value.type = QichatType.video;
              userMessage.value.qichatSendingType = QichatSendingType.isLoading;
              userMessage.value.createdTime = MyTimer.getNowTime();
              userMessage.value.file = File(imageFile.path);
              userMessage.value.bytes = bytes;
              userMessage.value.replyMsgId = replyMsgId;
              state.chatItems.insert(0, userMessage);
              state.chatItems.refresh();
              moveTab();

              clearReply();

              taskQueue.addTask(() async => await upload(myDio, QichatType.video, imageFile.path, userMessage));
              
            }, text: Lang.send.tr)),
          ])
        ]),
      );
    }
  }

  void onPhotograph() async {
    Get.focusScope?.unfocus();
    state.isOpenEmoticons = false;
    showBlock();
    final imageFile = await MyGallery.to.cameraImage();
    hideBlock();

    await getImage(imageFile);
  }

  void onVideoGraph() async {
    Get.focusScope?.unfocus();
    state.isOpenEmoticons = false;

    showBlock();
    final imageFile = await MyGallery.to.cameraVideo();
    hideBlock();

    await getVideo(imageFile);
  }

  void initMyDio() {
    myDio = MyDio(
      baseUrl: state.qichatApiUrl,
      token: qiChatToken,
      isUUID: true,
    );
  }

  void listener() {
    if (inputTextController.text.isEmpty || state.isLoading) {
      state.isButtonDisable = true;
    } else {
      state.isButtonDisable = false;
    }
  }

  void focusListener() {
    if (inputTextFocusNode.hasFocus) {
      state.isOpenEmoticons = false;
    }
  }

  Future<void> initQichatSDK() async {
    if (qiChatToken.isNotEmpty) {
      return;
    }
    
    // final apiUrls = argument.apiUrl.split(',').map((x) async {
    //   await checkUrlIsValid(x);
    //   return x;
    // }).toList();

    // state.qichatApiUrl = await Future.any(apiUrls);
    final tenantId = argument.tenantId;


    // MyLogger.w('起聊的API集合 -> ${argument.apiUrl}');
    // MyLogger.w('起聊的API -> ${state.qichatApiUrl}', isNewline: false);
    // MyLogger.w('tenantId -> $tenantId', isNewline: false);
    // MyLogger.w('sign -> ${argument.sign}', isNewline: false);
    // MyLogger.w('userId -> ${argument.userId}', isNewline: false);
    // MyLogger.w('cert -> ${argument.cert}', isNewline: false);
    // MyLogger.w('token -> $qiChatToken', isNewline: false);
    // MyLogger.w('起聊的wss -> ${state.qichatApiUrl.split('//').last}', isNewline: false);
    
    String lineDetect = await MyConfig.channel.channelQiChat.invokeMethod('lineDetect', <String, dynamic> {
      'baseUrl': argument.apiUrl,
      'tenantId': tenantId,
    }); 

    MyLogger.w('路线选择完毕 -> $lineDetect', isNewline: false);

    final customerInfo = UserController.to.customerHistoryList.value.getHistory(argument.cert);

    if (lineDetect.isNotEmpty) {
      state.qichatApiUrl = 'https://$lineDetect';
      MyLogger.w('正在初始化 SDK', isNewline: false);
      await MyConfig.channel.channelQiChat.invokeMethod('initSDK', <String, dynamic> {
        'wssUrl': lineDetect,
        'cert': argument.cert,
        'token': customerInfo.token,
        'userId': argument.userId,
        'sign': argument.sign,
      });
      MyLogger.w('SDK初始化完毕', isNewline: false);
    } else {
      state.title.value = Lang.connectFailed.tr;
    }
  }

  void sendOrderInfo() {
    final serviceIds = UserController.to.lastCustomerOrderId.split(',');
    final isOrderIdServiced = serviceIds.contains(argument.sysOrderId);
    if (argument.sysOrderId != null && !isOrderIdServiced) {
      String orderInfo = '订单号：${argument.sysOrderId}';
      if (UserController.to.lastCustomerType.isNotEmpty) {
        orderInfo = '问题类型：${UserController.to.lastCustomerType}\n$orderInfo';
      }
      checkSendText(orderInfo);
    }
  }

  void onReplyItem(Qa qa, List<int> openIndex) {
    state.replyOpenIndex.value = openIndex;
    checkSendText(qa.question.content.data);
  }

  void dismiss() {
    state.isOpenEmoticons = false;
    Get.focusScope?.unfocus();
  }

  Future<void> disconnect() async {
     await MyConfig.channel.channelQiChat.invokeMethod('disconnect');
  }

  void moveTab() async {
    if (scrollController.hasClients) {
        scrollController.animateTo(0,
          duration: MyConfig.app.timePageTransition, 
          curve: Curves.linear,
        );
    }
  }

  void checkSendText(String content) {

    // 用户先发一次消息
    final userMessage = QichatUserMessageModel.empty().obs;

    userMessage.value.type = QichatType.text;
    userMessage.value.content = content;
    userMessage.value.createdTime = MyTimer.getNowTime();
    userMessage.value.replyMsgId = state.replyMessage.value.msgId;
    state.chatItems.insert(0, userMessage);
    state.chatItems.refresh();
    moveTab();

    bool isCanSend = true;

    void replyCommon(Qa qa) {
      sendReplyMessage(qa);
      userMessage.value.qichatSendingType = QichatSendingType.success;
      isCanSend = false;
      moveTab();
    }


    for (var element in state.autoReply.autoReplyItem.qa) {
      bool isBreak = false;
      if (element.related.isEmpty) {
        if (element.question.content.data == content) {
          replyCommon(element);
          isBreak = true;
          break;
        }
      } else {
        for (var item in element.related) {
          if (item.question.content.data == content) {
            replyCommon(item);
            isBreak = true;
            break;
          }
        }
      }
      
      if (isBreak) {
        break;
      }
    }

    if (isCanSend) {
      taskQueue.addTask(() async => await sendTask(userMessage));
    }
    inputTextController.text = '';
    clearReply();
  }

  void sendReplyMessage(Qa qa) {
    // 客服发一次回答
    if (qa.content.isNotEmpty) {
      final customerMessageContent = QichatCustomerMessageModel.empty().obs;
      customerMessageContent.value.type = QichatType.text;
      customerMessageContent.value.createdTime = MyTimer.getNowTime();
      customerMessageContent.value.content = qa.content;
      customerMessageContent.value.msgId = '0';
      state.chatItems.insert(0, customerMessageContent);
      state.chatItems.refresh();
    }

    qa.answer.asMap().entries.map((e) {
      // 遍历一下answer里的数据
      final answerMessageContent = QichatCustomerMessageModel.empty().obs;
      answerMessageContent.value.type = QichatType.image;
      answerMessageContent.value.createdTime = MyTimer.getNowTime();
      answerMessageContent.value.content = e.value.image.uri;
      answerMessageContent.value.msgId = '0';
      state.chatItems.insert(0, answerMessageContent);
    }).toList();

    state.chatItems.refresh();
  }

  Future<void> sendTask(Rx<QichatUserMessageModel> message) async {
    final Completer<void> initCompleter = Completer<void>();
    if (message.value.type == QichatType.text) {
      sendText(message.value.content, message.value.replyMsgId);
    } else if (message.value.type == QichatType.image) {
      sendImage(message.value.content, message.value.replyMsgId);
    } else if (message.value.type == QichatType.video) {
      sendVideo(message.value.content, message.value.replyMsgId);
    }

    worker = ever(state.msgId, (v) async {
      message.value.qichatSendingType = QichatSendingType.success;
      message.value.msgId = v;
      message.refresh();

      if (!initCompleter.isCompleted) {
        initCompleter.complete();
      }
    });

    await initCompleter.future;
    worker?.call();
  }

  Future<void> sendText(String content, String replyMsgId) async {
    await MyConfig.channel.channelQiChat.invokeMethod('sendText', {
      'content': content,
      'consultId': state.queryEntrance.consults.first.consultId,
      'replyMsgId': int.parse(replyMsgId),
    });
  }

  Future<void> sendImage(String imageUrl, String replyMsgId) async {
    await MyConfig.channel.channelQiChat.invokeMethod('sendImage', {
      'imageUrl': imageUrl,
      'consultId': state.queryEntrance.consults.first.consultId,
      'replyMsgId': int.parse(replyMsgId),
    });
  }

  Future<void> sendVideo(String videoUrl, String replyMsgId) async {
    await MyConfig.channel.channelQiChat.invokeMethod('sendVideo', {
      'videoUrl': videoUrl,
      'consultId': state.queryEntrance.consults.first.consultId,
      'replyMsgId': int.parse(replyMsgId),
    });
  }

  void clearReply() {
    state.replyMessage.value.content = '';
    state.replyMessage.value.type = QichatType.text;
    state.replyMessage.value.msgId = '0';
    state.replyMessage.refresh();
  }

  void handleMethodCall() {
    MyConfig.channel.channelQiChat.setMethodCallHandler((call) async {
      switch (call.method) {
        case 'msgReceipt':
          final msgId = call.arguments['msgId'] as int?;
          MyLogger.w("收到消息回执: $msgId");
          state.msgId.value = '$msgId';
          state.msgId.refresh();
          break;
        case 'msgDeleted':
          final msgId = call.arguments['msgId'] as int?;
          MyLogger.w("客服已删除消息: $msgId");
          removeMessage("$msgId");
          break;
        case 'receivedMsg':
          final content = call.arguments['content'] as String?;
          final imageUrl = call.arguments['imageUrl'] as String?;
          final video = call.arguments['video'] as String?;
          final msgId = call.arguments['msgId'] as int?;
          final replyMsgId = call.arguments['replyMsgID'] as int?;

          MyLogger.w("收到客服发来的消息: ${content ?? 'null'}", isNewline: false);
          MyLogger.w("收到客服发来的图片: ${imageUrl ?? 'imageUrl'}", isNewline: false);
          MyLogger.w("收到客服发来的视频: ${video ?? 'imageUrl'}", isNewline: false);
          MyLogger.w("收到客服发来的msgID: $msgId", isNewline: false);
          MyLogger.w("收到客服发来的replyMsgID: $replyMsgId", isNewline: false);

          QichatType qichatType = QichatType.text;
          String? contentText = content;

          if (imageUrl != null && imageUrl.isNotEmpty) {
            qichatType = QichatType.image;
            contentText = imageUrl;
          } else if (video != null && video.isNotEmpty) {
            qichatType = QichatType.video;
            contentText = video;
          }

          final model = QichatCustomerMessageModel.empty().obs;
          model.value.type = qichatType;
          model.value.createdTime = MyTimer.getNowTime();
          model.value.content = '$contentText';
          model.value.msgId = '$msgId';
          model.value.replyMsgId = '$replyMsgId';
          
          final isMsgInList = state.chatItems.any((e) => e is Rx<QichatCustomerMessageModel> && e.value.msgId == model.value.msgId);

          if (isMsgInList) {
            editMessage(model.value);
            break;
          }

          state.chatItems.insert(0, model);
          state.chatItems.refresh();

          moveTab();

          break;
        case 'error' || 'systemMsg':
          final code = call.arguments['code'] as int?;
          final msg = call.arguments['msg'] as String?;
          MyLogger.w("收到回调信息: code: $code  msg: $msg");
          state.title.value = '$msg';
          break;
        case 'connected':
          final msg = call.arguments;
          MyLogger.w("wss连接成功: $msg");

          qiChatToken = msg;
          initMyDio();

          await getQueryEntrance();
          await assignWorker();
          await getMessages();
          await autoReply();

          UserController.to.customerHistoryList.value.reset(argument.cert);
          UserController.to.customerHistoryList.refresh();

          state.isLoading = false;
          listener();

          sendOrderInfo();

          break;
        default:
          MyLogger.w('未处理的方法: ${call.method}');
          break;
      }
    });
  }

  // 入口请求
  Future<void> getQueryEntrance() async {
    await state.queryEntrance.update(myDio);
  }

  // 分配客服
  Future<void> assignWorker() async {
    await state.assignWorker.update(myDio, {
      'consultId': state.queryEntrance.consults.first.consultId,
    });
    state.title.value = state.assignWorker.nick;
  }

  // 获取自动回复
  Future<void> autoReply() async {
    await state.autoReply.update(myDio, {
      "consultId": state.queryEntrance.consults.first.consultId,
      "workerId": state.assignWorker.workerId,
    });
    state.chatItems.insert(0, state.autoReply);
    state.chatItems.refresh();
    moveTab();
  }

  void removeMessage(String msgId) {
    if (msgId.isEmpty) return;
    state.chatItems.removeWhere((e) => e is Rx<QichatCustomerMessageModel> && e.value.msgId == msgId);
    state.chatItems.refresh();
  }

  void editMessage(QichatCustomerMessageModel message) {
    if (message.msgId.isEmpty) return;
    for (var e in state.chatItems) {
      if (e is Rx<QichatCustomerMessageModel> && e.value.msgId == message.msgId) {
        e.value = message;
        e.refresh();
      }
    }
  }

  Future<void> upload(MyDio? dio, QichatType qichatType, String filePath, Rx<QichatUserMessageModel> userMessage) async {
    String filepath = '';
    final fileType = filePath.split('.').last.toLowerCase();

    String fileName = '${DateTime.now().millisecondsSinceEpoch}.$fileType';

    if (qichatType == QichatType.video) {
      fileName = '${DateTime.now().millisecondsSinceEpoch}.$fileType';
    }

    // 构建 MultipartFile 对象
    final multipartFile = await MultipartFile.fromFile(
      filePath,
      filename: fileName,
      // contentType: MediaType.parse('application/octet-stream'),
    );

    await dio?.uploadQiChat(ApiPath.qichat.upload,
      data: {
        'myFile': multipartFile,
        'type': '4',
      },
      onSuccess: (code, msg, data) {
        filepath = data != null && data is Map ? data['filepath'] : '';
        userMessage.value.content = filepath;
        taskQueue.addTask(() async => await sendTask(userMessage));
      },
      onError: () {
        userMessage.value.qichatSendingType = QichatSendingType.failed;
        userMessage.refresh();
      },
      onSendProgress: (index, total) {
        MyLogger.w('$index / $total', isNewline: false);
      }
    );
  }

  // 获取消息记录
  Future<void> getMessages() async {
    await state.messages.update(myDio, {
      // "chatId": state.assignWorker.chatId,
      "chatId": 0,
      // "msgId": "0",
      "count": 100,
      "withLastOne": true,
      "workerId": state.assignWorker.workerId,
      "consultId": state.queryEntrance.consults.first.consultId,
      // "userId": argument.userId,
    });

    for (var e in state.messages.list.reversed.toList()) {
      QichatType qichatType = QichatType.text;
      String contentText = e.content.data;

      // CMessage.MessageFormat.MSG_TEXT
      // CMessage.MessageFormat.MSG_IMG
      // CMessage.MessageFormat.MSG_VIDEO

      if (e.msgFmt == 'MSG_IMG') {
        qichatType = QichatType.image;
        contentText = e.image.uri;
      } else if (e.msgFmt == 'MSG_VIDEO') {
        qichatType = QichatType.video;
        contentText = e.video.uri;
      }
      if (e.sender == e.chatId) {        
        final model = QichatUserMessageModel.empty().obs;
        model.value.type = qichatType;
        model.value.createdTime = DateTime.parse(e.msgTime).toLocal().toString().split('.').first;
        model.value.content = contentText;
        model.value.msgId = e.msgId;
        model.value.replyMsgId = e.replyMsgId;
        model.value.qichatSendingType = QichatSendingType.success;
        state.chatItems.insert(0, model);
      } else {
        if(e.msgOp == 'MSG_OP_DELETE') continue;
        final model = QichatCustomerMessageModel.empty().obs;
        model.value.type = qichatType;
        model.value.createdTime = DateTime.parse(e.msgTime).toLocal().toString().split('.').first;
        model.value.content = contentText;
        model.value.msgId = e.msgId;
        model.value.replyMsgId = e.replyMsgId;
        model.value.msgOp = e.msgOp;
        state.chatItems.insert(0, model);
      }
    }

    state.chatItems.refresh();
    moveTab();
  }
}