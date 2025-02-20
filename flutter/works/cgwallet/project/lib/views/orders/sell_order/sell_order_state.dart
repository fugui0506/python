import 'package:cgwallet/common/common.dart';
import 'package:get/get.dart';

class SellOrderState {
  final title = Lang.sellOrderViewTitle.tr;

  final _splitIndex = 1.obs;
  set splitIndex(int vale) => _splitIndex.value = vale;
  int get splitIndex => _splitIndex.value;

  final cardIndex = List.generate(UserController.to.bankList.value.list.length, (index) => 0).obs;
  final bankIndex = List.generate(UserController.to.bankList.value.list.length, (index) => 0).obs;
  final bankInfoList = <BankInfoModel>[].obs;

  final _isButtonDisable = true.obs;
  set isButtonDisable(bool value) => _isButtonDisable.value = value;
  bool get isButtonDisable => _isButtonDisable.value;
}
