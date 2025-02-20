import 'package:cgwallet/common/common.dart';
import 'package:cgwallet/views/views.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import 'index.dart';

class TransferCoinController extends GetxController {
  final state = TransferCoinState();

  final amountController = TextEditingController();
  final amountFocusNode = FocusNode();

  final noteController = TextEditingController();
  final noteFocusNode = FocusNode();

  final PageController pageController = PageController();

  @override
  void onReady() async {
    super.onReady();
    await Future.delayed(MyConfig.app.timePageTransition);
    await updateTransferUser();
    await updateTransferSettings();
    amountController.addListener(listener);
  }

  @override
  void onClose() {
    amountController.removeListener(listener);
    super.onClose();
  }

  Future<void> updateTransferUser() async {
    await state.transferUser.value.update(state.address);
    state.transferUser.refresh();
    if (state.transferUser.value.walletAddress == '000000000000000000') {
      state.isButtonDisable = true;
    } else {
      state.isButtonDisable = false;
    }
  }

  Future<void> updateTransferSettings() async {
    await state.settings.value.update();
    state.settings.refresh();
  }

  void goStepTwo() {
    Get.focusScope?.unfocus();
    state.isButtonDisable = true;
    nextPage();
  }

  Future<void> nextPage() async {
    pageController.nextPage(duration: MyConfig.app.timePageTransition, curve: Curves.linear);
  }

  void listener() {
    if (amountController.text.isNotEmpty) {
      state.isButtonDisable = false;
    } else {
      state.isButtonDisable = true;
    }
  }


  void onTransfer() async {
    Get.focusScope?.unfocus();
    state.isButtonDisable = true;

    final numberPassword = await getNumberPassword();
    if (numberPassword != null) {
      await transfer(numberPassword);
    } else {
      state.isButtonDisable = false;
    }

    // final result = await MyAlert.dialog(
    //   // title: '',
    //   content: Lang.transferViewAlertContent.tr,
    //   onConfirm: () async {
    //     final numberPassword = await getNumberPassword();
    //     if (numberPassword != null) {
    //       await transfer(numberPassword);
    //     } else {
    //       state.isButtonDisable = false;
    //     }
    //   },
    //   onCancel: () {
    //     state.isButtonDisable = false;
    //   },
    //   showCancelButton: false,
    // );
    //
    // if (result == null) {
    //   state.isButtonDisable = false;
    // }
  }

  Future<void> transfer(String numberPassword) async {
    showLoading();
    await UserController.to.dio?.post(ApiPath.transfer.transfer,
      onSuccess: (code, msg, data) async {
        await nextPage();
        Future.delayed(MyConfig.app.timeWait).then((v) => UserController.to.updateUserInfo());
      },
      data: {
        'remark': noteController.text,
        'toWalletAddress': state.address,
        'amount': amountController.text,
        'transPassword': numberPassword.encrypt(MyConfig.key.aesKey),
      },
      onError: () {
        state.isButtonDisable = false;
      },
    );
    hideLoading();
  }
}
