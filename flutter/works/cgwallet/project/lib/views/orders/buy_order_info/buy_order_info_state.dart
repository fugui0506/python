import 'package:cgwallet/common/common.dart';
import 'package:get/get.dart';

class BuyOrderInfoState {
  final title = Lang.buyOrderInfoViewTitle.tr;
  String id = Get.arguments;
  final orderSubInfo = OrderSubInfoModel.empty().obs;

  // final _isLoading = true.obs;
  // bool get isLoading => _isLoading.value;
  // set isLoading(bool value) => _isLoading.value = value;

  final _seconds = 0.obs;
  int get seconds => _seconds.value;
  set seconds(int value) => _seconds.value = value;

  final _reasonIndex = 0.obs;
  int get reasonIndex => _reasonIndex.value;
  set reasonIndex(int value) => _reasonIndex.value = value;

  final _countDown = '00:00'.obs;
  String get countDown => _countDown.value;
  set countDown(String value) => _countDown.value = value;

  final reasons = [
    Lang.buyOrderInfoViewCancelReason1.tr,
    Lang.buyOrderInfoViewCancelReason2.tr,
    Lang.buyOrderInfoViewCancelReason3.tr,
    Lang.buyOrderInfoViewCancelReason4.tr,
  ];

  final upLoadPaths = [
    <int>[].obs,
    <int>[].obs,
    <int>[].obs,
  ];

  final _customerType = (-1).obs;
  int get customerType => _customerType.value;
  set customerType(int value) => _customerType.value = value;
}
