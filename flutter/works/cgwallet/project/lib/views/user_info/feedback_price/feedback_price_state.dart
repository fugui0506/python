import 'package:cgwallet/common/common.dart';
import 'package:get/get.dart';

class FeedbackPriceState {
  FeedbackPriceState() {
    ///Initialize variables
  }

  final title = Lang.feedbackPriceViewTitle.tr;

  final filePaths = ['', '', ''].obs;
  // final fileNames = [];

  final _isButtonDisable = true.obs;
  set isButtonDisable(bool value) => _isButtonDisable.value = value;
  bool get isButtonDisable => _isButtonDisable.value;

  final feedbackRemark = FeedbackRemarkModel().obs;
}
