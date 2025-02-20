import 'package:cgwallet/common/common.dart';
import 'package:cgwallet/views/views.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:get/get.dart';

class FlashExchangeView extends StatelessWidget {
  const FlashExchangeView({super.key});

  @override
  Widget build(BuildContext context) {
    /// 页面构成
    return GetBuilder<FlashExchangeController>(
      init: FlashExchangeController(),
      builder: (controller) => KeyboardDismissOnTap(child: _buildScaffold(context, controller)),
    );
  }

  Widget _buildScaffold(BuildContext context, FlashExchangeController controller) {
    return Scaffold(
      appBar: _buildAppBar(context, controller), 
      body: _buildBody(context, controller),
      backgroundColor: Theme.of(context).myColors.background,
    );
  }

  MyAppBar _buildAppBar(BuildContext context, FlashExchangeController controller) {
    final historyTitle = Text(Lang.flashViewHistory.tr, style: Theme.of(context).myStyles.content);
    final historyIcon = Theme.of(context).myIcons.flashHistory;
    const spacer = SizedBox(width: 10);
    const rightPadding = SizedBox(width: 16);
    final action = MyButton.widget(onPressed: controller.goFlashExchangeHistroyVew, child: Row(children: [
      historyTitle, spacer, historyIcon, rightPadding
    ]));
    return MyAppBar.normal(actions: [action]);
  }

  Widget _buildBody(BuildContext context, FlashExchangeController controller) {
    final content = Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
      const SizedBox(width: double.infinity, height: 16),
      SizedBox(width: 80, child: Theme.of(context).myIcons.coinCgb),
      const SizedBox(height: 16),
      Text(Lang.flashViewTitle.tr, style: Theme.of(context).myStyles.flashViewTitle, textAlign: TextAlign.center, maxLines: 2, overflow: TextOverflow.ellipsis),
      const SizedBox(height: 32),
      _buildContent(context, controller),
      const SizedBox(height: 10),
      SizedBox(height: MyConfig.app.bottomHeight + MediaQuery.of(context).padding.bottom)
    ]);

    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16), 
      child: content
    );
  }

  Widget _buildContent(BuildContext context, FlashExchangeController controller) {
    final contentBigest = Theme.of(context).myStyles.contentBiggest;
    final textField = Obx(() => TextField(
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      keyboardType: TextInputType.number,
      controller: controller.amountController,
      focusNode: controller.amountFocusNode,
      cursorColor: Theme.of(context).myColors.primary,
      textAlign: TextAlign.end,
      scrollPadding: EdgeInsets.zero,
      style: contentBigest,
      onChanged: controller.onChanged,
      decoration: InputDecoration(
        isDense: true,
        // filled: true,
        border: InputBorder.none,
        contentPadding: EdgeInsets.zero,
        hintText: '${controller.state.swapSetting.value.minAmountLimit} - ${controller.state.swapSetting.value.maxAmountLimit}',
        hintStyle: TextStyle(color: Theme.of(context).myColors.textDefault.withOpacity( 0.3), fontSize: 22),
      )
    ));

    final inputAmount = MyCard(
      width: double.infinity,
      borderRadius: BorderRadius.circular(10),
      border: Border.all(color: Theme.of(context).myColors.primary, width: 0.8),
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      child: Row(children: [
        SizedBox(width: 20, height: 20, child: Theme.of(context).myIcons.coinUsdt),
        const SizedBox(width: 8),
        Text(Lang.flashViewUsdt.tr, style: Theme.of(context).myStyles.labelBigger),
        const SizedBox(width: 8),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
          Obx(() => Text('${Lang.flashViewExchangeRate.tr}: ${controller.state.swapSetting.value.usdtRate}', style: Theme.of(context).myStyles.labelSmall)),
          textField,
        ]))
      ]),
    );

    final cgbAmount = MyCard(
      width: double.infinity,
      borderRadius: BorderRadius.circular(10),
      color: Theme.of(context).myColors.itemCardBackground,
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      child: Row(children: [
        SizedBox(width: 20, height: 20, child: Theme.of(context).myIcons.coinCgb),
        const SizedBox(width: 8),
        Text(Lang.flashViewCgb.tr, style: Theme.of(context).myStyles.labelBigger),
        const SizedBox(width: 8),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
          Text(Lang.flashViewExchangeAmount.tr, style: Theme.of(context).myStyles.labelSmall),
          Obx(() => Text('${controller.state.amoutCGB}', style: contentBigest)),
        ]))
      ]),
    );

    final bottomSheet = Obx(() => Column(children: [
      Text(Lang.flashViewProtocolChoose.tr, style: Theme.of(context).myStyles.labelBigger),
      const SizedBox(height: 16),
      Text(Lang.flashViewProtocolAlert.tr, style: Theme.of(context).myStyles.contentSmall),
      if (controller.state.swapSetting.value.protocolList.isNotEmpty)
        const SizedBox(height: 16),
      if (controller.state.swapSetting.value.protocolList.isNotEmpty)
        ...controller.state.swapSetting.value.protocolList.asMap().entries.map((e) => MyButton.floatLeft(
          textColor: controller.state.protocolIndex == e.key ? Theme.of(context).myColors.onPrimary : Theme.of(context).myColors.onButtonUnselect,
          onPressed: () => controller.onChooiseProtocol(e.key), 
          color: controller.state.protocolIndex == e.key ? Theme.of(context).myColors.primary : Theme.of(context).myColors.buttonUnselect, 
          text: e.value
        )),
    ]));

    void onChooiseProtocol() {
      Get.focusScope?.unfocus();
      MyAlert.bottomSheet(child: bottomSheet);
    }

    final protocol = MyButton.widget(onPressed: onChooiseProtocol, child: MyCard(
      width: double.infinity,
      borderRadius: BorderRadius.circular(10),
      color: Theme.of(context).myColors.itemCardBackground,
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Flexible(child: Text(Lang.flashViewProtocolTitle.tr, style: Theme.of(context).myStyles.label, overflow: TextOverflow.ellipsis)),
        const SizedBox(width: 10),
        Row(children: [
          Obx(() => Text(
            controller.state.protocolIndex == -1 || controller.state.swapSetting.value.protocolList.isEmpty ? Lang.flashViewProtocolChoose.tr : controller.state.swapSetting.value.protocolList[controller.state.protocolIndex],
            style: Theme.of(context).myStyles.label)
          ),
          const SizedBox(width: 8),
          Theme.of(context).myIcons.down,
        ]),
      ]),
    ));

    void onExchange() {
      Get.focusScope?.unfocus();
      checkRealName(() => MyAlert.dialog(
        title: Lang.flashViewCheckTitle.tr,
        content: '${Lang.flashViewCheckSure.tr} ${controller.amountController.text} ${Lang.flashViewUsdt.tr}, ${Lang.flashViewCheckGet.tr} ${controller.state.amoutCGB} ${Lang.flashViewCgb.tr}',
        onConfirm: () => controller.onExchange(context),
      ));
    }

    final button = Obx(() => MyButton.filedLong(
      onPressed: controller.state.isButtonDisable ? null : onExchange, 
      text: Lang.flashViewExchange.tr
    ));

    return MyCard.big(child: Column(children: [
      inputAmount, 
      const SizedBox(height: 10), 
      cgbAmount, 
      const SizedBox(height: 10),
      protocol,
      const SizedBox(height: 32),
      button,
    ]));
  }
}
