import 'package:cgwallet/common/common.dart';
import 'package:get/get.dart';

class QrcodeState {
  final title = Lang.qrcodeViewTitle.tr;

  final _isButtonDisable = false.obs;
  set isButtonDisable(bool value) => _isButtonDisable.value = value;
  bool get isButtonDisable => _isButtonDisable.value;
}
