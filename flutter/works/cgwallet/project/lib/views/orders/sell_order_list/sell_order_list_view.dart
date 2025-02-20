import 'package:cgwallet/common/common.dart';
import 'package:cgwallet/views/views.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';
import 'package:get/get.dart';

class SellOrderListView extends GetView<SellOrderListController> {
  const SellOrderListView({super.key});

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
          Expanded(child: Column(children: [
            _buildTotalData(context),
            const SizedBox(height: 8),
            Expanded(child: Obx(() => controller.state.isLoading ? loadingWidget : controller.state.orderHistoryList.value.list.isEmpty ? noDataWidget : _buildListView(context))),
          ])),
      ],
    );
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
          const SizedBox(width: 10),
          MyButton.widget(onPressed: controller.onBanks, child: Row(children: [
            Obx(() => Text(controller.state.categoryTitle, style: Theme.of(context).myStyles.label)),
            Theme.of(context).myIcons.downSolid,
          ])),
        ]),
      ]),
      const SizedBox(width: 10),
      Flexible(child: FittedBox(child: MyButton.widget(onPressed: () => onTime(context), child: Row(children: [
        Obx(() => Text(controller.state.showTime, style: Theme.of(context).myStyles.label)),
        Theme.of(context).myIcons.downSolid,
        const SizedBox(width: 8),
      ])))),
    ]);
  }

  void onType() {
    int index = controller.state.typeIndex;
    final scrollController = FixedExtentScrollController(initialItem: controller.state.typeIndex);
    MyAlert.bottomSheet(
      padding: const EdgeInsets.fromLTRB(32, 16, 32, 0),
      child: Column(children: [
        Row(children: [
          Text(Lang.walletHistoryViewTypeSelection.tr, style: Get.theme.myStyles.labelBig),
          const Spacer(),
          MyButton.filedShort(
            onPressed: () => controller.onChooseType(index),
            text: Lang.confirm.tr
          ),
        ]),
        SizedBox(height: 200, child:  CupertinoPicker(
          scrollController: scrollController,
          itemExtent: 40, 
          onSelectedItemChanged: (i) => index = i, 
          children: controller.state.typeList.asMap().entries.map((e) => Center(child: Text(e.value, style: Get.theme.myStyles.labelBigger))).toList()
        )),
      ]),
    );
  }

  Widget _buildTotalData(BuildContext context) {
    return Row(children: [
      Obx(() => _buildTotalItem(context, Lang.sellOrderHistoryTotalAll.tr, controller.state.orderHistoryList.value.summary.totalSellQuantity)),
      Obx(() => _buildTotalItem(context, Lang.sellOrderHistoryTotalIng.tr, controller.state.orderHistoryList.value.summary.totalInProcessingSellQuantity)),
      Obx(() => _buildTotalItem(context, Lang.sellOrderHistoryTotalDone.tr, controller.state.orderHistoryList.value.summary.totalSuccessSellQuantity)),
      Obx(() => _buildTotalItem(context, Lang.sellOrderHistoryTotalCancel.tr, controller.state.orderHistoryList.value.summary.totalCancelSellQuantity)),
    ]);
  }

  Widget _buildTotalItem(BuildContext context, String title, String value) {
    return Expanded(child: MyCard(
      padding: const EdgeInsets.fromLTRB(4, 0, 4, 0),
      child: Column(children: [
        Text(title, style: Theme.of(context).myStyles.labelSmall),
        const SizedBox(height: 8),
        Text(value, style: Theme.of(context).myStyles.labelPrimary),
      ]),
    ));
  }

  void onTime(BuildContext context) {
    final today = DateTime.now();
    final ago = today.subtract(const Duration(days: 90));

    final startTieme = controller.state.orderHistoryParameter.value.beginDate.obs;
    final endTime = controller.state.orderHistoryParameter.value.endDate.obs;

    MyAlert.bottomSheet(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Column(children: [
        Row(children: [
          Text(Lang.sellOrderHistoryTime.tr, style: Get.theme.myStyles.labelBig),
          const Spacer(),
          SizedBox(height: 34, child: MyButton.filedShort(
            onPressed: () {
              controller.state.orderHistoryParameter.value.beginDate = startTieme.value;
              controller.state.orderHistoryParameter.value.endDate = endTime.value;
              controller.setShowTime();
              controller.state.orderHistoryParameter.refresh();
              Get.back();
            }, 
            text: Lang.confirm.tr
          )),
        ]),
        const SizedBox(height: 20),
        Row(children: [
          Expanded(child: Obx(() => MyButton.filedLong(onPressed: () async {
            await DatePicker.showDatePicker(context,
              showTitleActions: true,
              minTime: ago,
              maxTime: today, 
              onConfirm: (date) {
                startTieme.value = '$date'.split(' ').first;
                if (DateTime.parse(endTime.value).isBefore(DateTime.parse(startTieme.value))) {
                  endTime.value = startTieme.value;
                }
              }, 
              currentTime: DateTime.parse(startTieme.value), 
              locale: DeviceService.to.locale.value == MyLang.defaultLocale ? LocaleType.zh : LocaleType.en,
              theme: Theme.of(context).myStyles.dataTimePikerTheme,
            );
          }, text: startTieme.value, color: Theme.of(context).myColors.itemCardBackground, textColor: Theme.of(context).myColors.textDefault))),
          Container(width: 16, height: 1, color: Theme.of(context).myColors.buttonDisable, margin: const EdgeInsets.only(left: 8, right: 8),),
          Expanded(child: Obx(() => MyButton.filedLong(onPressed: () async {
            await DatePicker.showDatePicker(context,
              showTitleActions: true,
              minTime: DateTime.parse(startTieme.value),
              maxTime: today, 
              onConfirm: (date) {
                endTime.value = '$date'.split(' ').first;
              }, 
              currentTime: DateTime.parse(endTime.value), 
              locale: DeviceService.to.locale.value == MyLang.defaultLocale ? LocaleType.zh : LocaleType.en,
              theme: Theme.of(context).myStyles.dataTimePikerTheme,
            );
          }, text: endTime.value, color: Theme.of(context).myColors.itemCardBackground, textColor: Theme.of(context).myColors.textDefault))),
        ]),
        const SizedBox(height: 32),
      ]),
    );
  }

   Widget _buildListView(BuildContext context) {
    final listView = MyRefreshView(
      onRefresh: controller.onRefresh,
      onLoading: controller.onLoading,
      controller: controller.refreshController, 
      children: controller.state.orderHistoryList.value.list.asMap().entries.map((e) => _buildItem(context, e.value)).toList()
    );
    return SafeArea(child: listView);
  }

  void showSubOrders(BuildContext context, OrderHistoryModel data) {
    MyAlert.bottomSheet(padding: const EdgeInsets.fromLTRB(16, 16, 16, 0), child: _buildSubOrders(context, data));
  }

  Widget _buildSubOrders(BuildContext context, OrderHistoryModel data) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        FittedBox(child: Text('${Lang.sellOrderHistoryInfo.tr}: ${data.sysOrderId}', style: Theme.of(context).myStyles.labelBig)),
        const SizedBox(width: 10),
        MyButton.icon(onPressed: () => Get.back(), icon: Theme.of(context).myIcons.inputClear)
      ]),
      Flexible(child: SingleChildScrollView(child: Column(children: data.subOrders!.asMap().entries.map((e) => MyButton.widget(onPressed: () => controller.goOrderInfoView(data.sysOrderId, e.value.sysOrderId, true), child: MyCard.normal(
        color: Theme.of(context).myColors.itemCardBackground,
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
        margin: e.key == data.subOrders!.length - 1 ? null : const EdgeInsets.only(bottom: 8),
        child: Column(children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Flexible(child: FittedBox(child: Text('${e.value.sysOrderId}    ${e.value.createdTime}', style: Theme.of(context).myStyles.labelSmall))),
            MyCard(
              margin:const EdgeInsets.only(left: 20),
              borderRadius: BorderRadius.circular(6),
              padding: const EdgeInsets.only(left: 12, right: 12, top: 4, bottom: 4),
              color: getOrderItemStyle(context, e.value.status).color,
              child: Text(getOrderStatusName(e.value.status), style: getOrderItemStyle(context, e.value.status).style,),
            ),
          ]),
          Row(children: [
            Expanded(flex: 2, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(Lang.sellOrderHistoryAmount.tr, style: Theme.of(context).myStyles.label),
              const SizedBox(height: 2),
              // FittedBox(child: Text(e.value.amount + '-${e.value.isRelease}', style: Theme.of(context).myStyles.labelBigger)),
              FittedBox(child: e.value.isRelease == 0
               ? Text(e.value.amount, style: Theme.of(context).myStyles.labelBigger)
               : [1, 2, 3, 7].contains(e.value.status)
                  ? Row(children: [
                      Text(e.value.amount, style: Theme.of(context).myStyles.labelBigger),
                      const SizedBox(width: 8),
                      Text('${Lang.freeReady.tr}: ${e.value.activityInfo}%', style: Theme.of(context).myStyles.labelRed),
                    ])
                  : [5].contains(e.value.status)
                    ? Row(children: [
                        Text(e.value.amount, style: Theme.of(context).myStyles.labelBigger),
                        const SizedBox(width: 8),
                        Text('${Lang.freeDone.tr}: ${e.value.activityInfo}%', style: Theme.of(context).myStyles.labelGreen),
                      ])
                    : Text(e.value.amount, style: Theme.of(context).myStyles.labelBigger)
              ),
            ])),
            const SizedBox(width: 16),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
              Text(Lang.sellOrderHistorySingle.tr, style: Theme.of(context).myStyles.label),
              const SizedBox(height: 2),
              FittedBox(child: Text('${e.value.price} / ${Lang.flashViewCgb.tr}', style: Theme.of(context).myStyles.labelBigger)),
            ])),
            const SizedBox(width: 16),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.end, mainAxisAlignment: MainAxisAlignment.center, children: [
              MyImage(imageUrl: e.value.icon, height: 16),
            ])),
          ]),
        ]),
      ))).toList()))),
    ]);
  }

  Widget _buildItem(BuildContext context, OrderHistoryModel data) {
    final orderId = data.sysOrderId;
    final time = data.createdTime;
    final aumount = data.quantity;
    final price = data.price;
    final images = data.icons.split('|');
    final statusName = getOrderStatusName(data.status);
    final orderItemStyle = getOrderItemStyle(context, data.status);
    
    return MyButton.widget(
      onPressed: () => controller.goOrderInfoView(data.sysOrderId, data.subOrders != null && data.subOrders!.isNotEmpty ? data.subOrders!.first.sysOrderId : '', false),
      child: MyCard(
        border: Border(bottom: BorderSide(color: Theme.of(context).myColors.buttonDisable.withOpacity( 0.3), width: 1)), 
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
        color: Theme.of(context).myColors.cardBackground, 
        child: Column(children: [
          const SizedBox(height: 8),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Flexible(child: FittedBox(child: Text('$orderId    $time', style: Theme.of(context).myStyles.labelSmall))),
            MyCard(
              margin:const EdgeInsets.only(left: 20),
              borderRadius: BorderRadius.circular(6),
              padding: const EdgeInsets.only(left: 12, right: 12, top: 4, bottom: 4),
              color: orderItemStyle.color,
              child: Text(statusName, style: orderItemStyle.style,),
            ),
          ]),
          const SizedBox(height: 2),
          Row(children: [
            Expanded(flex: 2, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              data.isDivide == 1
                ? Row(children: [
                    Text(Lang.sellOrderHistoryAmount.tr, style: Theme.of(context).myStyles.label),
                    const SizedBox(width: 4),
                    orderSplit,
                  ])
                : Text(Lang.sellOrderHistoryAmount.tr, style: Theme.of(context).myStyles.label),
              const SizedBox(height: 2),
              // FittedBox(child: Text(aumount + '12313', style: Theme.of(context).myStyles.labelBigger)),
              FittedBox(child: data.isRelease == 0
               ? Text(aumount, style: Theme.of(context).myStyles.labelBigger)
               : [1, 2, 3, 7].contains(data.status)
                  ? Row(children: [
                      Text(aumount, style: Theme.of(context).myStyles.labelBigger),
                      const SizedBox(width: 8),
                      Text('${Lang.freeReady.tr}: ${data.activityInfo}%', style: Theme.of(context).myStyles.labelRed),
                    ])
                  : [5].contains(data.status)
                    ? Row(children: [
                        Text(aumount, style: Theme.of(context).myStyles.labelBigger),
                        const SizedBox(width: 8),
                        Text('${Lang.freeDone.tr}: ${data.activityInfo}%', style: Theme.of(context).myStyles.labelGreen),
                      ])
                    : [0].contains(data.status)
                      ? Row(children: [
                          Text(aumount, style: Theme.of(context).myStyles.labelBigger),
                          const SizedBox(width: 8),
                          Text(Lang.free2.tr, style: Theme.of(context).myStyles.labelRed),
                        ])
                      : Text(aumount, style: Theme.of(context).myStyles.labelBigger)
              ),
            ])),
            const SizedBox(width: 16),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
              Text(Lang.sellOrderHistorySingle.tr, style: Theme.of(context).myStyles.label),
              const SizedBox(height: 2),
              FittedBox(child: Text('$price / ${Lang.flashViewCgb.tr}', style: Theme.of(context).myStyles.labelBigger)),
            ])),
            const SizedBox(width: 16),
            Expanded(flex: 2, child: Column(children: [
              const SizedBox(height: 4),
              Row(mainAxisAlignment: MainAxisAlignment.end, children: images.asMap().entries.map((e) => MyCard(
                margin: e.key == images.length -1 ? null : const EdgeInsets.only(right: 4), 
                child: MyImage(imageUrl: e.value, height: 16))).toList()
              ),
              const SizedBox(height: 4),
              data.subOrders == null || data.subOrders!.isEmpty
                ? const SizedBox()
                : MyButton.widget(onPressed: () => showSubOrders(context, data), child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                    Flexible(child: FittedBox(child: MyCard(
                      padding: const EdgeInsets.only(left: 10, right: 10, top: 4, bottom: 4),
                      borderRadius: BorderRadius.circular(8),
                      color: Theme.of(context).myColors.itemCardBackground,
                      child: Row(children: [
                        Theme.of(context).myIcons.downSolid,
                        const SizedBox(width: 4),
                        Text(Lang.sellOrderHistoryInfo.tr, style: Theme.of(context).myStyles.label),
                      ]),
                    ),
                  ),
                ),
              ])),
            ])),
          ]),
          const SizedBox(height: 8),
        ],
      )),
    );
  }
}
