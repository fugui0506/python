import 'package:cgwallet/common/common.dart';
import 'package:get/get.dart';

class TransferState {
  final title = Lang.transferViewTitle.tr;

  final orderTransferList = OrderTransferListModel.empty().obs;

  final _isButtonDisable = true.obs;
  bool get isButtonDisable => _isButtonDisable.value;
  set isButtonDisable(value) => _isButtonDisable.value = value;

  final _isLoading = true.obs;
  bool get isLoading => _isLoading.value;
  set isLoading(bool value) => _isLoading.value = value;
}
