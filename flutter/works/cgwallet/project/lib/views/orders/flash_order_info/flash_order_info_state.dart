import 'package:cgwallet/common/common.dart';
import 'package:get/get.dart';

class FlashOrderInfoState {
  final orderInfo = OrderFlashInfoModel.empty().obs;

  final _countDown = '00:00'.obs;
  String get countDown => _countDown.value;
  set countDown(String value) => _countDown.value = value;

  final _seconds = 0.obs;
  int get seconds => _seconds.value;
  set seconds(int value) => _seconds.value = value;
}
