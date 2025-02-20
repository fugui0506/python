import 'package:cgwallet/common/common.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'index.dart';

class TransferHistoryController extends GetxController {
  final state = TransferHistoryState();

  final amountController = TextEditingController();
  final amountFocusNode = FocusNode();

  final RefreshController refreshController = RefreshController();

  Worker? worker;

  @override
  void onReady() async {
    super.onReady();
    await Future.delayed(MyConfig.app.timePageTransition);
    await updateOrderTransferHistory();
    state.isLoading = false;

    worker = debounce(state.responseData, (callback) async {
      // state.orderHistoryParameter.value.page = 1;
      state.isLoading = true;
      await updateOrderTransferHistory();
      state.isLoading = false;
      // refreshController.resetNoData();
    }, time: MyConfig.app.timeDebounce);
  }

  Future updateOrderTransferHistory() async {
    final data = state.responseData.toJson();
    await state.orderTransferHistoryList.value.onRefresh(data);
    state.orderTransferHistoryList.refresh();
  }

  void updateResponseData(int type) {
    state.responseData.value.dateType = type;
    state.responseData.refresh();
  }

  Future<void> onRefresh() async {
    state.responseData.value.page = 1;
    await state.orderTransferHistoryList.value.onRefresh(state.responseData.toJson());
    state.orderTransferHistoryList.refresh();
    refreshController.refreshCompleted();
    refreshController.resetNoData();
  }

  // Future<void> updateOrderHistoryList() async {
  //   await state.orderHistoryList.value.onRefresh(state.orderHistoryParameter.toJson(), isBuy: true);
  //   state.orderHistoryList.refresh();
  // }

  Future<void> onLoading() async {
    state.responseData.value.page += 1;
    final isNodata = await state.orderTransferHistoryList.value.onLoading(state.responseData.toJson());
    if (isNodata) {
      refreshController.loadNoData();
      state.responseData.value.page -= 1;
    } else {
      refreshController.loadComplete();
    }
    state.orderTransferHistoryList.refresh();
  }
}
