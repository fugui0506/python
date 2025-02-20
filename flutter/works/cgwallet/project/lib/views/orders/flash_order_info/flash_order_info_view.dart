import 'dart:convert';

import 'package:cgwallet/common/common.dart';
import 'package:cgwallet/views/views.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FlashOrderInfoView extends GetView<FlashOrderInfoController> {
  const FlashOrderInfoView({super.key});

  @override
  Widget build(BuildContext context) {

    var appBar = MyAppBar.normal(
      title: Lang.flashOrderInfoViewTitle.tr,
      // 闪兑没说要加订单号
      actions: [customerButton()],
    );

    /// 页面构成
    return Scaffold(
      appBar: appBar, 
      body: _buildBody(context),
      backgroundColor: Theme.of(context).myColors.background
    );
  }

   Widget _buildBody(BuildContext context) {
    const spacer = SizedBox(height: 10);
    final orderHeader = Obx(() => _buildOrderHeader(context, controller.state.orderInfo.value));
    final scheduler = Obx(() => _buildScheduler(context, controller.state.orderInfo.value));
    final address = Obx(() => _buildAddress(context, controller.state.orderInfo.value));
    final orderInfo = Obx(() => _buildOrderInfo(context, controller.state.orderInfo.value));
    final richText = Obx(() => _buildRichText(context, controller.state.orderInfo.value));



    return Column(children: [
      Expanded(child: SingleChildScrollView(padding: const EdgeInsets.fromLTRB(16, 0, 16, 0), child: Column(children: [
        orderHeader, spacer, scheduler, spacer, address, spacer, orderInfo, richText
      ]))),
      SafeArea(child: Obx(() => _buildButton(context, controller.state.orderInfo.value))),
    ]);
  }

  Widget _buildOrderInfo(BuildContext context, OrderFlashInfoModel data) {
    final cancelText = [1, 2].contains(data.status) ? Lang.flashOrderInfoViewLateTime.tr : data.status == 3 ? Lang.flashOrderInfoViewDoneTime.tr : Lang.flashOrderInfoViewCancelTime.tr;
    final cancelTime = data.status == 1 ? data.memberConfirmLimitTime : data.status == 2 ? data.adminConfirmLimitTime : data.successTime;
    return MyCard.normal(
      padding: const EdgeInsets.all(16),
      color: Theme.of(context).myColors.cardBackground,
      child: Column(children: [
        Text(Lang.buyOrderInfoViewOrderInfo.tr, style: Theme.of(context).myStyles.labelBigger),
        const SizedBox(width: double.infinity),
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Row(children: [
            Text(Lang.flashOrderInfoViewId.tr, style: Theme.of(context).myStyles.labelSmall),
            const SizedBox(width: 8),
            FittedBox(child: Text(data.sysOrderId, style: Theme.of(context).myStyles.label))
          ]),
          MyButton.text(onPressed: () => data.sysOrderId.copyToClipBoard(), text: Lang.copy.tr)
        ]),
        Row(children: [
          Text(Lang.flashOrderInfoViewCreateTime.tr, style: Theme.of(context).myStyles.labelSmall),
          const SizedBox(width: 8),
          Flexible(child: Text(data.createdTime, style: Theme.of(context).myStyles.label)),
        ]),
        if(data.memberConfirmTime.isNotEmpty)
          Row(children: [
            Text(Lang.flashOrderInfoViewPayTime.tr, style: Theme.of(context).myStyles.labelSmall),
            const SizedBox(width: 8),
            Flexible(child: Text(data.memberConfirmTime, style: Theme.of(context).myStyles.label)),
          ]),
        if(data.adminConfirmTime.isNotEmpty)
          Row(children: [
            Text(Lang.flashOrderInfoViewConfirmTime.tr, style: Theme.of(context).myStyles.labelSmall),
            const SizedBox(width: 8),
            Flexible(child: Text(data.adminConfirmTime, style: Theme.of(context).myStyles.label)),
          ]),
        Row(children: [
          Text(cancelText, style: Theme.of(context).myStyles.labelSmall),
          const SizedBox(width: 8),
          Flexible(child: Text(cancelTime, style: Theme.of(context).myStyles.labelRed)),
        ])
      ]),
    );
  }

  Widget _buildRichText(BuildContext context, OrderFlashInfoModel data) {
    final FlashExchangeController flashExchangeController = Get.find<FlashExchangeController>();
    return Obx(() => flashExchangeController.state.swapSetting.value.precautions.isNotEmpty
        ? MyCard.normal(
            margin: const EdgeInsets.only(top: 8),
            padding: const EdgeInsets.all(16),
            color: Theme.of(context).myColors.itemCardBackground,
            child: MyHtml(data: flashExchangeController.state.swapSetting.value.precautions)
          )
        : const SizedBox()
    );
  }

  Widget _buildAddress(BuildContext context, OrderFlashInfoModel data) {
    return MyCard.normal(
      padding: const EdgeInsets.all(16),
      color: Theme.of(context).myColors.cardBackground,
      child: Column(children: [
        Text(Lang.flashOrderInfoViewRechargeAddress.tr, style: Theme.of(context).myStyles.labelBigger),
        const SizedBox(width: double.infinity),
        MyCard(
          width: 200,
          height: 200,
          child: data.qrCode.isEmpty ? Theme.of(context).myIcons.qrcode : Image.memory(base64Decode(data.qrCode)),
        ),
        Text(Lang.flashOrderInfoViewAddressHint.tr, style: Theme.of(context).myStyles.labelSmall),
        Row(children: [
          Text(Lang.flashOrderInfoViewAddress.tr, style: Theme.of(context).myStyles.label),
          const SizedBox(width: 8),
          Flexible(child: FittedBox(child: Text(data.address, style: Theme.of(context).myStyles.label))),
          MyButton.text(onPressed: () => data.address.copyToClipBoard(), text: Lang.copy.tr)
        ]),
        Row(children: [
          Text(Lang.flashOrderInfoViewLink.tr, style: Theme.of(context).myStyles.label),
          const SizedBox(width: 8),
          Flexible(child: Text(data.pact, style: Theme.of(context).myStyles.labelRed)),
        ]),
      ]),
    );
  }

  Widget _buildScheduler(BuildContext context, OrderFlashInfoModel data) {
    final errorColor = Theme.of(context).myColors.error;
    final primaryColor = Theme.of(context).myColors.primary;
    final buttonDisableColor = Theme.of(context).myColors.buttonDisable;
    final labelRed = Theme.of(context).myStyles.labelRed;
    
    final iconFailed = Theme.of(context).myIcons.failed;

    return Stack(
      alignment: AlignmentDirectional.bottomStart,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildSchedulerLine(context, controller.isCancel2(data) ? errorColor : [2, 3].contains(data.status) ? primaryColor : buttonDisableColor),
            _buildSchedulerLine(context, controller.isCancel3(data) ? errorColor : data.status == 3 ? primaryColor : buttonDisableColor),
          ],
        ),

        Row(
          children: [
            Expanded(child: _buildSchedulerContent(context, data.memberConfirmTime.isEmpty ? Lang.flashOrderHistoryViewOrderTypePay.tr : Lang.flashOrderInfoViewAlreadyPay.tr,
              controller.isCancel1(data) ? Text(data.cancelType, style: labelRed) : data.status == 1 ? Text(controller.state.countDown, style: Theme.of(context).myStyles.labelRedBigger) : Text(data.memberConfirmTime.split(' ').last, style: Theme.of(context).myStyles.label),
              controller.isCancel1(data) ? SizedBox(height: 12, child: iconFailed) : MyCard.avatar(radius: 6, color: primaryColor)),
            ),
            Expanded(child: _buildSchedulerContent(context, data.adminConfirmTime.isEmpty ? Lang.flashOrderHistoryViewOrderTypeConfirm.tr : Lang.flashOrderInfoViewAlreadyConfirm.tr,
              controller.isCancel2(data) ? Text(data.cancelType, style: labelRed) : data.status == 2 ? Text(controller.state.countDown, style: Theme.of(context).myStyles.labelRedBigger) : Text(data.adminConfirmTime.split(' ').last, style: Theme.of(context).myStyles.label),
              controller.isCancel2(data) ? SizedBox(height: 12, child: iconFailed) : MyCard.avatar(radius: 6, color: [2, 3].contains(data.status) ? primaryColor : buttonDisableColor)),
            ),
            Expanded(child: _buildSchedulerContent(context, Lang.flashOrderHistoryViewOrderTypeDone.tr,
              data.status != 3 ? const SizedBox() : Text(data.successTime.split(' ').last, style: Theme.of(context).myStyles.label),
              MyCard.avatar(radius: 6, color: data.status != 3? buttonDisableColor : primaryColor)),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSchedulerLine(BuildContext context, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 5),
      width: (Get.width - 32 - (Get.width - 32) / 3) / 2,
      height: 2,
      color: color,
    );
  }

  Widget _buildSchedulerContent(
    BuildContext context, 
    String title,
    Widget timer,
    Widget status,
  ) {
    return Column(children: [
      Text(title, style: Theme.of(context).myStyles.label),
      const SizedBox(height: 4),
      SizedBox(height: 24, child: Center(child: timer)),
      const SizedBox(height: 8),
      status,
    ]);
  }

  Widget _buildButton(BuildContext context, OrderFlashInfoModel data) {
    if (data.status != 1) {
      return const SizedBox();
    }
    return Padding(padding: const EdgeInsets.fromLTRB(20, 4, 20, 4), child: MyButton.filedLong(onPressed: controller.onPay, text: Lang.flashOrderInfoViewButton.tr));
  }

  Widget _buildOrderHeader(BuildContext context, OrderFlashInfoModel data) {
    const spacer = SizedBox(width: double.infinity, height: 8);
    final amount = Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      Text('${data.usdtQuantity}', style: Theme.of(context).myStyles.labelBiggest),
      const SizedBox(width: 4),
      Text(Lang.flashViewUsdt.tr, style: Theme.of(context).myStyles.labelBigger),
      const SizedBox(width: 4),
      MyButton.widget(onPressed: () => data.usdtQuantity.toString().copyToClipBoard(), child: Theme.of(context).myIcons.copyNormal),
    ]);
    final hint = !controller.isDone(data) ? MyHintBoxUp(content: Lang.flashOrderInfoViewAlert.tr) : const SizedBox();
    final canExchange = Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      Text(Lang.flashOrderInfoViewCanExchange.tr, style: Theme.of(context).myStyles.labelSmall),
      const SizedBox(width: 4),
      Text('${data.amount}', style: Theme.of(context).myStyles.labelPrimary),
      const SizedBox(width: 4),
      Text(Lang.flashViewCgb.tr, style: Theme.of(context).myStyles.label),
    ]);
    final card = MyCard(
      child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
        amount, hint, spacer, canExchange,
      ],),
    );
    final icon = controller.isFialed(data) ? Theme.of(context).myIcons.orderCancel : data.status == 3 ? Theme.of(context).myIcons.orderSuccess : const SizedBox();
    return Stack(children: [
      card, Positioned(top: 0, right: 0, child: icon)
    ]);
  }
}
