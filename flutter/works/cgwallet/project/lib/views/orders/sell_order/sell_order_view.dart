import 'package:cgwallet/common/common.dart';
import 'package:cgwallet/views/views.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:get/get.dart';

class SellOrderView extends GetView<SellOrderController> {
  const SellOrderView({super.key});

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
    const spacerSmall = SizedBox(height: 8);
    const spacerMedium = SizedBox(height: 16);
    final scrollView = SingleChildScrollView(
      padding: const EdgeInsets.only(left: 16, right: 16),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        _buildAmountTitle(context),
        spacerSmall,
        _buildAmountInput(context),
        spacerMedium,

        Text(Lang.sellOrderViewSplitTitle.tr, style: Theme.of(context).myStyles.label),
        spacerSmall,
        _buildSplitButtons(context),
        spacerMedium,

        Obx(() => controller.state.splitIndex == 1 ? Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(Lang.sellOrderViewSplitRange.tr, style: Theme.of(context).myStyles.label),
          spacerSmall,
          _buildSplitAmountInput(context),
          spacerMedium,
        ]) : const SizedBox()),

        Text(Lang.sellOrderViewCollectTitle.tr, style: Theme.of(context).myStyles.label),
        spacerSmall,
        _buildCollectButtons(context),
        spacerSmall,
        _buildCards(context),
        spacerMedium,
        
        _buildAlertBox(context),
      ]),
    );

    return Column(children: [
      Expanded(child: scrollView),
      MyCard(
        color: Theme.of(context).myColors.cardBackground,
        padding: const EdgeInsets.fromLTRB(16, 4, 16, 4),
        child: SafeArea(child: _buildConfirmButton(context))
      ),
    ]);
  }

  Widget _buildAmountTitle(BuildContext context) {
    return Row(children: [
      Text(Lang.sellOrderViewSellAmount.tr, style: Theme.of(context).myStyles.label),
      const SizedBox(width: 8),
      const Spacer(),
      Text(Lang.sellOrderViewCanSellAmount.tr, style: Theme.of(context).myStyles.label),
      const SizedBox(width: 4),
      Obx(() => Text(UserController.to.userInfo.value.balance, style: Theme.of(context).myStyles.labelPrimary)),
    ]);
  }

  Widget _buildAmountInput(BuildContext context) {
    return MyInput.amountAll(controller.amountController, controller.amountFocusNode, hintText: Lang.sellOrderViewSellAmountHintText.tr, onPressed: controller.onSellAll,);
  }

  Widget _buildSplitButtons(BuildContext context) {
    return Row(children: [
      Expanded(child: Obx(() => MyButton.filedLong(
        onPressed: () => controller.onSplit(1), 
        text: Lang.sellOrderViewCanSplit.tr,
        color: controller.state.splitIndex == 1 ? Theme.of(context).myColors.primary : Theme.of(context).myColors.cardBackground,
        textColor: controller.state.splitIndex == 1 ? Theme.of(context).myColors.onPrimary : Theme.of(context).myColors.textDefault,
      ))),
      const SizedBox(width: 10),
      Expanded(child: Obx(() => MyButton.filedLong(
        onPressed: () => controller.onSplit(0), 
        text: Lang.sellOrderViewCanNotSplit.tr,
        color: controller.state.splitIndex == 0 ? Theme.of(context).myColors.primary : Theme.of(context).myColors.cardBackground,
        textColor: controller.state.splitIndex == 0 ? Theme.of(context).myColors.onPrimary : Theme.of(context).myColors.textDefault,
      ))),
    ]);
  }

  Widget _buildSplitAmountInput(BuildContext context) {
    final minInput = MyInput.amount(
      controller.minTextController,
      controller.minFocusNode,
      Lang.buyOrderViewMinHintText.tr
    );
    final maxInput = MyInput.amount(
      controller.maxTextController,
      controller.maxFocusNode,
      Lang.buyOrderViewMaxHintText.tr
    );
    return MyCard.normal(
      color: Theme.of(context).myColors.cardBackground,
      child: Row(children: [
        Expanded(child: minInput),
        Container(width: 10, height: 1, color: Theme.of(context).myColors.inputBorder, margin: const EdgeInsets.fromLTRB(10, 0, 10, 0),),
        Expanded(child: maxInput),
      ]),
    );
  }

  Widget _buildCollectButtons(BuildContext context) {
    final child = Row(children: controller.state.bankIndex.asMap().entries.map((e) => Obx(() {
      final isButtonDisabled = false.obs;

      double minSetting = double.parse(UserController.to.orderSetting.value.sellAmountRange[UserController.to.categoryList.value.list[e.key].payCategorySn]?['min']);
      double maxSetting = double.parse(UserController.to.orderSetting.value.sellAmountRange[UserController.to.categoryList.value.list[e.key].payCategorySn]?['max']);


      bool isNotInMax = false;
      bool isNotInMin = false;

      if (controller.state.splitIndex == 1 && controller.minTextController.text.isNotEmpty) {
        double min = double.parse(controller.minTextController.text);
        // double max = double.parse(controller.maxTextController.text.isEmpty ? '0' : controller.maxTextController.text);
        isNotInMin = min < minSetting || min > maxSetting;
        // isNotInMax = max > maxSetting || max < minSetting;
      } else if (controller.state.splitIndex == 0 && controller.amountController.text.isNotEmpty) {
        double source = double.parse(controller.amountController.text);
        isNotInMin = source < minSetting;
        isNotInMax = source > maxSetting;
      }

      if (isNotInMax || isNotInMin) {
        isButtonDisabled.value = true;
      }

      const spacer = SizedBox(width: 8);
      final button = Column(children: [
        MyButton.filedShort(
          color: controller.state.bankIndex[e.key] == 1 ? Theme.of(context).myColors.primary : Theme.of(context).myColors.cardBackground,
          textColor: controller.state.bankIndex[e.key] == 1 ? Theme.of(context).myColors.onPrimary : Theme.of(context).myColors.textDefault,
          onPressed: isButtonDisabled.value ? null : () => controller.onChooseBank(e.key),
          text: UserController.to.categoryList.value.list[e.key].categoryName,
        ),
        // const SizedBox(height: 8),
        // Text('${UserController.to.orderSetting.value.sellAmountRange[UserController.to.categoryList.value.list[e.key].payCategorySn]?['min']}-${UserController.to.orderSetting.value.sellAmountRange[UserController.to.categoryList.value.list[e.key].payCategorySn]?['max']}', style: Theme.of(context).myStyles.labelRed)
      ]);
      return e.key ==  controller.state.bankIndex.length - 1 ? button : Row(children: [button, spacer]);
    })).toList());
    return SingleChildScrollView(scrollDirection: Axis.horizontal, child: child);
  }

  Widget _buildCards(BuildContext context) {
    return Obx(() => Column(children: controller.state.bankInfoList.asMap().entries.map((e) => e.value.payCategoryId == -1
      ? MyCard(
          margin: e.key == controller.state.bankInfoList.length - 1 ? null : const EdgeInsets.only(bottom: 8),
          child: MyButton.widget(onPressed: () => controller.onAddBank(e.value.categoryName), child: getBankInfoEmptyWidget(e.value.categoryName, color: Theme.of(context).myColors.cardBackground)),
        )
      : BankInfoCard(
          margin: e.key == controller.state.bankInfoList.length - 1 ? null : const EdgeInsets.only(bottom: 8),
          color: Theme.of(context).myColors.cardBackground,
          title: Lang.buyOrderInfoViewCollectAccount.tr,
          bankInfo: e.value,
          icon: Theme.of(context).myIcons.downSolid, 
          onPressed: () => showAllBanks(context, e),
        )).toList(),
      ),
    );
  }


  void showAllBanks(BuildContext context, MapEntry<int, BankInfoModel> data) {
    final bankInfoList = getBankInfoList(data.value.payCategoryId);
    MyAlert.bottomSheet(
      child: Column(
        children: [
          Text(Lang.buyOrderInfoViewPayAccount.tr, style: Theme.of(context).myStyles.labelBigger),
          const SizedBox(height: 20),
          ...bankInfoList.list.asMap().entries.map((e) => Obx(() => BankInfoCard(
            icon: e.key == controller.state.cardIndex[data.key] ? Theme.of(context).myIcons.checkBoxPrimary : null,
            bankInfo: e.value, 
            color: e.key == controller.state.cardIndex[data.key] ? Theme.of(context).myColors.primary.withOpacity( 0.1) : Theme.of(context).myColors.itemCardBackground,
            onPressed: () => controller.onChooseCard(data.key, e),
            margin: e.key == bankInfoList.list.length - 1 ? null : const EdgeInsets.only(bottom: 8),
          ),
        ))],
      ),
    );
  }

  Widget _buildConfirmButton(BuildContext context) {
    return Obx(() => MyButton.filedLong(
      onPressed: controller.state.isButtonDisable ? null : () => controller.onSellCoin(), 
      text: Lang.sellOrderViewButtonText.tr,
    ));
  }

  Widget _buildAlertBox(BuildContext context) {
    if (UserController.to.orderSetting.value.mySellPrecautions.isNotEmpty) {
      return MyCard.normal(color: Theme.of(context).myColors.itemCardBackground, padding: const EdgeInsets.all(16), child: MyHtml(data: UserController.to.orderSetting.value.mySellPrecautions));
    } else {
      return const SizedBox();
    }
  }
}
