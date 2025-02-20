import 'package:cgwallet/common/common.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import 'index.dart';

class SellOrderController extends GetxController {
  final state = SellOrderState();

  final minTextController = TextEditingController();
  final minFocusNode = FocusNode();

  final maxTextController = TextEditingController();
  final maxFocusNode = FocusNode();

  final amountController = TextEditingController();
  final amountFocusNode = FocusNode();

  @override
  void onReady() async {
    super.onReady();
    await Future.delayed(MyConfig.app.timePageTransition);
    await UserController.to.updateOrderSetting();
    inputAddListener();
  }

  @override
  void onClose() {
    inputRemoveListener();
    super.onClose();
  }

  void inputAddListener() {
    minTextController.addListener(listener);
    maxTextController.addListener(listener);
    amountController.addListener(listener);
  }

  void inputRemoveListener() {
    minTextController.removeListener(listener);
    maxTextController.removeListener(listener);
    amountController.removeListener(listener);
  }

  void onSellAll() {
    amountController.text = UserController.to.userInfo.value.balance.split('.').first;
  }

  void onSplit(int index) {
    if (state.splitIndex != index) {
      state.splitIndex = index;
    }
    listener();
  }

  void onChooseBank(int index) {
    if (state.bankIndex[index] == 0) {
      state.bankIndex[index] = 1;
      if (UserController.to.bankList.value.list[index].list.isNotEmpty) {
        state.bankInfoList.add(UserController.to.bankList.value.list[index].list[state.cardIndex[index]]);
      } else {
        final empty = BankInfoModel.empty();
        empty.id = index;
        empty.categoryName = UserController.to.categoryList.value.list[index].categoryName;
        state.bankInfoList.add(empty);
      }
      state.bankInfoList.refresh();
    } else {
      state.bankIndex[index] = 0;
      if (UserController.to.bankList.value.list[index].list.isNotEmpty) {
        state.bankInfoList.removeWhere((e) => e.payCategoryId == UserController.to.bankList.value.list[index].list[state.cardIndex[index]].payCategoryId);
      } else {
        state.bankInfoList.removeWhere((e) => e.id == index);
      }
      state.bankInfoList.refresh();
    }
    listener();
  }

  void onAddBank(String name) async {
    final data = UserController.to.categoryList.value.list.where((element) => element.categoryName == name);
    if (data.isNotEmpty) {
      final result = await Get.toNamed(MyRoutes.walletAddView, arguments: data.first);
      if (result != null) {
        showLoading();
        await UserController.to.updateBankList();
        hideLoading();
        listener();
      }
    }
  }

  void onSellCoin() async {
    Get.focusScope?.unfocus();
    final numberPassword = await getNumberPassword();
    if (numberPassword != null) {
      sellCoin(numberPassword);
    }
  }

  Future<void> sellCoin(String numberPassword) async {
    final banksList = state.bankInfoList.where((e) => e.payCategoryId != -1);
    final list = banksList.map((e) => e.id).toList();
    showLoading();

    await UserController.to.dio?.post(ApiPath.market.sellCoin,
      onSuccess: (code, msg, data) {
        Get.back();
        MyAlert.snackbar(msg);
        Future.delayed(MyConfig.app.timeWait).then((v) => UserController.to.updateUserInfo());
      },
      data: {
        "quantity": amountController.text,
        "isDivide": state.splitIndex,
        if (state.splitIndex == 1)
          "minAmt": minTextController.text,
        if (state.splitIndex == 1)
          "maxAmt": maxTextController.text,
        "transPassword": numberPassword.encrypt(MyConfig.key.aesKey),
        "paymentCollect": list,
      },
    );

    hideLoading();
  }

  void onChooseCard(int bankIndex, MapEntry<int, BankInfoModel> card) {
    Get.back();
    if (state.cardIndex[bankIndex] == card.key) {
      return;
    }
    state.cardIndex[bankIndex] = card.key;
    state.cardIndex.refresh();
    for (int i = 0; i < state.bankInfoList.length; i++) {
      if (state.bankInfoList[i].payCategoryId == card.value.payCategoryId) {
        state.bankInfoList[i] = card.value;
        break;
      }
    }
    state.bankInfoList.refresh();
    listener();
  }

  void listener() {
    final banksList = state.bankInfoList.where((e) => e.payCategoryId != -1);
    final isAmountNotEmpty = amountController.text.isNotEmpty;
    final isMinNotEmpty = minTextController.text.isNotEmpty;
    final isMaxNotEmpty = maxTextController.text.isNotEmpty;
    final isBankCardNotEmpty = banksList.isNotEmpty;
    int inRangeCount = 0;

    for (int i = 0; i < state.bankIndex.length; i++) {
      if (state.bankIndex[i] == 1) {
        if (state.splitIndex == 1 && minTextController.text.isNotEmpty) {
          final isMinTextLessThanTargetMin = double.parse(minTextController.text) < double.parse(UserController.to.orderSetting.value.sellAmountRange[UserController.to.categoryList.value.list[i].payCategorySn]?['min']);
          final isMinTextGreaterThanTargetMax = double.parse(minTextController.text) > double.parse(UserController.to.orderSetting.value.sellAmountRange[UserController.to.categoryList.value.list[i].payCategorySn]?['max']);

          // final isMaxTextGreaterThanTargetMax = double.parse(maxTextController.text.isEmpty ? '0' : maxTextController.text) > double.parse(UserController.to.orderSetting.value.sellAmountRange[UserController.to.categoryList.value.list[i].payCategorySn]?['max']);
          if (isMinTextLessThanTargetMin || isMinTextGreaterThanTargetMax) {
            state.bankIndex[i] = 0;
            if (UserController.to.bankList.value.list[i].list.isNotEmpty) {
              state.bankInfoList.removeWhere((e) => e.payCategoryId == UserController.to.bankList.value.list[i].list[state.cardIndex[i]].payCategoryId);
            } else {
              state.bankInfoList.removeWhere((e) => e.id == i);
            }
            state.bankInfoList.refresh();
          }
        }

        if (state.splitIndex == 0 && amountController.text.isNotEmpty) {
          if (double.parse(amountController.text) < double.parse(UserController.to.orderSetting.value.sellAmountRange[UserController.to.categoryList.value.list[i].payCategorySn]?['min']) || double.parse(amountController.text) > double.parse(UserController.to.orderSetting.value.sellAmountRange[UserController.to.categoryList.value.list[i].payCategorySn]?['max'])) {
            state.bankIndex[i] = 0;
            if (UserController.to.bankList.value.list[i].list.isNotEmpty) {
              state.bankInfoList.removeWhere((e) => e.payCategoryId == UserController.to.bankList.value.list[i].list[state.cardIndex[i]].payCategoryId);
            } else {
              state.bankInfoList.removeWhere((e) => e.id == i);
            }
            state.bankInfoList.refresh();
          }
        }
      }
    }

    state.bankIndex.refresh();

    for (int i = 0; i < state.bankIndex.length; i++) {
      if (state.bankIndex[i] == 1) {
        inRangeCount++;
      }
    }


    if (state.splitIndex == 1) {
      state.isButtonDisable = !(isAmountNotEmpty && isMinNotEmpty && isMaxNotEmpty && isBankCardNotEmpty && inRangeCount > 0);
    } else {
      state.isButtonDisable = !(isAmountNotEmpty && isBankCardNotEmpty);
    }
  }
}
