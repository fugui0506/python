import 'package:cgwallet/common/common.dart';
import 'package:cgwallet/views/views.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class BuyOrderListController extends GetxController {
  final state = BuyOrderListState();
  final RefreshController refreshController = RefreshController();

  Worker? worker;

  @override
  void onInit() {
    super.onInit();
    setTime();
  }

  @override
  void onClose() {
    worker?.call();
    super.onClose();
  }

  @override
  void onReady() async {
    super.onReady();
    await Future.delayed(MyConfig.app.timePageTransition);
    await onRefresh();
    state.isLoading = false;

    worker = debounce(state.orderHistoryParameter, (callback) async {
      showLoading();
      await onRefresh();
      hideLoading();
    }, time: MyConfig.app.timeDebounce);
  }

  void setTime() {
    final today = DateTime.now();
    final ago = today.subtract(const Duration(days: 30));
    state.orderHistoryParameter.value.beginDate = '$ago'.split(' ').first;
    state.orderHistoryParameter.value.endDate = '$today'.split(' ').first;
    setShowTime();
  }

  void onBuyOrderInfoView(OrderHistoryModel data) async {
    await Get.toNamed(MyRoutes.buyOrderInfoView, arguments: data.sysOrderId);
    // showLoading();
    // await updateOrderHistoryList();
    // hideLoading();
  }

  void setShowTime() {
    final beginDate = state.orderHistoryParameter.value.beginDate.replaceAll('-', '');
    final endDate = state.orderHistoryParameter.value.endDate.replaceAll('-', '');
    state.showTime = '$beginDate-$endDate';
  }

  void onChooseType(int index) {
    Get.back();
    state.typeIndex = index;

    switch (index) {
      case 0:
        state.orderHistoryParameter.value.status = [99];
        break;
      case 1:
        state.orderHistoryParameter.value.status = [0, 1, 2, 3, 7];
        break;
      case 2:
        state.orderHistoryParameter.value.status = [5];
        break;
      case 3:
        state.orderHistoryParameter.value.status = [6, 4];
        break;
      default:
    }

    state.orderHistoryParameter.refresh();
  }

  Future<void> onBanks() async {
    final result = await showCategoryAllSheet(state.categoryIndex);
    if (result != null) {
      if (result.id == -1) {
        state.categoryIndex = -1;
        state.categoryTitle = Lang.buyOrderViewBanks.tr;
        state.orderHistoryParameter.value.payCategoryId = [99];
        state.orderHistoryParameter.refresh();
      } else {
        state.categoryIndex = UserController.to.categoryList.value.list.indexWhere((element) => element.id == result.id);
        state.categoryTitle = result.categoryName;
        state.orderHistoryParameter.value.payCategoryId = [result.id];
        state.orderHistoryParameter.refresh();
      }
    }
  }

  Future<void> onRefresh() async {
    state.orderHistoryParameter.value.page = 1;
    await state.orderHistoryList.value.onRefresh(state.orderHistoryParameter.toJson(), isBuy: true);
    state.orderHistoryList.refresh();
    refreshController.refreshCompleted();
    refreshController.resetNoData();
  }

  // Future<void> updateOrderHistoryList() async {
  //   await state.orderHistoryList.value.onRefresh(state.orderHistoryParameter.toJson(), isBuy: true);
  //   state.orderHistoryList.refresh();
  // }

  Future<void> onLoading() async {
    state.orderHistoryParameter.value.page += 1;
    final isNoData = await state.orderHistoryList.value.onLoading(state.orderHistoryParameter.toJson());
    if (isNoData) {
      refreshController.loadNoData();
      state.orderHistoryParameter.value.page -= 1;
    } else {
      refreshController.loadComplete();
    }
    state.orderHistoryList.refresh();
  }
}
