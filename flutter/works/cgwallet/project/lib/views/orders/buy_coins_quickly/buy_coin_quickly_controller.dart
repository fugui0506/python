import 'package:cgwallet/common/common.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import 'index.dart';

class BuyCoinsQuicklyController extends GetxController {
  final state = BuyCoinsQuicklyState();

  final amountController = TextEditingController();
  final amountFocusNode = FocusNode();

  @override
  void onReady() async {
    super.onReady();
    if (UserController.to.bankList.value.list.isNotEmpty && state.cardIndex.isNotEmpty) {
      state.bankInfo = UserController.to.bankList.value.list[state.categoryIndex].list[state.cardIndex[state.categoryIndex]];
    }
    await Future.delayed(MyConfig.app.timePageTransition);

    await UserController.to.updateOrderSetting();
    amountController.addListener(listener);
    // changeCategory(0);
  }

  @override
  void onClose() {
    amountController.removeListener(listener);
    super.onClose();
  }

  void setEmptyCategory() {
    state.categoryIndex = -1;
    state.bankInfo = BankInfoModel.empty();
    state.bankInfo.categoryName = '';
    state.amounts.value = [];
  }

  void changeCategory(int index) {
    if (index >= UserController.to.bankList.value.list.length) {
      return;
    }
    if (state.categoryIndex == index) {
      setEmptyCategory();
    } else {
      state.categoryIndex = index;
      final list = UserController.to.bankList.value.list[state.categoryIndex].list;
      if (list.isEmpty) {
        state.bankInfo = BankInfoModel.empty();
        state.bankInfo.categoryName = UserController.to.categoryList.value.list[state.categoryIndex].categoryName;
      } else {
        state.bankInfo = list[state.cardIndex[state.categoryIndex]];
        state.amounts.value = UserController.to.orderSetting.value.quicklyBuyAmountList[UserController.to.categoryList.value.list[index].payCategorySn].toString().split(',');
      }
    }
    listener();
  }
  
  void goWalletAddView() async {
    if (state.categoryIndex == -1) {
      Get.toNamed(MyRoutes.walletAddView);
      return;
    }
    final arguments = UserController.to.categoryList.value.list[state.categoryIndex];
    final result = await Get.toNamed(MyRoutes.walletAddView, arguments: arguments);
    if (result != null) {
      await Future.delayed(MyConfig.app.timeWait);
      await UserController.to.updateBankList();
    }
  }

  void onChooseCard(MapEntry<int, BankInfoModel> e) {
    Get.back();
    state.cardIndex[state.categoryIndex] = e.key;
    state.bankInfo = e.value;
  }

  void changeAmount(MapEntry<int, String> e) {
    state.amountIndex = e.key;
    amountController.text = e.value;
  }

  void listener() {
    state.amount = amountController.text;
    // print(state.categoryIndex);
    if (state.categoryIndex >= 0) {
      bool isNotInMin = double.parse(state.amount.isEmpty ? '999999999' : state.amount) < double.parse(UserController.to.orderSetting.value.sellAmountRange[UserController.to.categoryList.value.list[state.categoryIndex].payCategorySn]?['min']);
      bool isNotInMax = double.parse(state.amount.isEmpty ? '0' : state.amount) > double.parse(UserController.to.orderSetting.value.sellAmountRange[UserController.to.categoryList.value.list[state.categoryIndex].payCategorySn]?['max']);

      if (isNotInMax || isNotInMin) {
        setEmptyCategory();
        // print(state.categoryIndex);
      }
    }


    state.amountIndex = state.amounts.indexWhere((element) => element == amountController.text);
    final isHaveBankInfo = state.bankInfo.id != -1;
    final isHaveAmount = amountController.text.isNotEmpty;
    final isChoiceCategory = state.categoryIndex >= 0;

    if (isHaveBankInfo && isHaveAmount && isChoiceCategory) {
      state.isButtonDisable = false;
    } else {
      state.isButtonDisable = true;
    }
  }

  void onQuicklyBuyCoins() async {
    final numberPassword = await getNumberPassword();
    if (numberPassword != null) {
      quicklyBuyCoins(numberPassword);
    }
  }

  Future<void> quicklyBuyCoins(String numberPassword) async {
    showLoading();
    state.isButtonDisable = true;
    await UserController.to.dio?.post<OrderSubInfoModel>(ApiPath.market.quicklyBuyCoins,
      onSuccess: (code, msg, data) async {
        final arguments = data.sysOrderId;
        await Get.toNamed(MyRoutes.buyOrderInfoView, arguments: arguments);
        Future.delayed(MyConfig.app.timeWait).then((v) => UserController.to.updateUserInfo());
      },
      onError: () {
        state.isButtonDisable = false;
      },
      onModel: (m) => OrderSubInfoModel.fromJson(m),
      data: {
        'memberAccountCollectId': state.bankInfo.id,
        'amount': amountController.text,
        'transPassword': numberPassword.encrypt(MyConfig.key.aesKey),
      },
    );
    hideLoading();
  }
}
