import 'package:cgwallet/common/common.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'banks_index.dart';

class BanksController extends GetxController {
  final state = BanksState();

  final TextEditingController searchController = TextEditingController();
  final FocusNode serachNode = FocusNode();

  final scrollController = ScrollController();

  @override
  void onReady() async {
    super.onReady();
    await Future.delayed(MyConfig.app.timePageTransition);
    await getBankNameInfo();
    scrollController.addListener(listener);
  }

  @override
  void onClose() {
    scrollController.removeListener(listener);
    super.onClose();
  }

  void listener() {
    Get.focusScope?.unfocus();
  }

  void onSearch() {
    if (searchController.text.isEmpty) {
      state.isSearch = false;
      state.currtent.clear();
    } else {
      state.isSearch = true;
      List<BankNameModel> dataList = [];
      var list = searchController.text.split('').toSet().toList();
      for (var element in state.bankNameMapList.value.list) {
        for (var bank in element.bankNameList) {
          int i = 0;
          for (var e in list) {
            if (bank.bankName.contains(e)) {
              i++;
            }
          }

          if (i == list.length) {
            dataList.add(bank);
          }
        }
      }
      final toset = dataList.toSet().toList();
      state.currtent.value = toset;
      state.currtent.refresh();
    }
  }

  void onChoice(BankNameModel data) {
    Get.back(result: data);
  }

  Future<void> getBankNameInfo() async {
    await state.bankNameMapList.value.update();
    state.bankNameMapList.refresh();
    state.isLoading = false;
  }
}
