import 'package:cgwallet/common/common.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import 'index.dart';

class PasswordWalletFindController extends GetxController {
  final state = PasswordWalletFindState();
  
  final passwordTextController = TextEditingController();
  final passwordFocusNode = FocusNode();

  final rePasswordTextController = TextEditingController();
  final rePasswordFocusNode = FocusNode();

  final phoneCodeTextController = TextEditingController();
  final phoneCodeFocusNode = FocusNode();


  final phoneTextController = TextEditingController();
  final phoneFocusNode = FocusNode();

  @override
  void onReady() async {
    super.onReady();
    await Future.delayed(MyConfig.app.timePageTransition);
    textEditingControllerAddLister();
  }

  @override
  void onClose() {
    textEditingControllerDispose();
    super.onClose();
  }

  void listener() {
    if (phoneTextController.text.isEmpty || passwordTextController.text.isEmpty || rePasswordTextController.text.isEmpty || phoneCodeTextController.text.isEmpty) {
      state.isButtonDisable = true;
    } else {
      state.isButtonDisable = false;
    }
  }

  void textEditingControllerAddLister() {
    phoneTextController.addListener(listener);
    passwordTextController.addListener(listener);
    rePasswordTextController.addListener(listener);
    phoneCodeTextController.addListener(listener);
  }

  void textEditingControllerDispose() {
    phoneTextController.removeListener(listener);
    passwordTextController.removeListener(listener);
    rePasswordTextController.removeListener(listener);
    phoneCodeTextController.removeListener(listener);
  }

  Future<void> onChangeSignPassword() async {
    state.isButtonDisable = true;
    showLoading();
    Get.focusScope?.unfocus();

    await UserController.to.dio?.post(ApiPath.base.forgetFundPassword,
        onSuccess: (code, msg, data) async {
          await MyAlert.show(
            margin: 32,
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              const SizedBox(height: 16),
              Get.theme.myIcons.success,
              const SizedBox(height: 16),
              Text('资金密码修改成功', style: Get.theme.myStyles.labelGreenBigger),
              const SizedBox(height: 32),
              MyButton.filedLong(onPressed: () {
                Get.back();
                Get.back();
              }, text: Lang.confirm.tr),
              // const SizedBox(height: 16),
            ]),
          );
          Get.back();
        },
        onError: () {
          state.isButtonDisable = false;
        },
        data: {
          'phone': UserController.to.userInfo.value.user.phone,
          'password': passwordTextController.text.encrypt(MyConfig.key.aesKey),
          'verificationCode':phoneCodeTextController.text,
          'rePassword': rePasswordTextController.text.encrypt(MyConfig.key.aesKey),
        }
    );
    hideLoading();
  }
}
