import 'package:cgwallet/common/common.dart';
import 'package:cgwallet/views/views.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:get/get.dart';

class PasswordWalletFindView extends GetView<PasswordWalletFindController> {
  const PasswordWalletFindView({super.key});

  @override
  Widget build(BuildContext context) {
    /// appbar
    var appBar = MyAppBar.normal(
      title: controller.state.title,
      actions: [customerButton()],
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
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('${Lang.phoneNumber.tr} ${UserController.to.userInfo.value.user.phone.hideMiddle(2, 2)}', style: Theme.of(context).myStyles.label),
        const SizedBox(height: 16),
        MyInput.phoneSendCode(controller.phoneTextController, controller.phoneFocusNode, hintText: '请输入手机号码', isCheck: true, loading: controller.state.loading, codeTimer: controller.state.codeTimer),
        const SizedBox(height: 6),
        MyInput.normal(hintText: '请输入验证码', maxLength: 6, keyboardType: TextInputType.number, controller.phoneCodeTextController, controller.phoneCodeFocusNode, prefixIcon: SizedBox(width: 40, height: 40, child: Center(child: SizedBox(width: 20, height: 20, child: Theme.of(context).myIcons.newPhoneCode,)))),
        const SizedBox(height: 6),
        MyInput.password(maxLength: 6,controller.passwordTextController, controller.passwordFocusNode, '请输入新资金密码', icon: Theme.of(context).myIcons.newPasswordWallet, keyboardType: TextInputType.number),
        const SizedBox(height: 6),
        MyInput.password(maxLength: 6,controller.rePasswordTextController, controller.rePasswordFocusNode, '确认资金密码', icon: Theme.of(context).myIcons.newPasswordWallet, keyboardType: TextInputType.number),
        const SizedBox(height: 32),
        Obx(() => MyButton.filedLong(onPressed: controller.state.isButtonDisable ? null : controller.onChangeSignPassword, text: '修改资金密码'))
      ]),
    );
  }
}
