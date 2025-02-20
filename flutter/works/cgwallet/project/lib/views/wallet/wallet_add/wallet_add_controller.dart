import 'dart:convert';

import 'package:cgwallet/common/common.dart';
import 'package:cgwallet/views/views.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WalletAddController extends GetxController {
  final state = WalletAddState();
  final CategoryInfoModel arguments = Get.arguments;

  final nameTextController = TextEditingController();
  final nameFocusNode = FocusNode();

  final bankTextController = TextEditingController();
  final bankFocusNode = FocusNode();

  final alipayTextController = TextEditingController();
  final alipayFocusNode = FocusNode();

  final addressTextController = TextEditingController();
  final addressFocusNode = FocusNode();

  @override
  void onInit() {
    super.onInit();
    state.accountType = arguments.categoryName;
    initIndex();
  }

  @override
  void onReady() async {
    super.onReady();
    await Future.delayed(MyConfig.app.timePageTransition);

    nameTextController.addListener(listener);
    bankTextController.addListener(listener);
    alipayTextController.addListener(listener);
    addressTextController.addListener(listener);
  }

  @override
  void dispose() {
    nameTextController.removeListener(listener);
    bankTextController.removeListener(listener);
    alipayTextController.removeListener(listener);
    addressTextController.removeListener(listener);
    nameTextController.dispose();
    bankTextController.dispose();
    alipayTextController.dispose();
    addressTextController.dispose();
    nameFocusNode.dispose();
    bankFocusNode.dispose();
    alipayFocusNode.dispose();
    addressFocusNode.dispose();
    super.dispose();
  }

  void initIndex() {
    state.index = UserController.to.categoryList.value.list.indexWhere((element) => element.id == arguments.id);
    if (UserController.to.userInfo.value.user.realName.isNotEmpty) {
      nameTextController.text = UserController.to.userInfo.value.user.realName;
    }
  }

  void listener() {
    if ([3].contains(UserController.to.categoryList.value.list[state.index].id)) {
      if (nameTextController.text.isNotEmpty && bankTextController.text.isNotEmpty && state.bank.value.bankName.isNotEmpty) {
        state.isButtonDisable = false;
      } else {
        state.isButtonDisable = true;
      }
    } else if ([2].contains(UserController.to.categoryList.value.list[state.index].id)) {
      if (nameTextController.text.isNotEmpty && (alipayTextController.text.isNotEmpty || state.imageBytes.isNotEmpty)) {
        state.isButtonDisable = false;
      } else {
        state.isButtonDisable = true;
      }
    } else if ([1].contains(UserController.to.categoryList.value.list[state.index].id)) {
      if (nameTextController.text.isNotEmpty && addressTextController.text.isNotEmpty) {
        state.isButtonDisable = false;
      } else {
        state.isButtonDisable = true;
      }
    } else {
      if (nameTextController.text.isNotEmpty &&  state.imageBytes.isNotEmpty) {
        state.isButtonDisable = false;
      } else {
        state.isButtonDisable = true;
      }
    }
  }

  void onAdd() async {
    if (!UserController.to.isSetWalletPassword.value) {
      Get.toNamed(MyRoutes.passwordWalletView);
      MyAlert.snackbar(Lang.bankViewErrorText.tr);
      return;
    }
    Get.focusScope?.unfocus();
    state.isButtonDisable = true;
    final transPassword = await getNumberPassword();
    if (transPassword != null) {
      addBank(transPassword);
    } else {
      state.isButtonDisable = false;
    }
  }

  String getAccount() {
    if ([3].contains(UserController.to.categoryList.value.list[state.index].id)) {
      return bankTextController.text;
    } else if ([2].contains(UserController.to.categoryList.value.list[state.index].id)) {
      return alipayTextController.text;
    } else if ([1].contains(UserController.to.categoryList.value.list[state.index].id)) {
      return addressTextController.text;
    }
    return '';
  }

  Future<void> addBank(String transPassword) async {
    state.isLoading = true;
    showBlock();
    await UserController.to.dio?.post(ApiPath.category.addBank,
      onSuccess: (code, msg, data) async {
        if (Get.isDialogOpen != null && Get.isDialogOpen!) {
          // await Future.delayed(MyConfig.app.timeDebounce);
          // 这里是防止发弹窗的时候没法回到上一页
          Get.back(result: true);
          Get.back(result: true);
        } else {
          Get.back(result: true);
        }
        if (Get.currentRoute == MyRoutes.walletManagerView) {
          final walletMangerController = Get.find<WalletMangerController>();
          showLoading();
          await walletMangerController.refreshData(msg);
          hideLoading();
        } else {
          MyAlert.snackbar(msg);
          Future.delayed(MyConfig.app.timeWait).then((value) => UserController.to.updateBankList());
        }
        final HomeController homeController = Get.find();
        homeController.getUnReadCount();
      },
      onError: () async {
        state.isLoading = false;
        state.isButtonDisable = false;
      },
      data: {
        "payCategoryId": UserController.to.categoryList.value.list[state.index].id,
        "accountName": nameTextController.text,
        "account": getAccount(),
        "bankId": state.bank.value.id,
        // "bankAddress": addressTextController.text,
        "qrcode": base64Encode(state.imageBytes),
        "transPassword": transPassword.encrypt(MyConfig.key.aesKey),
        // "isDefault": 0,
      },
    );
    hideBlock();
  }

  void onAccountType() async {
    final result = await showCategorySheet(state.index);
    if (result != null) {
      state.imageBytes.clear();
      state.index = UserController.to.categoryList.value.list.indexWhere((element) => element.id == result.id);
      state.accountType = UserController.to.categoryList.value.list[state.index].categoryName;
      state.bank.value = BankNameModel.empty();
      state.bank.refresh();
      bankTextController.text = '';
      alipayTextController.text = '';
      addressTextController.text = '';
    }
  }

  void goBanksView() async {
   final bank = await Get.toNamed(MyRoutes.banksView) as BankNameModel?;
   if (bank != null) {
     state.bank.value = bank;
     state.bank.refresh();
     listener();
   }
  }

  void onPickImage() async {
    final image = await MyGallery.to.pickImage();
    final imageBytes = await image?.readAsBytes();
    if (imageBytes != null) {
      state.imageBytes = imageBytes;
      listener();
    }
  }
}
