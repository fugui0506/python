import 'dart:typed_data';

import 'package:cgwallet/common/common.dart';
import 'package:cgwallet/views/views.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:get/get.dart';

import 'index.dart';

class WalletAddView extends GetView<WalletAddController> {
  const WalletAddView({super.key});

  @override
  Widget build(BuildContext context) {
    /// appbar
    var appBar = MyAppBar.normalWidget(
      title: Obx(() => Text('${Lang.walletAddViewTitle.tr}${controller.state.accountType}', maxLines: 1)),
    );

    /// 页面构成
    return KeyboardDismissOnTap(child: Scaffold(
      appBar: appBar,
      backgroundColor: Theme.of(context).myColors.background,
      body: _buildBody(context),
    ));
  }

  Widget _buildBody(BuildContext context) {
    return Column(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Flexible(child: _buildContent(context)),
      _buildFooter(context),
    ]);
  }

  Widget _buildContent(BuildContext context) {
    return MyCard.normal(
      color: Theme.of(context).myColors.cardBackground,
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 0),
      child: _buildForm(context),
    );
  }

  Widget _buildFooter(BuildContext context) {
    return SafeArea(
      minimum: const EdgeInsets.all(16),
      child: Obx(() => controller.state.isLoading
        ? MyButton.loading() 
        : MyButton.filedLong(onPressed: controller.state.isButtonDisable ? null : controller.onAdd, text: Lang.confirm.tr)
      ),
    );
  }

  Widget _buildForm(BuildContext context) {
    final buttonAccountType = MyButton.widget(onPressed: controller.onAccountType, child: MyCard.normal(
      color: Theme.of(context).myColors.inputBank,
      padding: const EdgeInsets.all(16),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Flexible(child: Text(Lang.walletAddViewAccountType.tr, style: Theme.of(context).myStyles.inputText, overflow: TextOverflow.ellipsis)),
        const SizedBox(width: 10),
        Row(children: [
          Obx(() => MyImage(imageUrl: UserController.to.categoryList.value.list[controller.state.index].icon, height: 20)),
          const SizedBox(width: 10),
          Obx(() => Text(UserController.to.categoryList.value.list[controller.state.index].categoryName, style: Theme.of(context).myStyles.label)),
          const SizedBox(width: 4),
          Theme.of(context).myIcons.downSolid,
        ]),
      ]),
    ));
    final inputName = Obx(() => MyInput.textIcon(controller.nameTextController, controller.nameFocusNode, 
      title: Lang.walletAddViewName.tr, 
      hintText: Lang.walletAddViewNameHintText.tr,
      enabled: UserController.to.userInfo.value.user.realName.isEmpty,
    ));
    final inputBank = MyInput.textIcon(controller.bankTextController, controller.bankFocusNode, 
      title: Lang.walletAddViewBank.tr, 
      hintText: Lang.walletAddViewBankHintText.tr
    );
    final inputAlipay = MyInput.textIcon(controller.alipayTextController, controller.alipayFocusNode, 
      title: Lang.walletAddViewAlipayAccount.tr, 
      hintText: Lang.walletAddViewAlipayAccountHintText.tr
    );
    final inputAddress = MyInput.textIcon(controller.addressTextController, controller.addressFocusNode, 
      title: Lang.walletAddViewAddress.tr, 
      hintText: Lang.walletAddViewAddressHintText.tr
    );
    final bankName = MyButton.widget(onPressed: controller.goBanksView, child: MyCard.normal(
      color: Theme.of(context).myColors.inputBank,
      padding: const EdgeInsets.all(16),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Flexible(child: Text(Lang.walletAddViewBankName.tr, style: Theme.of(context).myStyles.inputText, overflow: TextOverflow.ellipsis)),
        const SizedBox(width: 10),
        Row(children: [
          Obx(() => Text(controller.state.bank.value.bankName, style: Theme.of(context).myStyles.label)),
          Theme.of(context).myIcons.right,
        ]),
      ]),
    ));
    final uploadButton = MyButton.widget(onPressed: controller.onPickImage, child: MyCard.normal(
      color: Theme.of(context).myColors.inputBank,
      padding: const EdgeInsets.all(8),
      child: Obx(() => controller.state.imageBytes.isEmpty 
        ? Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Theme.of(context).myIcons.add,
            const SizedBox(height: 20),
            Text(Lang.walletAddViewQrcodeUpload.tr, style: Theme.of(context).myStyles.labelSmall),
          ]) 
        : Image.memory(Uint8List.fromList(controller.state.imageBytes), fit: BoxFit.cover)),
    ));
    final qrcode = Column(children: [
      Row(children: [
        Expanded(child: Container(color: Theme.of(context).myColors.inputBorder.withOpacity( 0.3), height: 1)),
        const SizedBox(width: 20),
        Text(Lang.walletAddViewQrcode.tr, style: Theme.of(context).myStyles.labelSmall),
        const SizedBox(width: 20),
        Expanded(child: Container(color: Theme.of(context).myColors.inputBorder.withOpacity( 0.3), height: 1)),
      ]),
      const SizedBox(height: 20),
      SizedBox(width: Get.width / 2.5, height: Get.width / 2.5, child: uploadButton),
    ]);

    final alipayType = Row(children: [
      Expanded(child: Obx(() => MyButton.filedShort(
        onPressed: () => controller.state.alipayIndex = 0, 
        text: Lang.walletAddViewAlipayAccount.tr, 
        color: controller.state.alipayIndex == 0 ? Theme.of(context).myColors.primary : Theme.of(context).myColors.inputBank,
        textColor: controller.state.alipayIndex == 0 ? Theme.of(context).myColors.onPrimary : Theme.of(context).myColors.onCardBackground,
      ))),
      const SizedBox(width: 8),
      Expanded(child: Obx(() => MyButton.filedShort(
        onPressed: () => controller.state.alipayIndex = 1, 
        text: Lang.walletAddViewQrcode.tr, 
        color: controller.state.alipayIndex == 1 ? Theme.of(context).myColors.primary : Theme.of(context).myColors.inputBank,
        textColor: controller.state.alipayIndex == 1 ? Theme.of(context).myColors.onPrimary : Theme.of(context).myColors.onCardBackground,
      ))),
    ]);

    final bankBox = [
      buttonAccountType,
      const SizedBox(height: 8),
      inputName,
      const SizedBox(height: 8),
      inputBank,
      const SizedBox(height: 8),
      bankName,
    ];

    final alipayBox0 = [
      buttonAccountType,
      const SizedBox(height: 8),
      inputName,
      const SizedBox(height: 8),
      alipayType,
      const SizedBox(height: 8),
      inputAlipay,
    ];

    final alipayBox1 = [
      buttonAccountType,
      const SizedBox(height: 8),
      inputName,
      const SizedBox(height: 8),
      alipayType,
      const SizedBox(height: 20),
      qrcode,
    ];

    final addressBox = [
      buttonAccountType,
      const SizedBox(height: 8),
      inputName,
      const SizedBox(height: 8),
      inputAddress,
    ];

    final wachatBox = [
      buttonAccountType,
      const SizedBox(height: 8),
      inputName,
      const SizedBox(height: 20),
      qrcode,
    ];

    return SingleChildScrollView(child: Obx(() => Column(children: [3].contains(UserController.to.categoryList.value.list[controller.state.index].id)
    ? bankBox 
    : [2].contains(UserController.to.categoryList.value.list[controller.state.index].id)
      ? controller.state.alipayIndex == 0 ? alipayBox0 : alipayBox1 
      : [1].contains(UserController.to.categoryList.value.list[controller.state.index].id)
        ? addressBox 
        : wachatBox
      ))
    );
  }
}
