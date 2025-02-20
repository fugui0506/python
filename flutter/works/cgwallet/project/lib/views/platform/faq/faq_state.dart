import 'package:cgwallet/common/common.dart';
import 'package:get/get.dart';

class FAQState {
  final title = Lang.faqTitle.tr;
  final faqList = FaqListModel.empty().obs;

  final _isLoading = true.obs;
  bool get isLoading => _isLoading.value;
  set isLoading(bool value) => _isLoading.value = value;
}
