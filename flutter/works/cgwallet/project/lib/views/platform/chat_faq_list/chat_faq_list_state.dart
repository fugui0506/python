// import 'package:cgwallet/common/common.dart';
import 'package:cgwallet/common/models/chat_faq_info_model.dart';
import 'package:get/get.dart';

class ChatFaqListState {
  final chatFaqList = ChatFaqListModel.empty().obs;
  final ChatFaqTypeModel chatFaqType = Get.arguments;

  final _isLoading = true.obs;
  bool get isLoading => _isLoading.value;
  set isLoading(bool value) => _isLoading.value = value;

  final _isNoData = false.obs;
  bool get isNoData => _isNoData.value;
  set isNoData(bool value) => _isNoData.value = value;
}
