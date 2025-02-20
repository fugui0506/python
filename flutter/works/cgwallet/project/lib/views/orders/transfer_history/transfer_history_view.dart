import 'package:cgwallet/common/common.dart';
import 'package:cgwallet/views/views.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TransferHistoryView extends GetView<TransferHistoryController> {
  const TransferHistoryView({super.key});

  
  @override
  Widget build(BuildContext context) {

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
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      _buildTransferTitle(context),
      const SizedBox(height: 8, width: double.infinity),
      Expanded(child: _buildTransferHistoryList(context)),
    ]);
  }

  Widget _buildTransferTitle(BuildContext context) {
    final row = Row(children: [
      Expanded(child: Obx(() => MyButton.filedLong(
        color: controller.state.responseData.value.dateType == 1 ? Theme.of(context).myColors.primary : Theme.of(context).myColors.cardBackground,
        textColor: controller.state.responseData.value.dateType == 1 ? Theme.of(context).myColors.onPrimary : Theme.of(context).myColors.onCardBackground,
        onPressed: () => controller.updateResponseData(1), 
        text: Lang.transferHistoryViewToday.tr,
      ))),
      const SizedBox(width: 10),
      Expanded(child: Obx(() => MyButton.filedLong(
        color: controller.state.responseData.value.dateType == 3 ? Theme.of(context).myColors.primary : Theme.of(context).myColors.cardBackground,
        textColor: controller.state.responseData.value.dateType == 3 ? Theme.of(context).myColors.onPrimary : Theme.of(context).myColors.onCardBackground,
        onPressed: () => controller.updateResponseData(3), 
        text: Lang.transferHistoryViewMonth.tr,
      ))),
    ]);

    return Padding(padding: const EdgeInsets.fromLTRB(16, 0, 16, 0), child: row);
  }

  Widget _buildTransferHistoryList(BuildContext context) {
    return Obx(() => controller.state.isLoading 
      ? TransferInfoItem.emptyList(context, 20, const EdgeInsets.fromLTRB(16, 0, 16, 1)) 
      : controller.state.orderTransferHistoryList.value.list.isEmpty 
        ? noDataWidget 
        : MyRefreshView(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
          controller: controller.refreshController,
          onRefresh: controller.onRefresh,
          onLoading: controller.onLoading,
          children: controller.state.orderTransferHistoryList.value.list.asMap().entries.map((e) => TransferInfoItem(
            address: e.value.toAddress,
            avatar: e.value.avatarUrl,
            amount: e.value.amount,
            name: e.value.nickName,
            time: e.value.createTime,
          )).toList(),
      ),
    );
  }
    
}
