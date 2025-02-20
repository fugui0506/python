import 'package:cgwallet/common/common.dart';
import 'package:get/get.dart';

class PromotionListState {
  final title = Lang.promotionListViewTitle.tr;
  final promotionList = PromotionListModel.empty().obs;

  final _isLoading = true.obs;
  bool get isLoading => _isLoading.value;
  set isLoading(bool value) => _isLoading.value = value;

  final _isNodata = false.obs;
  bool get isNodata => _isNodata.value;
  set isNodata(bool value) => _isNodata.value = value;
}
