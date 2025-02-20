import 'dart:async';
import 'package:cgwallet/common/common.dart';
import 'package:get/get.dart';
import 'pay_index.dart';

class PayController extends GetxController {
  final state = PayState();

  Timer? timer;

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments != null) {
      state.data.value = Get.arguments;
    }
  }

  @override
  void onReady() async {
    super.onReady();
    // if (Get.arguments == null) {
    //   Get.back();
    // }
    if (await MyTimer.getSeconds(startTime: state.data[7], endTime: state.data[8]) > 0) {
      countdown( await MyTimer.getSeconds(startTime: state.data[7], endTime: state.data[8]));
    } else {
      state.payed = 2;
    }
  }

  @override
  void onClose() {
    timer?.cancel();
    timer = null;
    super.onClose();
  }

  void pay() async {
    final result = await getNumberPassword();

    if (result != null) {
      showLoading();
      await UserController.to.dio?.post(ApiPath.transfer.pay, 
        onSuccess: (code, msg, results) {
          state.payed = 1;
          Future.delayed(MyConfig.app.timeWait).then((value) => updateUserInfoAndActivityList());
        }, data: {
          "platformOrderId": state.data[2],
          "platformName": state.data[4],
          "amount": state.data[3],
          "transPassword": result.encrypt(MyConfig.key.aesKey),
          "sign": state.data[5]
        },
        onError: () {
        }
      );
      hideLoading();
    }
  }

  void updateUserInfoAndActivityList() {
    UserController.to.updateUserInfo();
    UserController.to.updateActivityList();
  }

  void copyId() {
    state.data[2].copyToClipBoard();
  }

  void countdown(int seconds) {
    if (seconds <= 0) {
      return;
    }
    timer?.cancel();
    timer = null;
    state.seconds = 0;
    state.countDown = MyTimer.getDuration(state.seconds);

    state.seconds = seconds;
    const interval = Duration(seconds: 1);
    timer = Timer.periodic(interval, (t) {
      if (state.seconds > 0) {
        state.seconds--;
        state.countDown = MyTimer.getDuration(state.seconds);
      } else {
        timer?.cancel();
        timer = null;
        state.seconds = 0;
        state.countDown = MyTimer.getDuration(state.seconds);
        state.payed = 2;
      }
    });
  }
}
