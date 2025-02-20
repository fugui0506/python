import 'package:cgwallet/common/common.dart';
import 'package:get/get.dart';

class FlashOrderHistoryState {
  final historyList = OrderFlashInfoListModel.empty().obs;
  final parmas = _Parmas.empty().obs;
  final title = Lang.flashOrderHistoryViewTitle.tr;

  final _typeIndex = 0.obs;
  int get typeIndex => _typeIndex.value;
  set typeIndex(int value) => _typeIndex.value = value;

  final _daysIndex = 2.obs;
  int get daysIndex => _daysIndex.value;
  set daysIndex(int value) => _daysIndex.value = value;

  final _isLoading = true.obs;
  bool get isLoading => _isLoading.value;
  set isLoading(bool value) => _isLoading.value = value;

  final typeList = [
    Lang.buyOrderViewAll.tr,
    Lang.flashOrderHistoryViewOrderTypePay.tr,
    Lang.flashOrderHistoryViewOrderTypeConfirm.tr,
    Lang.flashOrderHistoryViewOrderTypeDone.tr,
    Lang.flashOrderHistoryViewOrderTypeCancel.tr,
  ].obs;

  final daysList = [
    Lang.flashOrderHistoryViewTimeDay1.tr,
    Lang.flashOrderHistoryViewTimeDay7.tr,
    Lang.flashOrderHistoryViewTimeDay30.tr,
  ].obs;
}

class _Parmas {
  int page;
  int pageSize;
  // 1:待收款 2:待确认 3:已完成,4:取消,5:失败,99:全部
  int state;
  // 1:今天 2:7天 3:30天
  int days;

  _Parmas({
    required this.page,
    required this.pageSize,
    required this.state,
    required this.days,
  });

  factory _Parmas.empty() => _Parmas(
    page: 1,
    pageSize: 10,
    state: 99,
    days: 2,
  );

  Map<String, dynamic> toJson() => {
    "page": page,
    "pageSize": pageSize,
    "state": state,
    "days": days,
  };
}
