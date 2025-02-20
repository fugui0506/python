import 'package:cgwallet/common/common.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'index.dart';

class SecurityView extends GetView<SecurityController> {
  const SecurityView({super.key});

  @override
  Widget build(BuildContext context) {
    /// appbar
    var appBar = MyAppBar.normal(
      title: controller.state.title,
    );

    /// 页面构成
    return Scaffold(
      appBar: appBar,
      backgroundColor: Theme.of(context).myColors.background,
      body: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    final userName = _buildItem(context, title: Lang.securityViewUserName.tr, content: Obx(() => Text(UserController.to.userInfo.value.user.username, style: Theme.of(context).myStyles.labelSmall)));
    final phone = _buildItem(context, title: Lang.securityViewPhone.tr, content: Obx(() => Text(UserController.to.userInfo.value.user.phone.hideMiddle(3, 4), style: Theme.of(context).myStyles.label)), onPressed: controller.onChangePhone);
    final signPassword = _buildItem(context, title: Lang.securityViewSignPassword.tr, content: const SizedBox(), onPressed: controller.goPasswordSignView);
    final walletPassword = Obx(() => _buildItem(context, title: UserController.to.isSetWalletPassword.value ? Lang.walletPasswordViewTitleReset.tr : Lang.walletPasswordViewTitleSet.tr, content: const SizedBox(), onPressed: controller.goPasswordWalletView));
    final realName =  Obx(() {
      final certified = Text(Lang.securityViewRealNameCertified.tr, style: Theme.of(context).myStyles.labelGreen);
      final certifiedFailed = Text(Lang.securityViewRealNameCertificationFailed.tr, style: Theme.of(context).myStyles.inputError);
      final goToCertified = Text(Lang.securityViewRealNameGoToCertification.tr, style: Theme.of(context).myStyles.label);
      final name = Text(UserController.to.userInfo.value.user.realName.hideMiddle(1, 0), style: Theme.of(context).myStyles.labelSmall);
      Widget content = goToCertified;
      if ([1, 3].contains(UserController.to.userInfo.value.user.isAuth)) {
        content = Row(children: [name, const SizedBox(width: 8), certified]);
      } else if ([2].contains(UserController.to.userInfo.value.user.isAuth)) {
        content = certifiedFailed;
      }
      return _buildItem(
        context, 
        title: Lang.securityViewRealName.tr, 
        content: content, 
        onPressed: [1, 3].contains(UserController.to.userInfo.value.user.isAuth) ? null : controller.goRealNameVerifiedView
      );
    });

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(children: [
        userName,
        const SizedBox(height: 8),
        realName,
        const SizedBox(height: 8),
        phone,
        const SizedBox(height: 8),
        signPassword,
        const SizedBox(height: 8),
        walletPassword,
        
      ],
    ));
  }

  Widget _buildItem(BuildContext context, {
    required String title,
    void Function()? onPressed,
    required Widget content,
  }) {
    final left = Flexible(child: Text(title, style: Theme.of(context).myStyles.label, overflow: TextOverflow.ellipsis));
    final right = Row(children: [content, Theme.of(context).myIcons.right]);
    return MyButton.widget(onPressed: onPressed, child: MyCard.normal(
      color: Theme.of(context).myColors.cardBackground,
      padding: const EdgeInsets.all(16),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        left, const SizedBox(width: 16), onPressed == null ? content : right
      ]),
    ));
  }
}
