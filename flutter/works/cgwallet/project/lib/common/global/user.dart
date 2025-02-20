import 'dart:async';
import 'dart:convert';
import 'package:cgwallet/common/common.dart';
import 'package:cgwallet/views/views.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class UserController extends GetxController {
  static UserController get to => Get.find();
  // 初始化等待方法
  final Completer<void> _initCompleter = Completer<void>();
  Future<void> get initComplete => _initCompleter.future;

  // 用户信息
  final userInfo = UserInfoModel.empty().obs;

  // 平台所有的收款类型
  final categoryList = CategoryInfoListModel.empty().obs;

  // 用户的所有银行卡列表
  final bankList = BankAllListModel.empty().obs;

  // 版本信息
  final versionInfo = VersionModel();
  
  // 订单状态
  final orderStatus = OrderStatusListModel.empty().obs;

  // 用户是否已经设置了资金密码
  final isSetWalletPassword = false.obs;

  // 订单配置
  final orderSetting = OrderSettingModel.empty().obs;

  // 深度链接
  List<String>? deepLinkQrcodeResultToList;

  // 活动列表
  final activityList = ActivityListModel.empty().obs;

  // 是否打开过APP
  String isUsedApp = '';

  // 是否检查过更新
  bool isCheckUpdate = false;

  // 是否检查过配置信息
  bool isCheckSetting = false;

  // 上次的客服处理订单ID
  String lastCustomerOrderId = '';

  // 上次的客服处理订单类型
  String lastCustomerType = '';

  // 起聊的BaseUrl地址
  // String qiChatBaseUrl = '';

  // 起聊的ApiUrl
  // String qiChatApiUrl = '';

  // 起聊的imageUrl
  // String qiChatImageUrl = '';

  // baseUrl
  String baseUrl = '';

  // baseUrlList
  List<String> baseUrlList = [];

  // wssUrl
  String wssUrl = '';

  // ws 地址集
  List<String> wssUrlList = [];

  // 客服的数据
  final customerData = CustomerModel.empty().obs;
  // 游客客服的数据
  final guestCustomerData = CustomerModel.empty().obs;

  // dio 服务
  MyDio? dio;

  // wss 服务
  MyWss? wss;

  // 起聊历史记录
  final customerHistoryList = CustomerHistoryListModel.empty().obs;
  final redDot = RedDotModel.empty().obs;

  Timer? customerHistoryTimer;
  Timer? versionRedCheckTimer;

  @override
  void onInit() async {
    super.onInit();
    isUsedApp = await MyShared.to.get(MyConfig.shard.isUsedAppKey);
    await readUserInfo();
    _initCompleter.complete();
  }

  @override
  void onReady() async {
    super.onReady();
    // 初始化深度链接
    initDeepLink();
    checkVersionRedDot();
    lastCustomerOrderId = await MyShared.to.get(MyConfig.shard.serviceChatOrderKey);
  }

  @override
  void onClose() {
    customerHistoryTimer?.cancel();
    versionRedCheckTimer?.cancel();
    super.onClose();
  }

  // 检查是否被风控
  Future<void> checkRiskControlled({void Function()? onNext}) async {
    final isRisk = UserController.to.userInfo.value.user.riskMessage.isNotEmpty && UserController.to.userInfo.value.user.enable == 2;
    if (isRisk) {
      await UserController.to.updateCustomerData();
      final token = await Get.toNamed(MyRoutes.faceVerifiedView, arguments: true);
      if (token != null) {
        bool isCanInitData = true;
        await realNameVerify(token, onError: () async {
          await UserController.to.logout();
          isCanInitData = false;
        });
        if (isCanInitData) {
          onNext?.call();
        }
      } else {
        // await Get.toNamed(MyRoutes.verifiedResultView, arguments: false);
        await UserController.to.logout();
      }
    } else {
      onNext?.call();
    }
  }

  Future<void> readVersionNotice() async {
    versionRedCheckTimer?.cancel();
    await dio?.post(ApiPath.me.readVersionNotice, data: {'id': redDot.value.versionDot});
    UserController.to.redDot.value.versionDot = 0;
    UserController.to.redDot.refresh();
  }

  Future<void> readUserInfo() async {
    final info = await MyShared.to.get(MyConfig.shard.userInfoKey);
    if (info.isNotEmpty) {
      userInfo.value = UserInfoModel.fromJson(jsonDecode(info));
    }
  }

  void clearUserInfo() {
    userInfo.value = UserInfoModel.empty();
    userInfo.refresh();
  }

  Future<void> checkVersionRedDot() async {
    versionRedCheckTimer?.cancel();

    versionRedCheckTimer = Timer.periodic(const Duration(seconds: 120), (timer) async {
      if (userInfo.value.token.isEmpty) {
        return;
      }
      if (UserController.to.redDot.value.versionDot > 0) {
        versionRedCheckTimer?.cancel();
        return;
      }
      await redDot.value.update();
      redDot.refresh();
    });
  }

  Future<void> goLoginView() async {
    dio?.cancel();
    customerHistoryList.value = CustomerHistoryListModel.empty();
    customerHistoryList.refresh();
    redDot.value = RedDotModel.empty();
    redDot.refresh();
    await wss?.close();
    await MyShared.to.delete(MyConfig.shard.userInfoKey);
    clearUserInfo();
    if (Get.currentRoute != MyRoutes.loginView) {
      Get.offAllNamed(MyRoutes.loginView);
    }
    dio?.getNewCancelToken();
    hideLoading();
  }

  Future<void> logout() async {
    if(![MyRoutes.indexView, MyRoutes.loginView].contains(Get.currentRoute)) {
      showLoading();
      await dio?.post(ApiPath.base.logout);
      await goLoginView();
      hideLoading();
    }
  }

  void goCustomerChatView({
    required String apiUrl, 
    required String imageUrl, 
    required String cert,
    String? token,
    String? sysOrderId,
    int? userId,
    String? avatarUrl,
    required String sign,
    required int tenantId,
  }) async {
    final customerChatViewArguments = CustomerChatViewArgumentsModel(
      cert: cert,
      sysOrderId: sysOrderId,
      apiUrl: apiUrl,
      imageUrl: imageUrl,
      userId: userId,
      avatarUrl: avatarUrl,
      sign: sign,
      tenantId: tenantId,
      token: token,
    );

    Get.toNamed(MyRoutes.customerChatView, arguments: customerChatViewArguments);
  }

  Future<void> getAppData() async {
    await Future.wait([
      updateUserInfo(),
      updateBankList(),
      updateIsSetWalletPassword(),
      updateVersion(),
      updateOrderStatus(),
      updateOrderSetting(),
      updateActivityList(),
      updateCustomerData(),
    ]);
  }

  Future<void> updateBankList() async {
    await categoryList.value.update();
    categoryList.refresh();
    await bankList.value.update();
    bankList.refresh();
  }

  Future<void> updateCustomerData() async {
    await customerData.value.update(typeName: [2, 3]);
    customerData.refresh();

    if (customerHistoryList.value.list.isEmpty) {
      customerData.value.customer.map((x) => customerHistoryList.value.list.add(
        CustomerHistoryModel(
            cert: x.cret,
            token: '',
            lastMsgId: '',
            newLength: 0,
            workerId: 0,
            consultId: 0,
            apiUrl: ''
        ),
      )).toList();
      customerHistoryList.refresh();
    }


    // if (qiChatApiUrl.isEmpty) {
    //   List<String> qiChatBaseUrlList = customerData.value.urlApi.split(',');
    //   qiChatApiUrl = await MyTimer.getLowestLatencyUrl(qiChatBaseUrlList);
    // }

    // if (qiChatImageUrl.isEmpty) {
    //   List<String> qiChatImageUrlList = customerData.value.urlImg.split(',');
    //   qiChatImageUrl = await MyTimer.getLowestLatencyUrl(qiChatImageUrlList);
    // }
  }

  Future<void> updateGuestCustomerData() async {
    await guestCustomerData.value.update(typeName: [4]);
    guestCustomerData.refresh();

    // if (qiChatApiUrl.isEmpty) {
    //   List<String> qiChatBaseUrlList = guestCustomerData.value.urlApi.split(',');
    //   qiChatApiUrl = await MyTimer.getLowestLatencyUrl(qiChatBaseUrlList);
    // }

    // if (qiChatImageUrl.isEmpty) {
    //   List<String> qiChatImageUrlList = guestCustomerData.value.urlImg.split(',');
    //   qiChatImageUrl = await MyTimer.getLowestLatencyUrl(qiChatImageUrlList);
    // }
  }

  Future<void> updateUserInfo() async {
    await userInfo.value.update();
    userInfo.refresh();
    MyShared.to.set(MyConfig.shard.userInfoKey, jsonEncode(userInfo.value.toJson()));
  }

  Future<void> updateVersion() async {
    await versionInfo.update();
    isCheckUpdate = true;
  }

  Future<void> updateOrderStatus() async {
    await orderStatus.value.update();
    orderStatus.refresh();
  }

  Future<void> updateOrderSetting() async {
    await orderSetting.value.update();
    orderSetting.refresh();
  }

  Future<void> updateIsSetWalletPassword() async {
    await dio?.post(ApiPath.base.isSetTransPassword,
      onSuccess: (code, msg, result) {
        isSetWalletPassword.value = result as bool;
      },
    );
  }

  Future<void> updateActivityList() async {
    await activityList.value.update();
    activityList.refresh();
  }

  void goSellOrderInfoView(WebsocketMsgModel data) {
    MyAlert.dialog(
      content: data.ext.title,
      confirmText: Lang.goConfirm.tr,
      showCancelButton: false,
      isDismissible: false,
        onConfirm: () async {
          bool isRegistered = Get.isRegistered<SellOrderInfoController>();

          if (isRegistered) {
            Get.until((route) => route.settings.name == MyRoutes.sellOrderInfoView);
            final SellOrderInfoController sellOrderInfoController = Get.find<SellOrderInfoController>();
            showLoading();
            sellOrderInfoController.state.sellOrderArgument.marketOrderId = data.ext.single!.sysOrderId;
            sellOrderInfoController.state.sellOrderArgument.subOrderId = data.extra;
            sellOrderInfoController.state.sellOrderArgument.type = '2';
            await sellOrderInfoController.updateOrderInfo();
            hideLoading();
          } else {
            Get.toNamed(
              MyRoutes.sellOrderInfoView,
              arguments: SellOrderArgument(
                marketOrderId: data.ext.single!.sysOrderId,
                subOrderId: data.extra,
                type: '2',
              ),
            );
          }
        }
    ).then((callBack) {
      if(data.ext.msgType == 1022) {
        final HomeController homeController = Get.find();
        homeController.getUnReadCount();
      }
    });
  }

  void goBuyOrderInfoView(WebsocketMsgModel data) async {
    await MyAlert.dialog(
      content: data.ext.title,
      confirmText: Lang.goConfirm.tr,
      showCancelButton: false,
      isDismissible: false,
      onConfirm: () async {
        bool isRegistered = Get.isRegistered<BuyOrderInfoController>();

        if (isRegistered) {
          Get.until((route) => route.settings.name == MyRoutes.buyOrderInfoView);
          final BuyOrderInfoController buyOrderInfoController = Get.find<BuyOrderInfoController>();
          showLoading();
          buyOrderInfoController.state.id = data.ext.single!.sysOrderId;
          await buyOrderInfoController.onRefresh();
          hideLoading();
        } else {
          Get.toNamed(MyRoutes.buyOrderInfoView, arguments: data.ext.single!.sysOrderId);
        }
      }
    );
  }

  void updateOrderMarket(WebsocketMsgModel data) {
    if (Get.currentRoute == MyRoutes.buyOrderView) {
      final buyOrderController = Get.find<BuyOrderController>();
      for (int i = 0; i < buyOrderController.state.orderMarketList.value.list.length; i++) {
        if (data.ext.memberBroadcast != null && buyOrderController.state.orderMarketList.value.list[i].memberId == data.ext.memberBroadcast!.memberId) {
          buyOrderController.state.orderMarketList.value.list[i].isOnline = data.ext.memberBroadcast!.isOnline;
          buyOrderController.state.orderMarketList.refresh();
        }
      }
    }
  }

  void showBankNotify(WebsocketMsgModel data) async {
    MyAlert.show(
      margin: 40,
      borderRadius: 10,
      child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.center, children: [
        Text(Lang.realNameViewNoticeTitle.tr, style: Get.theme.myStyles.labelBigger),
        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          SizedBox(width: 20, child: data.ext.sysAnnouncementMsg?.first.popupType == 1 ? Get.theme.myIcons.success : Get.theme.myIcons.failed),
          const SizedBox(width: 10),
          Text('${data.ext.sysAnnouncementMsg?.first.title}', style: data.ext.sysAnnouncementMsg?.first.popupType == 1 ? Get.theme.myStyles.labelGreenBigger : Get.theme.myStyles.labelRedBigger),
        ]),
        Text('${data.ext.sysAnnouncementMsg?.first.content}', style: Get.theme.myStyles.label),
        const SizedBox(height: 40),
        MyButton.filedLong(
          onPressed: () => Get.back(),
          text: Lang.iKnown.tr,
          color: Get.theme.myColors.buttonCancel,
          textColor: Get.theme.myColors.onButtonCancel,
        )
      ])
    );

    UserController.to.updateBankList();
  }

  void goFlashOrderInfoView(WebsocketMsgModel data) {
    MyAlert.dialog(
      content: data.ext.title,
      confirmText: Lang.goConfirm.tr,
      onConfirm: () {
        var flashOrderInfo = OrderFlashInfoModel.empty();
        if (data.ext.swapOrderMsg != null) {
          flashOrderInfo = data.ext.swapOrderMsg!;
        }
        if (Get.currentRoute == MyRoutes.flashOrderInfoView) {
          final flashOrderInfoController = Get.find<FlashOrderInfoController>();
          flashOrderInfoController.state.orderInfo.value = flashOrderInfo;
          flashOrderInfoController.state.orderInfo.refresh();
        } else {
          Get.toNamed(MyRoutes.flashOrderInfoView, arguments: flashOrderInfo);
        }
      },
      showCancelButton: false,
    );
  }

  void riskCommon(WebsocketMsgModel data) async {
    if (data.ext.riskType != null && [1, 2, 5].contains(data.ext.riskType)) {
      userInfo.update((val) {
        val!.user.riskMessage = data.ext.title;
      });
      await goFaceVerified();
      return;
    }

    if (data.ext.riskType != null && [3, 4, 6].contains(data.ext.riskType)) {
      if (Get.currentRoute != MyRoutes.loginView) {
        MyAlert.snackbar(data.ext.title);
        showLoading();
        await logout();
        hideLoading();
      }
      return;
    }

    MyAlert.snackbar(data.ext.title);
  }

  void notifyCommon(WebsocketMsgModel data) {
    final json = PublicNoteListModel(list: data.ext.sysAnnouncementMsg!);
    getNoticeBox(data: json);
    final HomeController homeController = Get.find();
    homeController.getUnReadCount();
  }

  void transferCommon(WebsocketMsgModel data) {
    MyAlert.dialog(
      content: data.ext.title, 
      onConfirm: () {
        Get.toNamed(MyRoutes.transferHistoryView);
      },
      confirmText: Lang.goConfirm.tr,
    );

    if (Get.currentRoute == MyRoutes.transferView) {
      final transferController = Get.find<TransferController>();
      transferController.updateOrderTransfer();
    }
  }

  Future<void> goFaceVerified() async {
    final token = await Get.toNamed(MyRoutes.faceVerifiedView, arguments: true);
    if (token != null) {
      await realNameVerify(token, onError: () async {
        showLoading();
        await logout();
        hideLoading();
      });
    } else {
      // await Get.toNamed(MyRoutes.verifiedResultView, arguments: false);
      showLoading();
      await logout();
      hideLoading();
      return;
    }
  }

  Future<void> startCustomerHistoryTimer() async {

    stopCustomerHistoryTimer();

    customerHistoryTimer = Timer.periodic(const Duration(seconds: 20), (timer) async {
      for (var e in customerHistoryList.value.list) {
        if (e.token.isEmpty) {
          continue;
        }
        MyDio? myDio = MyDio(
          baseUrl: e.apiUrl,
          token: e.token,
          isUUID: true,
        );

        final qichatHistory = QichatHistory.empty();
        await qichatHistory.update(myDio, {
          "chatId": 0,
          "count": 100,
          "withLastOne": true,
          "workerId": e.workerId,
          "consultId": e.consultId,
        });

        int index = qichatHistory.list.indexWhere((item) => item.msgId == e.lastMsgId);

        if (index >= 0) {
          e.newLength = index;
        }
        customerHistoryList.refresh();
        myDio.close();
        myDio = null;
      }
    });
  }

  void stopCustomerHistoryTimer() {
    customerHistoryTimer?.cancel();
    customerHistoryTimer = null;
  }
}