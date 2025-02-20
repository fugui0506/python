import 'dart:async';
import 'dart:convert';

import 'package:cgwallet/common/common.dart';
import 'package:cgwallet/views/views.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BuyOrderInfoController extends GetxController {
  final state = BuyOrderInfoState();
  Timer? timer;

  @override
  void onReady() async {
    super.onReady();
    showLoading();
    await Future.delayed(MyConfig.app.timePageTransition);
    await getOrderInfo();
    hideLoading();
  }

  @override
  void onClose() {
    timer?.cancel();
    super.onClose();
  }

  Future<void> getOrderInfo() async {
    await state.orderSubInfo.value.update(state.id);
    state.orderSubInfo.refresh();
    if ([1, 2, 3].contains(state.orderSubInfo.value.status)) {
      countdown();
    }
  }

  Future<void> onRefresh() async {
    showLoading();
    await getOrderInfo();
    hideLoading();
  }

  void countdown() async {
    timer?.cancel();
    timer = null;
    state.countDown = '00:00';

    if (state.orderSubInfo.value.confirmExpireTime.isNotEmpty) {
      state.seconds = await MyTimer.getSeconds(startTime: state.orderSubInfo.value.createdTime, endTime: state.orderSubInfo.value.confirmExpireTime);
    } else if (state.orderSubInfo.value.payExpireTime.isNotEmpty) {
      state.seconds = await MyTimer.getSeconds(startTime: state.orderSubInfo.value.confirmTime, endTime: state.orderSubInfo.value.payExpireTime);
    } else if (state.orderSubInfo.value.collectionExpireTime.isNotEmpty) {
      state.seconds = await MyTimer.getSeconds(startTime: state.orderSubInfo.value.payTime, endTime: state.orderSubInfo.value.collectionExpireTime);
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
        showLoading();
        await getOrderInfo();
        hideLoading();
        // if (isIng3(state.orderSubInfo.value)) {
        //   showLoading();
        //   await getOrderInfo();
        //   hideLoading();
        // }
      }
    });
  }

  void copy(String data) async {
    await data.copyToClipBoard();
  }

  void goCustomerChatView() {
    if (state.orderSubInfo.value.arbitrationCustomerService.isEmpty) {
      MyAlert.snackbar(Lang.customerNoCert.tr);
      return;
    }
    UserController.to.goCustomerChatView(
      cert: state.orderSubInfo.value.arbitrationCustomerService.first,
      sysOrderId: state.orderSubInfo.value.sysOrderId,
      apiUrl: UserController.to.customerData.value.urlApi,
      imageUrl: UserController.to.customerData.value.urlImg,
      userId: UserController.to.userInfo.value.user.id,
      avatarUrl: UserController.to.userInfo.value.user.avatarUrl,
      tenantId: int.parse(UserController.to.customerData.value.chatUrl),
      sign: UserController.to.customerData.value.sign,
    );
  }

  // void onCancel(OrderSubInfoModel data) async {
  //   MyAlert.dialog(
  //     title: Lang.buyOrderInfoViewOrderCancel.tr,
  //     content: '${Lang.buyOrderInfoViewOrderCancelContent.tr} ${data.sysOrderId}, ${Lang.buyOrderInfoViewOrderCancelContent.tr}',
  //     onConfirm: () => cancelOrder(data),
  //   );
  // }

  void cancelOrder(OrderSubInfoModel data) async {
    Get.back();
    showLoading();
    await UserController.to.dio?.post(ApiPath.market.cancelSubOrder,
      onSuccess: (code, msg, data) {
        Get.back(result: true);
        Future.delayed(MyConfig.app.timeWait).then((v) => UserController.to.updateUserInfo());
      },
      data: {
        "sysOrderId": data.sysOrderId,
        "cancelReason": state.reasons[state.reasonIndex],
      },
    );
    hideLoading();
  }

  void onPickImage(int index) async {
    final file =  await MyGallery.to.pickImage();
    if (file != null) {
      final fileBytes = await file.readAsBytes();
      state.upLoadPaths[index].value = fileBytes;
      state.upLoadPaths[index].refresh();
    }
  }

  void onClearImage(int index) {
    state.upLoadPaths[index].value = [];
    state.upLoadPaths[index].refresh();
  }

  void chooseReason(int index) {
    if (state.reasonIndex != index) {
      state.reasonIndex = index;
    }
  }
  void onUpload(OrderSubInfoModel data) async {
    Get.back();
    showLoading();
    await UserController.to.dio?.post(ApiPath.market.uploadPayPic,
      onSuccess: (code, msg, data) async {
        await getOrderInfo();
      },
      data: {
        "sysOrderId": data.sysOrderId,
        "picUrl": state.upLoadPaths.where((v) => v.isNotEmpty).map((e) => {"picBase64" : base64Encode(e)}).toList(),
      }
    );
    hideLoading();
  }

  void onChangeBankCard(BankInfoModel data) {
    Get.back();
    MyAlert.dialog(
      title: Lang.buyOrderInfoViewChangeBankTitle.tr,
      content: Lang.buyOrderInfoViewChangeBankContent.tr,
      confirmText: Lang.buyOrderInfoViewChangeBankButtonText.tr,
      onConfirm: () => changeBankCard(data),
    );
  }

  Future<void> changeBankCard(BankInfoModel data) async {
    showLoading();
    await UserController.to.dio?.post(ApiPath.market.changeCard,
      onSuccess: (code, msg, data) async {
        await getOrderInfo();
      },
      data: {
        "sysOrderId": state.orderSubInfo.value.sysOrderId,
        "memberAccountCollectId": data.id,
      }
    );
    hideLoading();
  }

  Future<void> goCustomerView() async {
    final serviceIds = UserController.to.lastCustomerOrderId.split(',');
    final isSubOrderIdServiced = serviceIds.contains(state.orderSubInfo.value.sysOrderId);

    if (isSubOrderIdServiced) {
      goCustomerChatView();
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
      for (var item in state.orderSubInfo.value.arbitrationCategory) {
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
                    "sysOrderId": state.orderSubInfo.value.sysOrderId,
                  }
                );
                goCustomerChatView();
              }, text: '进入人工客服');
            }),
          ]),
          Positioned(right: 0, top: 0, child: MyButton.widget(onPressed: () => Get.back(), child: Get.theme.myIcons.close))
        ]),
      );
    }
  }
}
