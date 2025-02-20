import 'package:cgwallet/common/common.dart';
import 'package:cgwallet/views/views.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PayView extends GetView<PayController> {
  const PayView({super.key});

  @override
  Widget build(BuildContext context) {
    final appBar = MyAppBar.normal(
      title: Lang.payViewTitle.tr,
      actions: [customerButton()],
    );

    final unpay = Column(children: [
      const SizedBox(height: 32),
      Text(Lang.payViewAmount.tr, style: Theme.of(context).myStyles.label),
      const SizedBox(height: 10),
      Obx(() => Text(controller.state.data.length > 3 ? controller.state.data[3] : '0.00', style: Theme.of(context).textTheme.headlineLarge)),
      const SizedBox(height: 32),
      Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        Text(Lang.payViewCountdownTime.tr, style: Theme.of(context).myStyles.label),
        const SizedBox(width: 10),
        Obx(() => Text(controller.state.seconds <= 0 ? '00:00' : controller.state.countDown, style: Theme.of(context).myStyles.labelRedBigger)),
      ]),
      const SizedBox(height: 10),
      Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        MyCard.normal(
          padding: const EdgeInsets.only(left: 32, right: 32, top: 10, bottom: 10),
          color: Theme.of(context).myColors.primary.withOpacity( 0.3),
          child: Row(children: [
            Text(Lang.payViewBalance.tr, style: Theme.of(context).myStyles.label),
            const SizedBox(width: 8),
            Obx(() => Text((double.parse(UserController.to.userInfo.value.balance) + double.parse(UserController.to.userInfo.value.lockBalance)).toStringAsFixed(2), style: TextStyle(color: Theme.of(context).myColors.primary)))
          ]),
        ),
      ]),
      const SizedBox(height: 40),
      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Flexible(child: Text(Lang.payViewOrderId.tr, overflow: TextOverflow.ellipsis, style: Theme.of(context).myStyles.label)),
        const SizedBox(width: 8),
        Row(children: [
          Obx(() => Text(controller.state.data[2])),
          const SizedBox(width: 8),
          MyButton.widget(
            onPressed: controller.copyId,
            child: Theme.of(context).myIcons.copyNormal,
          ),
        ])
      ]),
      const SizedBox(height: 8),
      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Flexible(child: Text(Lang.payViewCreateTime.tr, overflow: TextOverflow.ellipsis, style: Theme.of(context).myStyles.label)),
        const SizedBox(width: 8),
        Obx(() => Text(controller.state.data[7])),
      ]),
      const SizedBox(height: 8),
      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Flexible(child: Text(Lang.payViewEndTime.tr, overflow: TextOverflow.ellipsis, style: Theme.of(context).myStyles.label)),
        const SizedBox(width: 8),
        Obx(() => Text(controller.state.data[8])),
      ]),
    ]);

    var payed = Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Theme.of(context).myIcons.success,
        const SizedBox(height: 20),
        Text(Lang.payViewSuccess.tr, style: Theme.of(context).myStyles.labelBigger),
        const SizedBox(height: 10),
        Text(Lang.payViewSuccessContent.tr, style: Theme.of(context).myStyles.labelSmall),
        // const SizedBox(height: 4),
        // Text('转账已成功到账对方账户', style: Theme.of(context).textTheme.labelSmall,),
      ],
    );

    var failed =  Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Theme.of(context).myIcons.failed,
        const SizedBox(height: 20),
        Text(Lang.payViewFailed.tr, style: Theme.of(context).myStyles.labelRedBigger),
        // const SizedBox(height: 4),
        // Text('请返回重新尝试或联系客服咨询', style: Theme.of(context).textTheme.labelSmall,),
      ],
    );

    /// 页面构成
    return Scaffold(
      appBar: appBar,
      backgroundColor: Theme.of(context).myColors.background,
      body: SingleChildScrollView(padding: const EdgeInsets.fromLTRB(32, 0, 32, 0), child: Column(children: [
        Obx(() => MyCard(
          width: double.infinity,
          borderRadius: BorderRadius.circular(16),
          padding: const EdgeInsets.all(32),
          color: controller.state.payed == 0 ? Theme.of(context).myColors.cardBackground : null,
          child: Obx(() => controller.state.payed == 0 ? unpay : controller.state.payed == 1 ? payed : failed),
        )),

        const SizedBox(height: 32),

        Obx(() => controller.state.payed == 0 ? MyButton.filedLong(
          onPressed: controller.pay ,
          text: Lang.payViewButtonText.tr,
        ): const SizedBox()),
      ])),
    );
  }
}
