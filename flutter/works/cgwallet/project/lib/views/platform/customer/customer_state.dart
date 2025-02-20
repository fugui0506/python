import 'package:cgwallet/common/common.dart';
import 'package:cgwallet/common/models/chat_faq_info_model.dart';
import 'package:get/get.dart';

class CustomerState {
  final title = UserController.to.userInfo.value.token.isEmpty ? '游客客服' : Lang.customerViewTitle.tr;
  // final customerData = CustomerModel.empty().obs;

  final _isLoading = true.obs;
  bool get isLoading => _isLoading.value;
  set isLoading(bool value) => _isLoading.value = value;

  final _isNodata = false.obs;
  bool get isNodata => _isNodata.value;
  set isNodata(bool value) => _isNodata.value = value;

  final chatFaqTypeList = ChatFaqTypeListModel.empty().obs;
}
