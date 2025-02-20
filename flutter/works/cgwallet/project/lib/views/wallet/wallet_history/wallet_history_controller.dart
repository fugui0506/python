import 'package:cgwallet/common/common.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';


import 'index.dart';

class WalletHistoryController extends GetxController {
  final state = WalletHistoryState();
  final ScrollController scrollController = ScrollController();

  Worker? paramsListener;

  @override
  void onReady() async {
    super.onReady();
    await Future.delayed(MyConfig.app.timePageTransition);
    updateWalletHistory();
    updateGeneralTypeList();

    paramsListener = debounce(state.parmas, (callback) async {
      if (state.generalTypeList.value.list.isEmpty) {
        return;
      }
      if (state.dateIndex == callback.dateType && state.generalTypeList.value.list[state.typeIndex].subType == callback.typeIds) {
        return;
      }
      state.isLoading = true;
      await updateWalletHistory();
      state.isLoading = false;
    }, time: MyConfig.app.timeDebounce);
  }

  @override
  void onClose() {
    paramsListener?.call();
    super.onClose();
  }

  void onTody() {
    state.dateIndex = 1;
    state.parmas.update((val) {
      val!.dateType = 1;
    });
  }

  void onThisMonth() {
    state.dateIndex = 3;
    state.parmas.update((val) {
      val!.dateType = 3;
    });
  }

  void onChooiseType(int index) {
    Get.back();
    state.typeIndex = index;
    if(state.generalTypeList.value.list.isEmpty) return;
    state.parmas.update((val) {
      val!.typeIds = state.generalTypeList.value.list[index].subType;
    });
  }

  void goSellOrdersView() {
    Get.toNamed(MyRoutes.sellOrderListView);
  }

  Future updateGeneralTypeList() async {
    await state.generalTypeList.value.update();
    state.generalTypeList.refresh();
  }

  Future updateWalletHistory() async {
    await state.walletHistory.value.update(state.parmas.toJson());
    state.walletHistory.refresh();
    state.isLoading = false;
  }
}
