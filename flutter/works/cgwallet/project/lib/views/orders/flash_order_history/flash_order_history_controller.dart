import 'package:cgwallet/common/common.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'index.dart';

class FlashOrderHistoryController extends GetxController {
  final state = FlashOrderHistoryState();
  final RefreshController refreshController = RefreshController();

  Worker? worker;

  @override
  void onReady() async {
    super.onReady();
    await Future.delayed(MyConfig.app.timePageTransition);
    await onRefresh();
    state.isLoading = false;

    worker = debounce(state.parmas, (callback) async {
      // state.orderHistoryParameter.value.page = 1;
      showLoading();
      await onRefresh();
      hideLoading();
    }, time: MyConfig.app.timeDebounce);
  }

  @override
  void onClose() {
    worker?.call();
    super.onClose();
  }

  Future<void> onRefresh() async {
    state.parmas.value.page = 1;
    await state.historyList.value.onRefresh(state.parmas.toJson());
    state.historyList.refresh();
    refreshController.refreshCompleted();
    refreshController.resetNoData();
  }

  Future<void> onLoading() async {
    state.parmas.value.page += 1;
    final isNodata = await state.historyList.value.onLoading(state.parmas.toJson());
    if (isNodata) {
      refreshController.loadNoData();
      state.parmas.value.page -= 1;
    } else {
      refreshController.loadComplete();
    }
    state.historyList.refresh();
  }

  void onChooiseType(int index) {
    Get.back();
    state.typeIndex = index;

    switch (index) {
      case 0:
        state.parmas.value.state = 99;
        break;
      case 1:
        state.parmas.value.state = 1;
        break;
      case 2:
        state.parmas.value.state = 2;
        break;
      case 3:
        state.parmas.value.state = 3;
        break;
      case 4:
        state.parmas.value.state = 4;
      default:
    }

    state.parmas.refresh();
  }

  void onChooiseDay(int index) {
    Get.back();
    state.daysIndex = index;

    switch (index) {
      case 0:
        state.parmas.value.days = 1;
        break;
      case 1:
        state.parmas.value.days = 2;
        break;
      case 2:
        state.parmas.value.days = 3;
        break;
      default:
    }

    state.parmas.refresh();
  }

  void goFlashOrderInfoView(OrderFlashInfoModel data) {
    Get.toNamed(MyRoutes.flashOrderInfoView, arguments: data);
  }

  String getOrderStatusName(int status) {
    return state.typeList[status];
  }
}
