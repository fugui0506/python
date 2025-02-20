import 'package:cgwallet/common/common.dart';
import 'package:cgwallet/views/views.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:get/get.dart';


class PasswordWalletView extends GetView<PasswordWalletController> {
  const PasswordWalletView({super.key});

  @override
  Widget build(BuildContext context) {
    /// 页面构成
    return KeyboardDismissOnTap(child: Obx(() => Scaffold(
      appBar: MyAppBar.normal(
        title: UserController.to.isSetWalletPassword.value 
          ? Lang.walletPasswordViewTitleReset.tr 
          : Lang.walletPasswordViewTitleSet.tr,
        actions: [customerButton()],
      ),
      backgroundColor: Theme.of(context).myColors.background,
      body: _buildBody(context),
    )));
  }

  Widget _buildBody(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Obx(() => Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
        if(UserController.to.isSetWalletPassword.value)
          MyInput.password(controller.oldTextController, controller.oldFocusNode, Lang.walletPasswordViewOld.tr, icon: Theme.of(context).myIcons.newPasswordWallet, keyboardType: TextInputType.number),
        if(UserController.to.isSetWalletPassword.value)
          const SizedBox(height: 6),
        MyInput.password(controller.passwordTextController, controller.passwordFocusNode, Lang.walletPasswordViewNew.tr, icon: Theme.of(context).myIcons.newPasswordWallet, keyboardType: TextInputType.number),
        const SizedBox(height: 6),
        MyInput.password(controller.rePasswordTextController, controller.rePasswordFocusNode, Lang.walletPasswordViewRenew.tr, icon: Theme.of(context).myIcons.newPasswordWallet, keyboardType: TextInputType.number),
        const SizedBox(height: 32),
        Obx(() => MyButton.filedLong(onPressed: controller.state.isButtonDisable ? null : controller.onChangeTransPassword, text: Lang.walletPasswordViewConfirm.tr)),
        MyButton.filedLong(onPressed: () => Get.toNamed(MyRoutes.passwordWalletFindView), text: Lang.walletPasswordFindPassword.tr, color: Colors.transparent, textColor: Theme.of(context).myColors.textDefault),
      ])),
    );
  }
}
