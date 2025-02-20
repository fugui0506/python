import 'dart:async';

import 'package:cgwallet/common/common.dart';
import 'package:cgwallet/views/views.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'index.dart';

class SellOrderInfoController extends GetxController {
  final state = SellOrderInfoState();

  final ScrollController scrollController = ScrollController();

  Timer? timer;

  @override
  void onReady() async {
    super.onReady();
    showLoading();
    await Future.delayed(MyConfig.app.timePageTransition);
    await updateOrderInfo();
    hideLoading();
  }

  @override
  void onClose() async {
    timer?.cancel();
    scrollController.dispose();
    super.onClose();
  }

  Future<void> updateMarketOrderInfo() async {
    await state.orderMarketInfo.value.update(state.sellOrderArgument.marketOrderId, state.sellOrderArgument.type);
    state.orderMarketInfo.refresh();
  }

  Future<void> updateSubOrderInfo() async {
    if (state.sellOrderArgument.subOrderId.isEmpty) {
      return;
    }
    await state.orderSubInfo.value.update(state.sellOrderArgument.subOrderId);
    state.orderSubInfo.refresh();
    if ([1, 2, 3].contains(state.orderSubInfo.value.status)) {
      countdown();
    }  
  }

  void copy(String data) async {
    await data.copyToClipBoard();
  }

  Future<void> updateOrderInfo() async {
    await Future.wait([
      updateMarketOrderInfo(),
      updateSubOrderInfo(),
    ]);
    await moveTab();
  }

  // 移动tab
  Future<void> moveTab() async {
    state.orderMarketIndex = state.orderMarketInfo.value.subOrders.indexWhere((element) => element.sysOrderId == state.orderSubInfo.value.sysOrderId);
    await Future.delayed(MyConfig.app.timePageTransition);
    if (scrollController.hasClients) {
        scrollController.animateTo(
          state.orderMarketIndex == 0 ? 0 :state.orderMarketIndex < state.orderMarketInfo.value.subOrders.length - 1
            ? (state.orderMarketIndex - 1) * (120 + 8) 
            : scrollController.position.maxScrollExtent, 
          duration: MyConfig.app.timePageTransition, 
          curve: Curves.linear,
        );

    }
  }

  Future<void> refreshData() async {
    showLoading();
    await updateOrderInfo();
    hideLoading();
  }

  void countdown() async {
    timer?.cancel();
    timer = null;
    state.countDown = '00:00';

    if (state.orderSubInfo.value.confirmExpireTime.isNotEmpty) {
      state.seconds = await MyTimer.getSeconds(startTime:state.orderSubInfo.value.createdTime, endTime: state.orderSubInfo.value.confirmExpireTime);
    } else if (state.orderSubInfo.value.payExpireTime.isNotEmpty) {
      state.seconds = await MyTimer.getSeconds(startTime:state.orderSubInfo.value.confirmTime, endTime:state.orderSubInfo.value.payExpireTime);
    } else if (state.orderSubInfo.value.collectionExpireTime.isNotEmpty) {
      state.seconds = await MyTimer.getSeconds(startTime:state.orderSubInfo.value.payTime, endTime:state.orderSubInfo.value.collectionExpireTime);
    } else {
      return;
    }

    if (state.seconds <= 0) {
      return;
    }

    const interval = Duration(seconds: 1);
    timer = Timer.periodic(interval, (t) async {
      if (state.seconds > 0) {
        state.seconds--;
        state.countDown = MyTimer.getDuration(state.seconds);
      } else {
        timer?.cancel();
        timer = null;
        state.seconds = 0;
        state.countDown = '00:00';
        await refreshData();
      }
    });
  }

  Future<void> onChooseSubOrder(MapEntry<int, OrderSubInfoModel> data) async {
    if (state.orderMarketIndex == data.key) {
      return;
    } else {
      state.orderMarketIndex = data.key;
      state.sellOrderArgument.subOrderId = data.value.sysOrderId;
      state.orderSubInfo.value = data.value;
      state.orderSubInfo.refresh();
      moveTab();
    }
  }

  void onConfirmOrder(OrderSubInfoModel data) {
    MyAlert.dialog(
      title: Lang.sellOrderInfoViewConfirmButtonText.tr,
      content: Lang.sellOrderInfoViewConfirmAlertContent.tr,
      onConfirm: () => confirmOrder(data),
    );
  }

  void onCancelConfirmOrder(OrderSubInfoModel data) {
    MyAlert.dialog(
      title: Lang.sellOrderInfoViewCancelAlertTitle.tr,
      content: '${Lang.sellOrderInfoViewCancelAlertContent.tr}\n${data.sysOrderId}\n${Lang.isContinue.tr}',
      onConfirm: () => cancelConfirmOrder(data),
    );
  }

  void onCancelOrder() {
    MyAlert.dialog(
      title: Lang.sellOrderInfoViewCancelAlertTitle.tr,
      content: '${Lang.sellOrderInfoViewCancelAlertContent.tr}\n${state.orderMarketInfo.value.sysOrderId}\n${Lang.isContinue.tr}',
      onConfirm: () => cancelOrder(),
    );
  }

  void onCustomer(OrderMarketInfoModel data, OrderSubInfoModel subData) {
    MyAlert.dialog(
      title: Lang.sellOrderInfoViewCustomerTitle.tr,
      content: Lang.sellOrderInfoViewCustomerContent.tr,
      onConfirm: () => goCustomerChatView(data, subData)
    );
  }

  void goCustomerChatView(OrderMarketInfoModel data, OrderSubInfoModel subData) {
    if (data.arbitrationCustomerService.isEmpty) {
      MyAlert.snackbar(Lang.customerNoCert.tr);
      return;
    }
    UserController.to.goCustomerChatView(
      cert: data.arbitrationCustomerService.first,
      sysOrderId: subData.sysOrderId.isNotEmpty && !subData.sysOrderId.contains('*') ? subData.sysOrderId : data.sysOrderId,
      apiUrl: UserController.to.customerData.value.urlApi,
      imageUrl: UserController.to.customerData.value.urlImg,
      userId: UserController.to.userInfo.value.user.id,
      avatarUrl: UserController.to.userInfo.value.user.avatarUrl,
      tenantId: int.parse(UserController.to.customerData.value.chatUrl),
      sign: UserController.to.customerData.value.sign,
    );
  }

  Future<void> confirmOrder(OrderSubInfoModel data) async {
    showLoading();
    await UserController.to.dio?.post(ApiPath.market.confirmOrder,
      onSuccess: (code, msg, data) async {
        await updateOrderInfo();
      },
      data: {"sysOrderId": data.sysOrderId}
    );
    hideLoading();
  }

  Future<void> pass(OrderSubInfoModel data) async {
    Get.back();
    showLoading();
    await UserController.to.dio?.post(ApiPath.market.pass,
      onSuccess: (code, msg, data) async {
        await updateOrderInfo();
        Future.delayed(MyConfig.app.timeWait).then((value) => UserController.to.updateUserInfo());
      },
      data: {"sysOrderId": data.sysOrderId}
    );
    hideLoading();
  }

  Future<void> passDelay(OrderSubInfoModel data) async {
    Get.back();
    showLoading();
    await UserController.to.dio?.post(ApiPath.market.passDelay,
      onSuccess: (code, msg, result) async {
        await updateOrderInfo();
        Future.delayed(Duration(milliseconds: data.delayedSettlementTime * 1000 * 60 + 2000)).then((value) => UserController.to.updateUserInfo());
      },
      data: {"sysOrderId": data.sysOrderId}
    );
    hideLoading();
  }

  Future<void> cancelOrder() async {
    showLoading();
    await UserController.to.dio?.post(ApiPath.market.cancelOrder,
      onSuccess: (code, msg, data) async {
        Get.back();
        Future.delayed(MyConfig.app.timeWait).then((v) => UserController.to.updateUserInfo());
      },
      data: {"sysOrderId": state.orderMarketInfo.value.sysOrderId}
    );
    hideLoading();
  }

  Future<void> changePay(OrderSubInfoModel data, int isAgree) async {
    showLoading();
    await UserController.to.dio?.post(ApiPath.market.changePay,
      onSuccess: (code, msg, data) async {
        await updateOrderInfo();
      },
      data: {"sysOrderId": data.sysOrderId, "isAgree": isAgree}
    );
    hideLoading();
  }

  Future<void> cancelConfirmOrder(OrderSubInfoModel data) async {
    showLoading();
    await UserController.to.dio?.post(ApiPath.market.cancelConfirmOrder,
      onSuccess: (code, msg, data) async {
        await updateOrderInfo();
      },
      data: {"sysOrderId": data.sysOrderId}
    );
    hideLoading();
  }

  Future<void> goCustomerView() async {
    final serviceIds = UserController.to.lastCustomerOrderId.split(',');
    final isMarketOrderIdServiced = state.orderMarketInfo.value.subOrders.isEmpty && serviceIds.contains(state.orderMarketInfo.value.sysOrderId);
    final isSubOrderIdServiced = serviceIds.contains(state.orderSubInfo.value.sysOrderId);
    if (isMarketOrderIdServiced || isSubOrderIdServiced) {
      goCustomerChatView(state.orderMarketInfo.value, state.orderSubInfo.value);
    } else {
      final arbitrationType = 0.obs;

      final result = await MyAlert.show(
        child: Stack(children: [
          Column(mainAxisSize: MainAxisSize.min, children: [
            Text('请选择咨询问题类型', style: Get.theme.myStyles.labelBigger),
            const SizedBox(height: 32),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              MyButton.widget(onPressed: () => arbitrationType.value == 1 ? arbitrationType.value = 0 : arbitrationType.value = 1, child: Obx(() => arbitrationType.value == 1 ? Get.theme.myIcons.iAmSeller_1 : Get.theme.myIcons.iAmBuyer_0)),
              const SizedBox(width: 10),
              MyButton.widget(onPressed: () => arbitrationType.value == 2 ? arbitrationType.value = 0 : arbitrationType.value = 2, child: Obx(() => arbitrationType.value == 2 ? Get.theme.myIcons.iAmBuyer_1 : Get.theme.myIcons.iAmSeller_0)),
            ]),
            const SizedBox(height: 32),
            Obx(() {
              return Padding(padding: const EdgeInsets.symmetric(horizontal: 24),child: MyButton.filedLong(onPressed: arbitrationType <= 0 ? null : () {
                Get.back(result: true);
              }, text: '立即咨询'),);
            }),
          ]),
          Positioned(right: 0, top: 0, child: MyButton.widget(onPressed: () => Get.back(), child: Get.theme.myIcons.close))
        ]),
      );

      if (result == null) {
        return;
      }

      List<ArbitrationCategory> arbitrationCategory = [];
      for (var item in state.orderMarketInfo.value.arbitrationCategory) {
        if (item.arbitrationType == arbitrationType.value) {
          arbitrationCategory.add(item);
        }
      }

      // if (arbitrationCategory.isEmpty) {
      //   return;
      // }

      String categoryName = '';
      int categoryId = -1;

      MyAlert.show(
        child: Stack(children: [
          Column(mainAxisSize: MainAxisSize.min, children: [
            Text('请选择咨询问题类型', style: Get.theme.myStyles.labelBigger),
            const SizedBox(height: 24),
            Flexible(child: SingleChildScrollView(
              child: Column(children: arbitrationCategory.asMap().entries.map((e) => Obx(() {
                return MyButton.widget(onPressed: () {
                  state.customerType = state.customerType == e.key ? -1 : e.key;
                  if (state.customerType == -1) {
                    categoryName = '';
                    categoryId = -1;
                  } else {
                    categoryName = e.value.categoryName;
                    categoryId = e.value.categoryId;
                  }
                }, child: MyCard(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  margin: const EdgeInsets.only(bottom: 8),
                  color: Get.theme.myColors.buttonCancel.withOpacity( 0.3),
                  borderRadius: BorderRadius.circular(10),
                  child: Row(children: [
                    Expanded(child: Row(children: [
                      SizedBox(width: 20, child: Text('${e.key + 1}', style: Get.theme.myStyles.labelPrimary)),
                      Text(e.value.categoryName, style: Get.theme.myStyles.labelPrimary, overflow: TextOverflow.ellipsis),
                    ])),
                    const SizedBox(width: 8),
                    MyCard(
                      width: 16,
                      height: 16,
                      borderRadius: BorderRadius.circular(4),
                      color: state.customerType == e.key ? Get.theme.myColors.primary : Colors.transparent,
                      border: Border.all(color: state.customerType == e.key ? Get.theme.myColors.primary : Get.theme.myColors.buttonDisable, width: 2),
                      child: state.customerType == e.key ? Center(child: Icon(Icons.check, color: Get.theme.myColors.light, size: 12)) : null
                    ),
                  ]),
                ));
              })).toList()),
            ),),
            const SizedBox(height: 16),
            Obx(() {
              return MyButton.filedLong(onPressed: state.customerType < 0 ? null : () {
                Get.back();
                // UserController.to.lastCustomerOrderId = controller.state.orderSubInfo.value.sysOrderId;
                UserController.to.lastCustomerType = categoryName;
                UserController.to.dio?.post(ApiPath.me.countArbitrationType,
                  data: {
                    "categoryId": categoryId,
                    "categoryName": categoryName,
                    "sysOrderId": state.orderMarketInfo.value.subOrders.isEmpty ? state.orderMarketInfo.value.sysOrderId : state.orderSubInfo.value.sysOrderId,
                  }
                );
                goCustomerChatView(state.orderMarketInfo.value, state.orderSubInfo.value);
              }, text: '进入人工客服');
            }),
          ]),
          Positioned(right: 0, top: 0, child: MyButton.widget(onPressed: () => Get.back(), child: Get.theme.myIcons.close))
        ]),
      );
    }
  }
}
