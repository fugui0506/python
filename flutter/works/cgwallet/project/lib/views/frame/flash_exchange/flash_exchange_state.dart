import 'package:cgwallet/common/common.dart';
import 'package:get/get.dart';

class FlashExchangeState {
  final swapSetting = SwapSettingModel.empty().obs;

  final _protocolIndex = 0.obs;
  int get protocolIndex => _protocolIndex.value;
  set protocolIndex(int value) => _protocolIndex.value = value;

  final _isButtonDisable = true.obs;
  bool get isButtonDisable => _isButtonDisable.value;
  set isButtonDisable(bool value) => _isButtonDisable.value = value;

  final _amoutCGB = 0.0.obs;
  double get amoutCGB => _amoutCGB.value;
  set amoutCGB(double value) => _amoutCGB.value = value;
}
