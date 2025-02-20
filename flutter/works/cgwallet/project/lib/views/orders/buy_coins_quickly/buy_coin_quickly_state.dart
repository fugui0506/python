import 'package:cgwallet/common/common.dart';
import 'package:get/get.dart';

class BuyCoinsQuicklyState {
  final title = Lang.buyCoinsQuicklyViewTitle.tr;
  final amounts = UserController.to.orderSetting.value.quicklyBuyAmountList[UserController.to.categoryList.value.list[0].payCategorySn].toString().split(',').obs;

  final _amount = ''.obs;
  String get amount => _amount.value;
  set amount(String value) => _amount.value = value;

  final _categoryIndex = 0.obs;
  int get categoryIndex => _categoryIndex.value;
  set categoryIndex(int value) => _categoryIndex.value = value;

  final _amountIndex = (-1).obs;
  int get amountIndex => _amountIndex.value;
  set amountIndex(int value) => _amountIndex.value = value;

  final _cardIndex = List.generate(UserController.to.bankList.value.list.length, (index) => 0).obs;
  List<int> get cardIndex => _cardIndex;
  set cardIndex(List<int> value) {
    _cardIndex.value = value;
    _cardIndex.refresh();
  }

  final _isButtonDisable = true.obs;
  bool get isButtonDisable => _isButtonDisable.value;
  set isButtonDisable(bool value) => _isButtonDisable.value = value;

  final _bankInfo = BankInfoModel.empty().obs;
  BankInfoModel get bankInfo => _bankInfo.value;
  set bankInfo(BankInfoModel value) {
    _bankInfo.value = value;
    _bankInfo.refresh();
  }
}
