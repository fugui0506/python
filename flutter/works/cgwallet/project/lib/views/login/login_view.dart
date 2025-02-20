import 'package:cgwallet/common/common.dart';
import 'package:cgwallet/views/views.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';

import 'package:get/get.dart';

class LoginView extends GetView<LoginController> {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return KeyboardDismissOnTap(child: Scaffold(
      // resizeToAvoidBottomInset: false,
      appBar: _buildAppBar(context),
      body: _buildBody(context),
      backgroundColor: Theme.of(context).myColors.background,
    ));
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    // final settingsButton = MyButton.icon(
    //   onPressed: controller.goSettingsView,
    //   icon: Theme.of(context).myIcons.mineViewSettings,
    // );
    return MyAppBar.color(
      color: Theme.of(context).myColors.background.withOpacity( 0),
      actions: [customerButton(), /* settingsButton */],
    );
  }

  Widget _buildBody(BuildContext context) {
    return SingleChildScrollView(child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _buildLogo(context),
        const SizedBox(width: double.infinity, height: 4),
        Text('${Lang.versionViewVersion.tr} ${DeviceService.to.packageInfo.version}'),
        const SizedBox(height: 10),
        _buildContent(context),
      ]
    ));
  }

  Widget _buildTitle(BuildContext context) {
    final loginTitleBackgroundLeft = Theme.of(context).myIcons.loginTitleBackgroundLeft;
    final loginTitleBackgroundRight = Theme.of(context).myIcons.loginTitleBackgroundRight;

    final background = controller.state.signState.value == SignState.loginForPassword || controller.state.signState.value == SignState.loginForCode
      ? Row(children: [loginTitleBackgroundLeft, const Expanded(child: SizedBox())])
      : Row(children: [const Expanded(child: SizedBox()), loginTitleBackgroundRight]);

    final leftSelect = Stack(alignment: AlignmentDirectional.center, children: [
      const SizedBox(width: double.infinity, height: 60),
      Positioned(bottom: 4, child: Theme.of(context).myIcons.loginTitleSelect),
      FittedBox(child: Text(Lang.loginViewTitleLogin.tr, style: Theme.of(context).myStyles.loginTitleSelect)),
    ]);

    final rightSelect = Stack(alignment: AlignmentDirectional.center, children: [
      const SizedBox(width: double.infinity, height: 60),
      Positioned(bottom: 4, child: Theme.of(context).myIcons.loginTitleSelect),
      FittedBox(child: Text(Lang.loginViewTitleRegister.tr, style: Theme.of(context).myStyles.loginTitleSelect)),
    ]);

    final leftUnselect = MyButton.text(onPressed: controller.goLogin, text: Lang.loginViewTitleLogin.tr, fontSize: 16);
    final rightUnselect = MyButton.text(onPressed: controller.goRegister, text: Lang.loginViewTitleRegister.tr, fontSize: 16);

    final left = controller.state.signState.value == SignState.loginForPassword || controller.state.signState.value == SignState.loginForCode
      ? leftSelect
      : leftUnselect;

    final right = controller.state.signState.value == SignState.register
      ? rightSelect
      : rightUnselect;

    final content = Row(children: [Expanded(child: left), Expanded(child: right)]);
    final children = [background, content];

    return Stack(alignment: AlignmentDirectional.center, children: children);
  }

  Widget _buildForgotPasswordTitle(BuildContext context) {
    return Stack(alignment: AlignmentDirectional.center, children: [
      const SizedBox(width: double.infinity, height: 60),
      Positioned(bottom: 4, child: Theme.of(context).myIcons.loginTitleSelect),
      FittedBox(child: Text(Lang.loginViewForgotPassword.tr, style: Theme.of(context).myStyles.loginPasswordTitle)),
    ]);
  }

  Widget _buildContent(BuildContext context) {
    final inputAccount = MyInput.normal(controller.accountTextController, controller.accountFocusNode);
    final inputPassword = MyInput.password(controller.passwordTextController, controller.passwordFocusNode, Lang.inputPasswordHintText.tr);
    final inputRePassword = MyInput.password(controller.rePasswordTextController, controller.rePasswordFocusNode, Lang.inputRePasswordHintText.tr);
    final inputPhone = MyInput.phone(controller.phoneTextController, controller.phoneFocusNode);
    final inputPhoneCode = MyInput.phoneCode(controller.phoneCodeTextController, controller.phoneCodeFocusNode, phoneController: controller.phoneTextController,);

    final loginForPassword = Padding(padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
      child: Column(children: [
        const SizedBox(height: 16),
        inputAccount,
        const SizedBox(height: 6),
        inputPassword,
        // const SizedBox(height: 6),
        // inputCaptcha,
        const SizedBox(height: 10),
        _buildRememberAccountButton(context),
        const SizedBox(height: 32),
        Obx(() => controller.state.isLoading  
          ? MyButton.loading() 
          : MyButton.filedLong(onPressed: controller.state.isButtonDisable ? null : controller.onLoginForPassword, text: Lang.loginViewLogin.tr)),
        _buildLoginForCodeAndFogotPasswordButton(context),
      ]),
    );

    final loginForCode = Padding(padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
      child: Column(children: [
        const SizedBox(height: 16),
        inputPhone,
        const SizedBox(height: 6),
        inputPhoneCode,
        // const SizedBox(height: 6),
        // inputCaptcha,
        const SizedBox(height: 6),
        _buildRememberAccountButton(context),
        const SizedBox(height: 32),
        Obx(() => controller.state.isLoading  
          ? MyButton.loading() 
          : MyButton.filedLong(onPressed: controller.state.isButtonDisable ? null : controller.onLoginForPhoneCode, text: Lang.loginViewLogin.tr)),
        _buildLoginForPasswordAndFogotPasswordButton(context),
      ]),
    );

    final register = Padding(padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
      child: Column(children: [
        const SizedBox(height: 16),
        inputAccount,
        const SizedBox(height: 6),
        inputPassword,
        const SizedBox(height: 6),
        inputRePassword,
        const SizedBox(height: 6),
        inputPhone,
        const SizedBox(height: 6),
        inputPhoneCode,
        const SizedBox(height: 32),
        Obx(() => controller.state.isLoading  
          ? MyButton.loading() 
          : MyButton.filedLong(onPressed: controller.state.isButtonDisable ? null : controller.onRegister, text: Lang.loginViewRegister.tr)),
      ]),
    );

    final fogotPassword = Padding(padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
      child: Column(children: [
        _buildForgotPasswordTitle(context),
        const SizedBox(height: 6),
        inputPhone,
        const SizedBox(height: 6),
        inputPhoneCode,
        const SizedBox(height: 6),
        inputPassword,
        const SizedBox(height: 6),
        inputRePassword,
        const SizedBox(height: 20),
        Obx(() => controller.state.isLoading  
          ? MyButton.loading() 
          : MyButton.filedLong(onPressed: controller.state.isButtonDisable ? null : controller.onForgotPassword, text: Lang.loginViewGetBackPassword.tr)),
        SizedBox(width: double.infinity, child: MyButton.text(onPressed: controller.goLoginForPasswrod, text: Lang.loginViewGoBackLogin.tr)),
      ]),
    );

    return MyCard.login(child: Obx(() => Column(children: [
      if (controller.state.signState.value != SignState.forgotPassword)
        _buildTitle(context),
      if (controller.state.signState.value == SignState.loginForPassword)
        loginForPassword,
      if (controller.state.signState.value == SignState.loginForCode)
        loginForCode,
      if (controller.state.signState.value == SignState.register)
        register,
      if (controller.state.signState.value == SignState.forgotPassword)
        fogotPassword,
    ])));
  }

  Widget _buildLoginForCodeAndFogotPasswordButton(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      MyButton.text(onPressed: controller.goLoginForCode, text: Lang.loginViewLoginForCode.tr, textColor: Theme.of(context).myColors.primary),
      MyButton.text(onPressed: controller.goForgotPassword, text: Lang.loginViewForgotPassword.tr),
    ]);
  }

  Widget _buildLoginForPasswordAndFogotPasswordButton(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      MyButton.text(onPressed: controller.goLoginForPasswrod, text: Lang.loginViewLoginForPassword.tr, textColor: Theme.of(context).myColors.primary),
      MyButton.text(onPressed: controller.goForgotPassword, text: Lang.loginViewForgotPassword.tr),
    ]);
  }

  Widget _buildRememberAccountButton(BuildContext context) {
    final child = Row(children: [
      const SizedBox(width: 8),
      Obx(() => controller.state.isRemenberPassword ? Theme.of(context).myIcons.loginRememberAccount : Theme.of(context).myIcons.loginUnRememberAccount),
      const SizedBox(width: 8),
      Text(Lang.loginViewRememberAccount.tr, style: Theme.of(context).myStyles.label)
    ]);
    return MyButton.widget(onPressed: controller.onRemenberAccount, child: child);
  }

  Widget _buildLogo(BuildContext context) {
    return Theme.of(context).myIcons.logo;
  }
}
