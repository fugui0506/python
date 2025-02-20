import 'package:cgwallet/common/common.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import 'index.dart';

class PasswordSignController extends GetxController {
  final state = PasswordSignState();

  final passwordTextController = TextEditingController();
  final passwordFocusNode = FocusNode();

  final rePasswordTextController = TextEditingController();
  final rePasswordFocusNode = FocusNode();

  final phoneCodeTextController = TextEditingController();
  final phoneCodeFocusNode = FocusNode();

  @override
  void onReady() async {
    super.onReady();
    await Future.delayed(MyConfig.app.timePageTransition);
    textEditingControllerAddLinster();
  }

  @override
  void onClose() {
    textEditingControllerDispose();
    super.onClose();
  }

  void linster() {
    if (passwordTextController.text.isEmpty || rePasswordTextController.text.isEmpty || phoneCodeTextController.text.isEmpty) {
      state.isButtonDisable = true;
    } else {
      state.isButtonDisable = false;
    }
  }

  void textEditingControllerAddLinster() {
    passwordTextController.addListener(linster);
    rePasswordTextController.addListener(linster);
    phoneCodeTextController.addListener(linster);
  }

  void textEditingControllerDispose() {
    passwordTextController.removeListener(linster);
    rePasswordTextController.removeListener(linster);
    phoneCodeTextController.removeListener(linster);
  }

  Future<void> onChangeSignPassword() async {
    state.isButtonDisable = true;
    showLoading();
    Get.focusScope?.unfocus();
    
    await UserController.to.dio?.post(ApiPath.base.changePassword,
      onSuccess: (code, msg, data) async {
        MyAlert.snackbar(msg);
        await UserController.to.logout();
      },
      onError: () {
        state.isButtonDisable = false;
      },
      data: {
        'phone': UserController.to.userInfo.value.user.phone,
        'newPassword': passwordTextController.text.encrypt(MyConfig.key.aesKey),
        'verificationCode':phoneCodeTextController.text,
        'reNewPassword': rePasswordTextController.text.encrypt(MyConfig.key.aesKey),
      }
    );
    hideLoading();
  }
}
