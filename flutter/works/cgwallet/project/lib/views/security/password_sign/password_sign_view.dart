import 'package:cgwallet/common/common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:get/get.dart';

import 'index.dart';

class PasswordSignView extends GetView<PasswordSignController> {
  const PasswordSignView({super.key});

  @override
  Widget build(BuildContext context) {
    /// appbar
    var appBar = MyAppBar.normal(
      title: controller.state.title,
    );

    /// 页面构成
    return KeyboardDismissOnTap(child: Scaffold(
      appBar: appBar,
      backgroundColor: Theme.of(context).myColors.background,
      body: _buildBody(context),
    ));
  }

  Widget _buildBody(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
        Text(Lang.passwordSignViewSecondTitle.tr, style: Theme.of(context).myStyles.labelSmall),
        const SizedBox(height: 8),
        Obx(() => Text(UserController.to.userInfo.value.user.phone.hideMiddle(3, 4), style: Theme.of(context).myStyles.labelBiggest)),
        const SizedBox(height: 16),
        MyInput.password(controller.passwordTextController, controller.passwordFocusNode, Lang.passwordSignViewNewHintText.tr),
        const SizedBox(height: 6),
        MyInput.password(controller.rePasswordTextController, controller.rePasswordFocusNode, Lang.passwordSignViewRenewHintText.tr),
        const SizedBox(height: 6),
        MyInput.phoneCode(controller.phoneCodeTextController, controller.phoneCodeFocusNode, phone: UserController.to.userInfo.value.user.phone),
        const SizedBox(height: 32),
        Obx(() => MyButton.filedLong(onPressed: controller.state.isButtonDisable ? null : controller.onChangeSignPassword, text: Lang.passwordSignViewConfirm.tr))
      ]),
    );
  }
}
