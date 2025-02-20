import 'package:cgwallet/common/common.dart';
import 'package:cgwallet/views/views.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:get/get.dart';


class TransferView extends GetView<TransferController> {
  const TransferView({super.key});

  
  @override
  Widget build(BuildContext context) {
    final transferButton = MyButton.text(onPressed: controller.goTransferHistoryView, text: Lang.transferViewHistory.tr);
    var appBar = MyAppBar.normal(
      title: controller.state.title,
      actions: [transferButton, const SizedBox(width: 8)],
    );

    /// 页面构成
    return KeyboardDismissOnTap(child: Scaffold(
      appBar: appBar,
      backgroundColor: Theme.of(context).myColors.background,
      body: _buildBody(context),
    ));
  }

  Widget _buildBody(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 0), 
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        _buildTransferView(context),
        const SizedBox(height: 16, width: double.infinity),
        _buildScan(context),
        const SizedBox(height: 16, width: double.infinity),
        _buildTransferHistory(context),
      ]),
    );
  }

  Widget _buildTransferView(BuildContext context) {
    return MyCard.big(
      child: Column(children: [
        Text(Lang.transferViewContentTitle.tr, style: Theme.of(context).myStyles.labelBigger),
        const SizedBox(height: 8, width: double.infinity),
        Text(Lang.transferViewContent.tr, style: Theme.of(context).myStyles.labelSmall),
        const SizedBox(height: 32, width: double.infinity),
        MyInput.normal(
          controller.addressController, 
          controller.addressFocusNode,
          // color: Theme.of(context).myColors.itemCardBackground,
          prefixIcon: Container(padding: const EdgeInsets.fromLTRB(10, 0, 10, 0), width: 100, height: 40, child: Center(child: FittedBox(child: Text(Lang.transferViewAddress.tr, style: Theme.of(context).myStyles.label)))),
        ),
        const SizedBox(height: 32, width: double.infinity),
        Obx(() => MyButton.filedLong(onPressed: controller.state.isButtonDisable ? null : controller.goTransferCoinView, text: Lang.realNameViewNext.tr)),
      ]),
    );
  }

  Widget _buildScan(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      Text(Lang.transferViewWay1.tr, style: Theme.of(context).myStyles.labelSmall),
      MyButton.widget(onPressed: controller.goScanView, child: Text(Lang.transferViewScan.tr, style: Theme.of(context).myStyles.labelPrimary)),
      Text(Lang.transferViewWay2.tr, style: Theme.of(context).myStyles.labelSmall),
    ],);
  }

  Widget _buildTransferHistory(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(Lang.transferViewHistoryLater.tr, style: Theme.of(context).myStyles.label),
      const SizedBox(height: 8),
      Obx(() {
        if (controller.state.isLoading) {
          return TransferInfoItem.emptyList(context, 3, const EdgeInsets.only(bottom: 1));
        }
        if (controller.state.orderTransferList.value.list.isEmpty) {
          return noDataWidget;
        }
        return Column(children: controller.state.orderTransferList.value.list.asMap().entries.map((e) => TransferInfoItem(
          avatar: e.value.avatarUrl,
          name: e.value.nickName,
          address: e.value.toAddress,
          time: e.value.createTime,
          amount: e.value.amount,
        )).toList());
      }),

    ]);
  }
    
}
