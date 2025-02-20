import 'package:cgwallet/common/common.dart';
import 'package:get/get.dart';

class EditNicknameState {
  final title = Lang.editNicknameViewTitle.tr;

  final _isButtonDisable = true.obs;
  set isButtonDisable(bool value) => _isButtonDisable.value = value;
  bool get isButtonDisable => _isButtonDisable.value;
}
