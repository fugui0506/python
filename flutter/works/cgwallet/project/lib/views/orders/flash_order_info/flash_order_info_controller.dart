import 'dart:async';

import 'package:cgwallet/common/common.dart';
import 'package:get/get.dart';

import 'index.dart';

class FlashOrderInfoController extends GetxController {
  final state = FlashOrderInfoState();
  final OrderFlashInfoModel arguments = Get.arguments;
  Timer? timer;


  @override
  void onInit() {
    super.onInit();
    state.orderInfo.value = arguments;
    state.orderInfo.refresh();
  }

  @override
  void onClose() {
    timer?.cancel();
    super.onClose();
  }

  @override
  void onReady() async {
    super.onReady();
    await Future.delayed(MyConfig.app.timePageTransition);
    countdown();
  }

  Future<void> updateOrderInfo() async {
    await state.orderInfo.value.update(state.orderInfo.value.sysOrderId);
    state.orderInfo.refresh();
  }

  bool isFialed(OrderFlashInfoModel data) {
    return data.status == 4 || data.status == 5;
  }

  bool isDone(OrderFlashInfoModel data) {
    return data.status == 3 || isFialed(data);
  }

  bool isCancel1(OrderFlashInfoModel data) {
    return data.status == 4 && data.memberConfirmTime.isEmpty;
  }

  bool isCancel2(OrderFlashInfoModel data) {
    return data.status == 4 && data.adminConfirmTime.isEmpty && data.memberConfirmTime.isNotEmpty;
  }

  bool isCancel3(OrderFlashInfoModel data) {
    return data.status == 4 && data.adminConfirmTime.isNotEmpty && data.memberConfirmTime.isNotEmpty;
  }

  void countdown() async {
    timer?.cancel();
    timer = null;
    state.countDown = '00:00';

    if (state.orderInfo.value.memberConfirmLimitTime.isNotEmpty) {
      state.seconds = await MyTimer.getSeconds(startTime: state.orderInfo.value.createdTime, endTime: state.orderInfo.value.memberConfirmLimitTime);
    } else if (state.orderInfo.value.adminConfirmLimitTime.isNotEmpty) {
      state.seconds = await MyTimer.getSeconds(startTime: state.orderInfo.value.memberConfirmTime, endTime: state.orderInfo.value.adminConfirmLimitTime);
    } else {
      return;
    }

    if (state.seconds <= 0) {
      return;
    }

    const interval = Duration(seconds: 1);
    timer = Timer.periodic(interval, (t) {
      if (state.seconds > 0) {
        state.seconds--;
        state.countDown = MyTimer.getDuration(state.seconds);
      } else {
        timer?.cancel();
        timer = null;
        state.seconds = 0;
        state.countDown = '00:00';
        Future.delayed(MyConfig.app.timeWait).then((value) => updateOrderInfo());
      }
    });
  }

  // 我已转账
  Future<void> onPay() async {
    showLoading();
    await UserController.to.dio?.post(ApiPath.swap.pay, 
      onSuccess: (code, msg, results) async {
        await updateOrderInfo();
      },
      data: {
        "orderId" : state.orderInfo.value.sysOrderId,
      },
    );
    hideLoading();
  }
}
