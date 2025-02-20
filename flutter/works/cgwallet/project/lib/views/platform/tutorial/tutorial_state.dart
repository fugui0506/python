import 'package:cgwallet/common/common.dart';
import 'package:get/get.dart';

class TutorialState {
  final title = Lang.mineViewTutorialTitle.tr;
  final tutorialList = TutorialListModel.empty().obs;

  final _isLoading = true.obs;
  bool get isLoading => _isLoading.value;
  set isLoading(bool value) => _isLoading.value = value;
}
