import 'package:cgwallet/common/common.dart';
import 'package:cgwallet/views/views.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ActivitySignInView extends GetView<ActivitySignInController> {
  const ActivitySignInView({super.key});

  @override
  Widget build(BuildContext context) {
    /// appbar
    var appBar = MyAppBar.color(
      color: Theme.of(context).myColors.primary,
      title: controller.state.title,
    );

    /// 页面构成
    return Scaffold(
      appBar: appBar,
      body: _buildBody(context),
      backgroundColor: Theme.of(context).myColors.background,
    );
  }

  Widget _buildBody(BuildContext context) {
    return SingleChildScrollView(
      physics: const ClampingScrollPhysics(),
      child: Column(children: [
        Theme.of(context).myIcons.activitySignInBackground,
        _buildTop(context),
        _buildBottom(context),
        Padding(padding: const  EdgeInsets.fromLTRB(20, 0, 20, 20), child: Obx(() => MyHtml(data: controller.state.activityData.value.description)))
      ]),
    );
  }

  Widget _buildBottom(BuildContext context) {
    return MyCard(
      width: double.infinity,
      padding: const EdgeInsets.only(left: 20, right: 20),
      child: MyCard(
        borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(20), bottomRight: Radius.circular(20)),
        padding: const EdgeInsets.all(16),
        color: Theme.of(context).myColors.cardBackground,
        child: Column(children: [
          Obx(() => controller.state.isLoading ? loadingWidget : SingleChildScrollView(scrollDirection: Axis.horizontal, child: Row(children: controller.state.activityData.value.rechargeReward.asMap().entries.map((e) => _buildItem(context, e)).toList()),),),
          const SizedBox(height: 8),
          Obx(() => MyButton.filedLong(onPressed: controller.state.activityData.value.isSign == 1 ? controller.signIn : null, text: Lang.activitySignInViewSignIn.tr))
        ]),
      ),
    );
  }

  Widget _buildItem(BuildContext context, MapEntry<int, RechargeReward> data) {
    final buttonText = Lang.activitySignInViewNotReached.tr.obs;
    Widget icon = Theme.of(context).myIcons.activitySignInCoin0;
    VoidCallback onPressed = () {};
    Color color = Theme.of(context).myColors.primary.withOpacity( 0);
    Color textColor = Theme.of(context).myColors.textDefault.withOpacity( 0.6);

    if (data.value.rewardStatus == 1) {
      buttonText.value = Lang.activitySignInViewReached.tr;
      icon = Theme.of(context).myIcons.activitySignInCoin1;
      onPressed = () => controller.getReward(data.value);
      color = Theme.of(context).myColors.primary;
      textColor = Theme.of(context).myColors.onButtonPressed;
    } else if (data.value.rewardStatus == 2) {
      buttonText.value = Lang.activitySignInViewAlreadyReached.tr;
      icon = Theme.of(context).myIcons.activitySignInCoin2;
      textColor = Theme.of(context).myColors.textDefault;
    }


    return MyCard(
      padding: const EdgeInsets.all(16),
      child: Column(children: [
        Row(children: [
          Text(Lang.activitySignInViewIn.tr, style: Theme.of(context).myStyles.label),
          const SizedBox(width: 4),
          Text('${data.value.consecutiveDays}', style: Theme.of(context).myStyles.labelPrimaryBig),
          const SizedBox(width: 4),
          Text(Lang.activitySignInViewDays.tr, style: Theme.of(context).myStyles.label),
        ]),
        const SizedBox(height: 16), 
        SizedBox(width: 80, child: icon),
        const SizedBox(height: 8), 
        Text('+${data.value.amount}', style: Theme.of(context).myStyles.labelPrimaryBig),
        Obx(() => MyButton.filedShort(color: color, onPressed: onPressed, text: buttonText.value, textColor: textColor,))
      ])
    );
  }

  Widget _buildTop(BuildContext context) {
    final days = Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Obx(() => Text(
          '${controller.state.activityData.value.isSign == -1 ? 0 : controller.state.activityData.value.consecutiveDays}',
          style: Theme.of(context).myStyles.labelPrimaryBigger
        )),
        const SizedBox(width: 10),
        Text(Lang.activitySignInViewDays.tr, style: Theme.of(context).myStyles.label),
      ],
    );

    final box = Stack(
      alignment: Alignment.center,
      children: [
        MyCard(
          width: 120,
          height: 18,
          color: Theme.of(context).myColors.buttonDisable,
          borderRadius: BorderRadius.circular(9),
          child: Obx(() {
            final depositString = controller.state.activityData.value.depositAmount;
            double depositAmount = double.parse(depositString);

            if (depositAmount == 0 || depositString.isEmpty) {
              return const SizedBox();
            }

            double depositSuccessAmount = double.parse(controller.state.activityData.value.depositSuccessAmount);

            

            if (depositSuccessAmount > depositAmount) {
              depositSuccessAmount = depositAmount;
            }

            final width = 120 * depositSuccessAmount / depositAmount;

            return Row(children: [MyCard(width: width, height: 18, color: Theme.of(context).myColors.primary)]);
          })
        ),
        Obx(() => Container(padding: const EdgeInsets.only(left: 8, right: 8), width: 120, height: 18, child: FittedBox(child: Text(controller.state.activityData.value.depositAmount.isEmpty ? '0 / 0' :
          '${controller.state.activityData.value.depositSuccessAmount.isEmpty ? 0 : controller.state.activityData.value.depositSuccessAmount} / ${controller.state.activityData.value.depositAmount.isEmpty ? 0 : controller.state.activityData.value.depositAmount}',
          style: Theme.of(context).myStyles.labelLight,
        ),)))
      ],
    );
    return MyCard(
      width: double.infinity,
      padding: const EdgeInsets.only(left: 20, right: 20),
      color: Theme.of(context).myColors.primary,
      child: MyCard(
        borderRadius: const BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
        padding: const EdgeInsets.all(16),
        color: Theme.of(context).myColors.cardBackground,
        child: Column(children: [
          Row(children: [
            Text(Lang.activitySignInViewAlreadyDays.tr, style: Theme.of(context).myStyles.label),
            const Spacer(),
            Text(Lang.activitySignInViewRecharge.tr, style: Theme.of(context).myStyles.label),
          ]),
          const SizedBox(height: 8),
          Row(children: [days, const Spacer(), box]),
        ]),
      ),
    );
  }
}
