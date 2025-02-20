import 'package:cgwallet/common/common.dart';
import 'package:cgwallet/common/models/transfer_user_model.dart';
import 'package:get/get.dart';

class TransferCoinState {
  final title = Lang.transferViewTitle.tr;
  final String address = Get.arguments;
  final transferUser = TransferUserModel.empty().obs;
  final settings = TransferSettings.empty().obs;

  final _isLoading = true.obs;
  bool get isLoading => _isLoading.value;
  set isLoading(bool value) {
    _isLoading.value = value;
    _isLoading.refresh();
  }

  final _stepIndex = 1.obs;
  int get stepIndex => _stepIndex.value;
  set stepIndex(int value) => _stepIndex.value = value;

  final _isButtonDisable = true.obs;
  bool get isButtonDisable => _isButtonDisable.value;
  set isButtonDisable(value) => _isButtonDisable.value = value;
}



