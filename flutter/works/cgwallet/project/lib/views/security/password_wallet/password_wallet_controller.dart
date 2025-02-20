import 'package:cgwallet/common/common.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import 'index.dart';

class PasswordWalletController extends GetxController {
  final state = PasswordWalletState();

  final passwordTextController = TextEditingController();
  final passwordFocusNode = FocusNode();

  final rePasswordTextController = TextEditingController();
  final rePasswordFocusNode = FocusNode();

  final oldTextController = TextEditingController();
  final oldFocusNode = FocusNode();

  @override
  void onReady() async {
    if (!UserController.to.isSetWalletPassword.value) {
      showLoading();
    }
    super.onReady();
    await Future.delayed(MyConfig.app.timePageTransition);
    textEditingControllerAddLinster();
    if (!UserController.to.isSetWalletPassword.value) {
      await UserController.to.updateIsSetWalletPassword();
      hideLoading();
    }
  }

  @override
  void onClose() {
    textEditingControllerDispose();
    super.onClose();
  }

  void linster() {
    if (UserController.to.isSetWalletPassword.value) {
      if (passwordTextController.text.isEmpty || rePasswordTextController.text.isEmpty || oldTextController.text.isEmpty) {
        state.isButtonDisable = true;
      } else {
        state.isButtonDisable = false;
      }
    } else {
      if (passwordTextController.text.isEmpty || rePasswordTextController.text.isEmpty) {
        state.isButtonDisable = true;
      } else {
        state.isButtonDisable = false;
      }
    }
    
  }

  void textEditingControllerAddLinster() {
    passwordTextController.addListener(linster);
    rePasswordTextController.addListener(linster);
    oldTextController.addListener(linster);
  }

  void textEditingControllerDispose() {
    passwordTextController.removeListener(linster);
    rePasswordTextController.removeListener(linster);
    oldTextController.removeListener(linster);
  }

  Future<void> onChangeTransPassword() async {
    showLoading();
    state.isButtonDisable = true;
    Get.focusScope?.unfocus();
    UserController.to.isSetWalletPassword.value ? await resetPassword() : await setPassword();
    await UserController.to.updateUserInfo();
    hideLoading();
  }

  Future<void> resetPassword() async {
    await UserController.to.dio?.post(ApiPath.base.changeTransPassword,
      onSuccess: (code, msg, data) {
        Get.back();
        MyAlert.snackbar(msg);
        UserController.to.updateIsSetWalletPassword();
      },
      onError: () {
        state.isButtonDisable = false;
      },
      data: {
        'newPassword': passwordTextController.text.encrypt(MyConfig.key.aesKey),
        'oldPassword': oldTextController.text.encrypt(MyConfig.key.aesKey),
        'reNewPassword': rePasswordTextController.text.encrypt(MyConfig.key.aesKey),
      }
    );
  }

  Future<void> setPassword() async {
    await UserController.to.dio?.post(ApiPath.base.setTransPassword,
      onSuccess: (code, msg, data) {
        Get.back(result: true);
        MyAlert.snackbar(msg);
        UserController.to.updateIsSetWalletPassword();
      },
      onError: () {
        state.isButtonDisable = false;
      },
      data: {
        'password': passwordTextController.text.encrypt(MyConfig.key.aesKey),
        'rePassword': rePasswordTextController.text.encrypt(MyConfig.key.aesKey),
      }
    );
  }
}
