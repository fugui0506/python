import 'package:cgwallet/common/common.dart';
import 'package:cgwallet/views/views.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class TransferController extends GetxController {
  final state = TransferState();

  final addressController = TextEditingController();
  final addressFocusNode = FocusNode();

  @override
  void onReady() async {
    super.onReady();
    await Future.delayed(MyConfig.app.timePageTransition);
    await updateOrderTransfer();
    state.isLoading = false;
    addressController.addListener(listener);
  }

  @override
  void onClose() {
    addressController.removeListener(listener);
    super.onClose();
  }

  Future updateOrderTransfer() async {
    final data = ResponseTransferHistory(page: 1, pageSize: 3, dateType: 3).toJson();
    await state.orderTransferList.value.onRefresh(data);
    state.orderTransferList.refresh();
  }

  void goTransferHistoryView() {
    Get.focusScope?.unfocus();
    Get.toNamed(MyRoutes.transferHistoryView);
  }

  void goTransferCoinView() async {
    Get.focusScope?.unfocus();
    await Get.toNamed(MyRoutes.transferCoinView, arguments: addressController.text);
    updateOrderTransfer();
  }

  void listener() {
    if (addressController.text.isNotEmpty) {
      state.isButtonDisable = false;
    } else {
      state.isButtonDisable = true;
    }
  }

  void goScanView() {
    Get.toNamed(MyRoutes.scanView);
  }
}
