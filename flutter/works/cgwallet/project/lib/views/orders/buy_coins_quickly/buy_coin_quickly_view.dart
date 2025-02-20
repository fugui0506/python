import 'package:cgwallet/common/common.dart';
import 'package:cgwallet/views/views.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:get/get.dart';

class BuyCoinsQuicklyView extends GetView<BuyCoinsQuicklyController> {
  const BuyCoinsQuicklyView({super.key});

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
    return Column(children: [
      Expanded(child: _buildScrollView(context)),
      _buildButton(context),
    ]);
  }

  Widget _buildScrollView(BuildContext context) {
    MyLogger.w(UserController.to.orderSetting.value.toJson());
    return SingleChildScrollView(padding: const EdgeInsets.fromLTRB(16, 0, 16, 0), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(Lang.buyCoinsQuicklyViewPayType.tr, style: Theme.of(context).myStyles.label),
      const SizedBox(height: 8, width: double.infinity),
      Wrap(
        spacing: 10,
        runSpacing: 10,
        children: UserController.to.categoryList.value.list.asMap().entries.map((e) => _buildCategoryItem(context, e)).toList(),
      ),
      const SizedBox(height: 16, width: double.infinity),
      Text(Lang.buyCoinsQuicklyViewAmount.tr, style: Theme.of(context).myStyles.label),
      const SizedBox(height: 8, width: double.infinity),
      Obx(() => MyInput.normal(
        controller.amountController, 
        controller.amountFocusNode, 
        color: controller.state.amountIndex == 1 ? Theme.of(context).myColors.cardBackground : Theme.of(context).myColors.cardBackground,
        keyboardType: TextInputType.number,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        hintText: Lang.buyCoinsQuicklyViewAmountHintText.tr, 
        prefixIcon: SizedBox(width: 40, height: 40, child: Center(child: SizedBox(width: 20, height: 20, child: Theme.of(context).myIcons.coinCgb))),
      )),
      const SizedBox(height: 8, width: double.infinity),
      Obx(() => UserController.to.orderSetting.value.quicklyBuyAmountList[UserController.to.categoryList.value.list[0].payCategorySn].toString().isEmpty ? const SizedBox() : Wrap(
        spacing: 8,
        runSpacing: 8,
        children: controller.state.amounts.asMap().entries.map((e) => _buildAmountItem(context, e)).toList(),
      )),
      const SizedBox(height: 16, width: double.infinity),
      Text(Lang.buyCoinsQuicklyViewPayAccount.tr, style: Theme.of(context).myStyles.label),
      const SizedBox(height: 8, width: double.infinity),
      Obx(() => controller.state.categoryIndex == -1 ? const SizedBox() : controller.state.bankInfo.id == -1
        ? MyButton.widget(onPressed: controller.goWalletAddView, child: getBankInfoEmptyWidget(controller.state.bankInfo.categoryName)) 
        : MyButton.widget(onPressed: () => showAllBanks(context), child: BankInfoCard(
            bankInfo: controller.state.bankInfo, 
            title: Lang.buyCoinsQuicklyViewPayAccount.tr, 
            icon: Theme.of(context).myIcons.downSolid,
          ))),
    ]));
  }

  void showAllBanks(BuildContext context) {
    final bankInfoList = UserController.to.bankList.value.list[controller.state.categoryIndex];
    MyAlert.bottomSheet(
      child: Column(
        children: [
          Text(Lang.buyOrderInfoViewPayAccount.tr, style: Theme.of(context).myStyles.labelBigger),
          const SizedBox(height: 20),
          ...bankInfoList.list.asMap().entries.map((e) => Obx(() => BankInfoCard(
            icon: e.key == controller.state.cardIndex[controller.state.categoryIndex] ? Theme.of(context).myIcons.checkBoxPrimary : null,
            bankInfo: e.value, 
            color: e.key == controller.state.cardIndex[controller.state.categoryIndex] ? Theme.of(context).myColors.primary.withOpacity( 0.1) : Theme.of(context).myColors.itemCardBackground,
            onPressed: () => controller.onChooseCard(e),
            margin: e.key == bankInfoList.list.length - 1 ? null : const EdgeInsets.only(bottom: 8),
          ),
        ))],
      ),
    );
  }

  Widget _buildCategoryItem(BuildContext context, MapEntry<int, CategoryInfoModel> e) {
    return Obx(() {
      final isButtonDisabled = false.obs;

      bool isNotInMin = double.parse(controller.state.amount.isEmpty ? '999999999' : controller.state.amount) < double.parse(UserController.to.orderSetting.value.sellAmountRange[UserController.to.categoryList.value.list[e.key].payCategorySn]?['min']);
      bool isNotInMax = double.parse(controller.state.amount.isEmpty ? '0' : controller.state.amount) > double.parse(UserController.to.orderSetting.value.sellAmountRange[UserController.to.categoryList.value.list[e.key].payCategorySn]?['max']);

      if (isNotInMax || isNotInMin) {
        isButtonDisabled.value = true;
      }

      return MyButton.widget(onPressed: isButtonDisabled.value ? null :  () => controller.changeCategory(e.key), child: Obx(() =>  MyCard(
        borderRadius: BorderRadius.circular(8),
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
        width: (Get.width - 32 - 10) / 2,
        height: 36,
        color: isButtonDisabled.value ? Theme.of(context).myColors.buttonDisable : e.key == controller.state.categoryIndex ? Theme.of(context).myColors.primary : Theme.of(context).myColors.cardBackground,
        child: Row(children: [
          MyImage(imageUrl: e.value.icon, height: 20),
          const SizedBox(width: 8),
          Text(e.value.categoryName, style: isButtonDisabled.value ? Theme.of(context).myStyles.buttonText.copyWith(color: Theme.of(context).myColors.onButtonDisable) : e.key == controller.state.categoryIndex ? Theme.of(context).myStyles.onButton : Theme.of(context).myStyles.label),
        ]),
      )));
    });
  }

  Widget _buildAmountItem(BuildContext context, MapEntry<int, String> e) {
    return MyButton.widget(onPressed: () => controller.changeAmount(e), child: Obx(() => MyCard(
      borderRadius: BorderRadius.circular(8),
      padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
      width: (Get.width - 32 - 32) / 5,
      height: 36,
      color: e.key == controller.state.amountIndex ? Theme.of(context).myColors.primary : Theme.of(context).myColors.cardBackground,
      child: Center(child: FittedBox(child: Text(e.value.isEmpty ? ' ' : e.value, style: e.key == controller.state.amountIndex ? Theme.of(context).myStyles.onButton : Theme.of(context).myStyles.label))),
    )));
  }

  Widget _buildButton(BuildContext context) {
    return SafeArea(child: Padding(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 4), 
      child: Obx(() => MyButton.filedLong(
        onPressed: controller.state.isButtonDisable ? null : controller.onQuicklyBuyCoins, 
        text: Lang.buyCoinsQuicklyViewButtonText.tr,
      )),
    ));
  }
}
