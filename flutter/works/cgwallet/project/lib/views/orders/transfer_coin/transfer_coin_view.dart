import 'package:cgwallet/common/common.dart';
import 'package:cgwallet/views/views.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:get/get.dart';

class TransferCoinView extends GetView<TransferCoinController> {
  const TransferCoinView({super.key});

  
  @override
  Widget build(BuildContext context) {
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
    final avatar = Obx(() => MyCard.avatar(radius: 20, color: Theme.of(context).myColors.cardBackground, child: MyImage(imageUrl: controller.state.transferUser.value.avatarUrl, width: 40, height: 40)));

    final onlineBox = Row(children: [
      Obx(() => Text(controller.state.transferUser.value.nickName, style: Theme.of(context).myStyles.labelBig)),
      const SizedBox(width: 8),
      Obx(() => controller.state.transferUser.value.isOnline ? online : offline)
    ]);

    // final address = Row(children: [
    //   MyCard(
    //     borderRadius: BorderRadius.circular(4),
    //     padding: const EdgeInsets.fromLTRB(8, 2, 8, 2),
    //     color: Theme.of(context).myColors.cardBackground,
    //     child: Text(Lang.transferViewAddress.tr, style: Theme.of(context).myStyles.labelSmall),
    //   ),
    //   const SizedBox(width: 8),
    //   Flexible(child: FittedBox(child: Obx(() => Text(controller.state.transferUser.value.walletAddress, style: Theme.of(context).myStyles.labelSmall))))
    // ]);

    // final userInfo = MyCard.normal(
    //   padding: const EdgeInsets.all(16),
    //   color: Theme.of(context).myColors.itemCardBackground,
    //   child: Row(children: [
    //     avatar,
    //     const SizedBox(width: 16),
    //     Flexible(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
    //       onlineBox,
    //       const SizedBox(height: 4),
    //       address,
    //     ])),
    //   ]),
    // );

    // final step1 = SingleChildScrollView(child: MyCard.normal(
    //   margin: const EdgeInsets.fromLTRB(16, 0, 16, 0),
    //   padding: const EdgeInsets.all(16),
    //   child: Column(children: [
    //     Text(Lang.transferViewContentTitle.tr, style: Theme.of(context).myStyles.labelBigger),
    //     const SizedBox(height: 16),
    //     userInfo,
    //     const SizedBox(height: 32, width: double.infinity),
    //     Obx(() => MyButton.filedLong(onPressed: controller.state.isButtonDisable ? null : controller.goStepTwo, text: Lang.realNameViewNext.tr)),
    //   ]),
    // ));

    final step2 = SingleChildScrollView(child: Column(children: [
      MyCard.normal(
        margin: const EdgeInsets.fromLTRB(16, 0, 16, 0),
        padding: const EdgeInsets.all(16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            avatar,
            const SizedBox(width: 16),
            Flexible(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              onlineBox,
              const SizedBox(height: 4),
              Obx(() => Text('UID: ${controller.state.transferUser.value.memberId}', style: Theme.of(context).myStyles.labelSmall)),
            ])),
          ]),
          const SizedBox(height: 8, width: double.infinity),

          Row(children: [
            SizedBox(width: 80, height: 34, child: Stack(alignment: Alignment.center, children: [
              Theme.of(context).myIcons.homeWalletAddress,
              Padding(padding: const EdgeInsets.fromLTRB(10, 0, 10, 0), child: FittedBox(child: Text(Lang.homeViewWalletAddress.tr, style: Theme.of(context).myStyles.label)),),
            ])),
            const SizedBox(width: 8),
            Flexible(child: FittedBox(child: Text(controller.state.address.hideMiddle(2, 2), style: Theme.of(context).myStyles.label))),
          ]),

          const SizedBox(height: 8, width: double.infinity),

          Text(Lang.transferViewAmount.tr, style: Theme.of(context).myStyles.labelSmall),
          const SizedBox(height: 8, width: double.infinity),
          MyInput.normal(
            controller.amountController,
            controller.amountFocusNode,
            color: Theme.of(context).myColors.cardBackground,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            hintText: Lang.transferViewAmountHintText.tr,
            prefixIcon: SizedBox(width: 40, height: 40, child: Center(child: SizedBox(width: 20, height: 20, child: Theme.of(context).myIcons.coinCgb))),
          ),
          const SizedBox(height: 8, width: double.infinity),
          MyInput(
            maxLines: 3,
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide.none
            ),
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
            controller: controller.noteController,
            focusNode: controller.noteFocusNode,
            color: Theme.of(context).myColors.itemCardBackground,
            hintText: Lang.transferViewNoteHintText.tr,
          ),
          const SizedBox(height: 32, width: double.infinity),
          Obx(() => MyButton.filedLong(onPressed: controller.state.isButtonDisable ? null : controller.onTransfer, text: Lang.transferViewTitle.tr)),
        ]),
      ),
      Obx(() => controller.state.settings.value.precautions.isEmpty ? const SizedBox() : MyCard.normal(
        margin: const EdgeInsets.all(16),
        color: Theme.of(context).myColors.itemCardBackground,
        padding: const EdgeInsets.all(16),
        child: MyHtml(data: controller.state.settings.value.precautions),
      ))
    ]));

    final step3 = MyCard(
      child: Column(children: [
        const SizedBox(height: 32),
        Theme.of(context).myIcons.success,
        const SizedBox(height: 16),
        Text(Lang.transferViewSuss.tr, style: Theme.of(context).myStyles.labelBigger),
        const SizedBox(height: 4),
        Text(Lang.transferViewSussHint.tr, style: Theme.of(context).myStyles.labelSmall),
      ]),
    );

    return PageView(
      controller: controller.pageController,
      physics: const NeverScrollableScrollPhysics(),
      children: [step2, step3]
    );
  }
}
