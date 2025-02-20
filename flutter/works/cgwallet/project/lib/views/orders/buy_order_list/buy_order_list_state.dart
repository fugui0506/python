import 'package:cgwallet/common/common.dart';
import 'package:get/get.dart';

class BuyOrderListState {
  final title = Lang.buyOrderHistoryTitle.tr;
  final orderHistoryList = OrderHistoryListModel.empty().obs;
  final orderHistoryParameter = OrderHistoryParameterModel.buy().obs;

  final typeList = [
    Lang.buyOrderHistoryAll.tr,
    Lang.buyOrderHistoryIng.tr,
    Lang.buyOrderHistoryDone.tr,
    Lang.buyOrderHistoryCancel.tr,
  ].obs;

  final _typeIndex = 0.obs;
  int get typeIndex => _typeIndex.value;
  set typeIndex(int value) => _typeIndex.value = value;

  final _categoryIndex = (-1).obs;
  int get categoryIndex => _categoryIndex.value;
  set categoryIndex(int value) => _categoryIndex.value = value;

  final _categoryTitle = Lang.buyOrderViewBanks.tr.obs;
  String get categoryTitle => _categoryTitle.value;
  set categoryTitle(String value) => _categoryTitle.value = value;

  // final _startTime = ''.obs;
  // String get startTime => _startTime.value;
  // set startTime(String value) => _startTime.value = value;

  // final _endTime = ''.obs;
  // String get endTime => _endTime.value;
  // set endTime(String value) => _endTime.value = value;

  final _showTime = Lang.buyOrderHistoryTime.tr.obs;
  String get showTime => _showTime.value;
  set showTime(String value) => _showTime.value = value;

  final _isLoading = true.obs;
  bool get isLoading => _isLoading.value;
  set isLoading(bool value) => _isLoading.value = value;
}
