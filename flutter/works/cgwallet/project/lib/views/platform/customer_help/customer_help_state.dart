import 'package:cgwallet/common/common.dart';
import 'package:get/get.dart';

class CustomerHelpState {
  final title = Lang.customerHelpViewTitle.tr;

  final customerHelpData = CustomerHelpModel.empty();

  final chatItems = [].obs;

  final _isLoading = true.obs;
  bool get isLoading => _isLoading.value;
  set isLoading(bool value) => _isLoading.value = value;

  final _isNoData = false.obs;
  bool get isNoData => _isNoData.value;
  set isNoData(bool value) => _isNoData.value = value;
}
