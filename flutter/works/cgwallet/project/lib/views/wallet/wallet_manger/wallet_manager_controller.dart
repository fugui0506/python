import 'package:cgwallet/common/common.dart';
import 'package:get/get.dart';

import 'index.dart';

class WalletMangerController extends GetxController with GetTickerProviderStateMixin {
  final state = WalletMangerState();
  // late final SlidableController slidableController;

  @override
  void onInit() {
    super.onInit();
    // slidableController = SlidableController(this);
    if (UserController.to.bankList.value.list.isNotEmpty) {
      state.isLoading = false;
    }
  }

  @override
  void onReady() async {
    super.onReady();
    await Future.delayed(MyConfig.app.timePageTransition);
    if (UserController.to.bankList.value.list.isEmpty) {
      await UserController.to.updateBankList();
      state.isLoading = false;
    }
  }

  void onIndex(int index) {
    state.index = index;
    // slidableController.close();
  }

  void onSetDefault(BankInfoModel data) {
    MyAlert.dialog(
      title: Lang.walletManagerViewSetDefaultAlertTitle.tr,
      content: Lang.walletManagerViewSetDefaultAlertContent.tr,
      onConfirm: () => setDefault(data),
    );
  }

  void onDeleteAccount(BankInfoModel data) {
    MyAlert.dialog(
      title: Lang.walletManagerViewDeleteAlertTitle.tr,
      content: Lang.walletManagerViewDeleteAlertContent.tr,
      onConfirm: () => deleteAccount(data),
    );
  }

  void onAllready() {
    MyAlert.snackbar(Lang.walletManagerViewDefaultAlready.tr);
  }

  Future<void> refreshData(String message) async {
    await UserController.to.updateBankList();
    MyAlert.snackbar(message);
  }

  void setDefault(BankInfoModel data) async {
    showLoading();
    await UserController.to.dio?.post(ApiPath.category.setDefault,
      data: {
        'id': data.id,
        'payCategoryId': data.payCategoryId,
        'isDefault': 1,
      },
      onSuccess: (code, msg, data) async {
        await refreshData(msg);
      },
    );
    hideLoading();
  }

  void deleteAccount(BankInfoModel data) async {
    showLoading();
    await UserController.to.dio?.post(ApiPath.category.deleteBank,
      data: {
        'id': data.id,
        'payCategoryId': data.payCategoryId,
      },
      onSuccess: (code, msg, data) async {
        await refreshData(msg);
      },
    );
    hideLoading();
  }

  void onAdd() {
    final arguments = UserController.to.categoryList.value.list[state.index];
    Get.toNamed(MyRoutes.walletAddView, arguments: arguments);
  }
}
