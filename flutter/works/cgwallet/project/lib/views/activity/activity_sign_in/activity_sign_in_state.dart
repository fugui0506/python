import 'package:cgwallet/common/common.dart';
import 'package:get/get.dart';

class ActivitySignInState {
  final title = Lang.activitySignInViewTitle.tr;
  final activityData = ActivitySignInModel.empty().obs;

  final _isLoading = true.obs;
  bool get isLoading => _isLoading.value;
  set isLoading(value) => _isLoading.value = value;
}
