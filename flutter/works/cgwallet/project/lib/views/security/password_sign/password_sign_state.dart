import 'package:cgwallet/common/common.dart';
import 'package:get/get.dart';

class PasswordSignState {
  final title = Lang.passwordSignViewTitle.tr;

  final _isButtonDisable = true.obs;
  bool get isButtonDisable => _isButtonDisable.value;
  set isButtonDisable(bool value) => _isButtonDisable.value = value;
}
