import 'package:cgwallet/common/common.dart';
import 'package:get/get.dart';

class SellOrderInfoState {
  final title = Lang.sellOrderInfoViewTitle.tr;
  final SellOrderArgument sellOrderArgument = Get.arguments;

  final orderSubInfo = OrderSubInfoModel.empty().obs;
  final orderMarketInfo = OrderMarketInfoModel.empty().obs;

  final _countDown = '00:00'.obs;
  String get countDown => _countDown.value;
  set countDown(String value) => _countDown.value = value;

  final _seconds = 0.obs;
  int get seconds => _seconds.value;
  set seconds(int value) => _seconds.value = value;

  final _orderMarketIndex = 0.obs;
  int get orderMarketIndex => _orderMarketIndex.value;
  set orderMarketIndex(int value) => _orderMarketIndex.value = value;

  final _customerType = (-1).obs;
  int get customerType => _customerType.value;
  set customerType(int value) => _customerType.value = value;
}
