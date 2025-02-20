import 'package:cgwallet/common/common.dart';
import 'package:cgwallet/views/views.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class WalletHistoryView extends GetView<WalletHistoryController> {
  const WalletHistoryView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar.normal(title: controller.state.title),
      backgroundColor: Theme.of(context).myColors.background,
      body: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    return Column(children: [
      _buildHeader(context),
      Obx(() => _buildTitleBar(context)),
      Expanded(child: _buildContent(context)),
    ]);
  }

  Widget _buildHeader(BuildContext context) {
    final title = Row(children: [
      Expanded(child: Column(children: [
        Container(padding: const EdgeInsets.fromLTRB(16, 0, 8, 0), height: 24, alignment: Alignment.centerLeft, child: FittedBox(
          child: Text(Lang.homeViewBalance.tr, style: Theme.of(context).myStyles.onHomeAppBarNormal)
        )),
        Container(padding: const EdgeInsets.fromLTRB(16, 0, 8, 0), height: 36, alignment: Alignment.centerLeft, child: FittedBox(
          child: Obx(() => Text(UserController.to.userInfo.value.balance, style: Theme.of(context).myStyles.onHomeAppBarBigger))
        )),
      ])),
      Expanded(child: MyButton.widget(onPressed: controller.goSellOrdersView, child: MyCard(child: Column(children: [
        Container(padding: const EdgeInsets.fromLTRB(8, 0, 8, 0), height: 24, alignment: Alignment.center, child: FittedBox(
          child: Text(Lang.homeViewSelling.tr, style: Theme.of(context).myStyles.onHomeAppBarNormal)
        )),
        Container(padding: const EdgeInsets.fromLTRB(8, 0, 8, 0), height: 36, alignment: Alignment.center, child: FittedBox(
          child: Obx(() => Text(UserController.to.userInfo.value.frozenBalance, style: Theme.of(context).myStyles.onHomeAppBarHeader))
        )),
      ])))),
      Expanded(child: Column(children: [
        Container(padding: const EdgeInsets.fromLTRB(8, 0, 16, 0), height: 24, alignment: Alignment.centerRight, child: FittedBox(
          child: Text(Lang.homeViewLock.tr, style: Theme.of(context).myStyles.onHomeAppBarNormal)
        )),
        Container(padding: const EdgeInsets.fromLTRB(8, 0, 16, 0), height: 36, alignment: Alignment.centerRight, child: FittedBox(
          child: Obx(() => Text(UserController.to.userInfo.value.lockBalance, style: Theme.of(context).myStyles.onHomeAppBarHeader))
        )),
      ])),
    ]);

    return MyCard.normal(
      color: Theme.of(context).myColors.primary, 
      padding: const EdgeInsets.fromLTRB(0, 16, 0, 16),
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 0),
      child: title,
    );
  }

  void _onBottomSheet() {
    int index = 0;
    final scrollController = FixedExtentScrollController(initialItem: controller.state.typeIndex);
    MyAlert.bottomSheet(
      padding: const EdgeInsets.fromLTRB(32, 16, 32, 0),
      child: Column(children: [
        Row(children: [
          Text(Lang.walletHistoryViewTypeSelection.tr, style: Get.theme.myStyles.labelBig),
          const Spacer(),
          Obx(() => MyButton.filedShort(
            onPressed: controller.state.generalTypeList.value.list.isEmpty ? null : () => controller.onChooiseType(index), 
            text: Lang.confirm.tr)
          ),
        ]),
        SizedBox(height: 200, child: Obx(() => controller.state.generalTypeList.value.list.isEmpty 
          ? Center(child: Get.theme.myIcons.loadingIcon) 
          : CupertinoPicker(
              scrollController: scrollController,
              itemExtent: 40, 
              onSelectedItemChanged: (i) => index = i, 
              children: controller.state.generalTypeList.value.list.asMap().entries.map((e) => Center(child: Text(e.value.name, style: Get.theme.myStyles.labelBigger))).toList()
            )
          ),
        ),
      ])
    );
  }

  Widget _buildTitleBar(BuildContext context) {
    if (controller.state.generalTypeList.value.list.isEmpty) {
      return const SizedBox();
    }
    return Padding(padding: const EdgeInsets.fromLTRB(16, 8, 16, 8), child: Row(children: [
      Obx(() => MyButton.filedShort(
        onPressed: controller.onTody, 
        text: Lang.walletHistoryViewToday.tr,
        color: controller.state.dateIndex == 1 ? Theme.of(context).myColors.primary : Theme.of(context).myColors.cardBackground, 
        textColor: controller.state.dateIndex == 1 ? Theme.of(context).myColors.onPrimary : Theme.of(context).myColors.textDefault
      )),
      const SizedBox(width: 10),
      Obx(() => MyButton.filedShort(
        onPressed: controller.onThisMonth, 
        text: Lang.walletHistoryViewMonth.tr, 
        color: controller.state.dateIndex == 3 ? Theme.of(context).myColors.primary : Theme.of(context).myColors.cardBackground, 
        textColor: controller.state.dateIndex == 3 ? Theme.of(context).myColors.onPrimary : Theme.of(context).myColors.textDefault
      )),
      const SizedBox(width: 10),
      Expanded(child: MyButton.widget(
        onPressed: _onBottomSheet,
        child: MyCard.normal(
          padding: const EdgeInsets.fromLTRB(16, 10, 8, 10),
          child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Flexible(child: Text(Lang.walletHistoryViewTypeSelection.tr, style: Theme.of(context).myStyles.label, overflow: TextOverflow.ellipsis)),
            const SizedBox(width: 10),
            Text(controller.state.generalTypeList.value.list[controller.state.typeIndex].name, style: Theme.of(context).myStyles.labelPrimary),
            Theme.of(context).myIcons.downSolid,
          ]
        )),
      )),
    ]));
  }

  Widget _buildContent(BuildContext context) {
    return Obx(() => controller.state.isLoading
      ? loadingWidget
      : controller.state.walletHistory.value.list.isEmpty 
        ? noDataWidget
        : _buildHitoryList(context),
    );
  }

  Widget _buildHitoryList(BuildContext context) {
    return SafeArea(
      top: false,
      child: SingleChildScrollView(
        child: Column(children: controller.state.walletHistory.value.list.asMap().entries.map(
          (e) => _buildHistoryItem(context, e.value)).toList()
        ),
      ),
    );
  }

  Widget _buildHistoryItem(BuildContext context, WalletHistoryModel data) {
    final title = Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Flexible(child: FittedBox(alignment: Alignment.centerLeft,
        child: Text(data.typeName, style: Theme.of(context).myStyles.label)
      )),
      const SizedBox(width: 16),
      Text(data.amount, style: data.amount.contains('+') ? Theme.of(context).myStyles.labelRed : Theme.of(context).myStyles.labelGreen),
    ]);

    final amount = Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Flexible(child: FittedBox(
        child: Text(data.createdTime, style: Theme.of(context).myStyles.label)
      )),
      Text('${data.balance} / ${data.lockBalance}', style: Theme.of(context).myStyles.label),
    ]);

    final border = Container(margin: const EdgeInsets.only(left: 32), height: 1, color: Theme.of(context).myColors.inputBorder.withOpacity( 0.3));

    return MyCard.normal(
      padding: const EdgeInsets.only(left: 16, right: 16),
      margin: const EdgeInsets.only(left: 16, right: 16),
      child: Column(children: [
        const SizedBox(height: 8), 
        title, 
        const SizedBox(height: 8), 
        amount, 
        const SizedBox(height: 8), 
        border,
      ]),
    );
  }
}
