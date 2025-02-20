import 'package:cgwallet/common/common.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'index.dart';

class FlashExchangeController extends GetxController {
  final state = FlashExchangeState();
  final amountController = TextEditingController();
  final amountFocusNode = FocusNode();

  @override
  void onReady() async {
    super.onReady();
    await Future.delayed(MyConfig.app.timePageTransition);
  }

  void resetFlashExchangeViewData() {
    amountController.clear();
    state.amoutCGB = 0;
    state.protocolIndex = 0;
    state.isButtonDisable = true;
  }

  void goFlashExchangeHistroyVew() {
    Get.toNamed(MyRoutes.flashOrderHistoryView);
  }

  void onExchange(BuildContext context) async {
    showLoading();
    await UserController.to.dio?.post<OrderFlashInfoModel>(ApiPath.swap.createSwapOrder,
      onSuccess: (code, msg, results) {
        // 去闪兑详情页面
        resetFlashExchangeViewData();
        Get.toNamed(MyRoutes.flashOrderInfoView, arguments: results);
        Future.delayed(MyConfig.app.timeWait).then((value) => UserController.to.updateUserInfo());
      },
      data: {
        "amount" : double.parse(amountController.text),
        "protocol" : state.swapSetting.value.protocolList[state.protocolIndex],
      },
      onModel: (json) => OrderFlashInfoModel.fromJson(json),
    );

    hideLoading();
  }

  void onChooiseProtocol(int index) {
    state.protocolIndex = index;
    Get.back();
    lister();
  }

  void lister() {
    if (amountController.text.isEmpty || state.protocolIndex == -1) {
      state.isButtonDisable = true;
    } else {
      state.isButtonDisable = false;
    }
  }

  void onChanged(String value) {
    lister();
    if (value.isNotEmpty) {
      state.amoutCGB = double.parse(value) * double.parse(state.swapSetting.value.usdtRate);
    } else {
      state.amoutCGB = 0;
    }
  }

  Future<void> getFlashExchangeData() async {
    await getSwapSetting();
  }
  
  Future<void> getSwapSetting() async {
    await state.swapSetting.value.update();
    state.swapSetting.refresh();
  }
}
