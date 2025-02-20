import 'package:cgwallet/common/common.dart';
import 'package:cgwallet/views/views.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FlashOrderHistoryView extends GetView<FlashOrderHistoryController> {
  const FlashOrderHistoryView({super.key});

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
    return Column(children: [
      _buildHeader(context),
      const SizedBox(height: 8),
      Expanded(child: _buildList(context)),
    ]);
  }

  Widget _buildList(BuildContext context) {
    return Obx(() => controller.state.isLoading 
      ? loadingWidget 
      : controller.state.historyList.value.list.isEmpty 
        ? noDataWidget 
        : MyRefreshView(
            controller: controller.refreshController,
            onRefresh: controller.onRefresh,
            onLoading: controller.onLoading,
            children: controller.state.historyList.value.list.asMap().entries.map((e) => Obx(() => _buildItem(context, controller.state.historyList.value.list[e.key]))).toList()
          )
        );
  }

  Widget _buildItem(BuildContext context, OrderFlashInfoModel model) {
    final usdt = Theme.of(context).myIcons.coinUsdt32;
    final cgb = Theme.of(context).myIcons.coinCgb;
    final orderItemStyle = getFlashOrderItemStyle(context, model.status);
    final statusName = controller.getOrderStatusName(model.status);
    final statusBox = MyCard(
      margin:const EdgeInsets.only(left: 20),
      borderRadius: BorderRadius.circular(6),
      padding: const EdgeInsets.only(left: 12, right: 12, top: 4, bottom: 4),
      color: orderItemStyle.color,
      child: Text(statusName, style: orderItemStyle.style,),
    );
    final contentBox = Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(children: [
        Text('${model.usdtQuantity}', style: Theme.of(context).myStyles.labelBigger),
        const SizedBox(width: 4),
        Text(Lang.flashViewUsdt.tr, style: Theme.of(context).myStyles.labelSmall),
        const SizedBox(width: 4),
      ]),
      const SizedBox(height: 4),
      Row(children: [
        SizedBox(width: 16, child: cgb),
        const SizedBox(width: 4),
        Text('${model.amount}', style: Theme.of(context).myStyles.labelBig),
        const SizedBox(width: 4),
        Text(Lang.flashViewCgb.tr, style: Theme.of(context).myStyles.labelSmall),
      ]),
      const SizedBox(height: 4),
      Text(model.createdTime, style: Theme.of(context).myStyles.labelSmall),
    ]);
    final liner = Row(children: [
      const SizedBox(width: 48),
      Expanded(child: MyCard(width: double.infinity, height: 1, color: Theme.of(context).myColors.inputBorder.withOpacity( 0.4))),
      const SizedBox(width: 0),
    ]);

    final card = MyCard(
      color: Theme.of(context).myColors.cardBackground,
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
      child: Column(children: [
        const SizedBox(height: 8),
        Row(children: [
          usdt,
          const SizedBox(width: 16),
          Expanded(child: contentBox),
          statusBox,
        ]),
        const SizedBox(height: 8),
        liner,
      ]),
    );

    return MyButton.widget(onPressed: () => controller.goFlashOrderInfoView(model), child: card);
  }

  Widget _buildHeader(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Row(children: [
        const SizedBox(width: 16),
        Row(children: [
          MyButton.widget(onPressed: onType, child: Row(children: [
            Obx(() => Text(controller.state.typeList[controller.state.typeIndex], style: Theme.of(context).myStyles.label)),
            Theme.of(context).myIcons.downSolid,
          ])),
          const SizedBox(width: 16),
          MyButton.widget(onPressed: onDays, child: Row(children: [
            Obx(() => Text(controller.state.daysList[controller.state.daysIndex], style: Theme.of(context).myStyles.label)),
            Theme.of(context).myIcons.downSolid,
          ])),
        ]),
      ]),
    ]);
  }

  void onType() {
    int index = controller.state.typeIndex;
    final scrollController = FixedExtentScrollController(initialItem: controller.state.typeIndex);
    MyAlert.bottomSheet(
      padding: const EdgeInsets.fromLTRB(32, 16, 32, 0),
      child: Column(children: [
        Row(children: [
          Text(Lang.flashOrderHistoryViewOrderType.tr, style: Get.theme.myStyles.labelBig),
          const Spacer(),
          MyButton.filedShort(
            onPressed: () => controller.onChooiseType(index), 
            text: Lang.confirm.tr
          ),
        ]),
        SizedBox(height: 200, child: CupertinoPicker(
          scrollController: scrollController,
          itemExtent: 40, 
          onSelectedItemChanged: (i) => index = i, 
          children: controller.state.typeList.asMap().entries.map((e) => Center(child: Text(e.value, style: Get.theme.myStyles.labelBigger))).toList()
        )),
      ]),
    );
  }

  void onDays() {
    int index = controller.state.daysIndex;
    final scrollController = FixedExtentScrollController(initialItem: controller.state.daysIndex);
    MyAlert.bottomSheet(
      padding: const EdgeInsets.fromLTRB(32, 16, 32, 0),
      child: Column(children: [
        Row(children: [
          Text(Lang.flashOrderHistoryViewTimeRange.tr, style: Get.theme.myStyles.labelBig),
          const Spacer(),
          MyButton.filedShort(
            onPressed: () => controller.onChooiseDay(index), 
            text: Lang.confirm.tr
          ),
        ]),
        SizedBox(height: 200, child: CupertinoPicker(
          scrollController: scrollController,
          itemExtent: 40, 
          onSelectedItemChanged: (i) => index = i, 
          children: controller.state.daysList.asMap().entries.map((e) => Center(child: Text(e.value, style: Get.theme.myStyles.labelBigger))).toList()
        )),
      ]),
    );
  }

}
