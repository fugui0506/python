import 'package:cgwallet/common/common.dart';
import 'package:get/get.dart';

class NotifyState {
  final index = 1.obs;

  final _isLoading = true.obs;
  bool get isLoading => _isLoading.value;
  set isLoading(bool value) => _isLoading.value = value;

  final notifyList = NotifyListModel.empty().obs;

  final int type = Get.arguments;
}
