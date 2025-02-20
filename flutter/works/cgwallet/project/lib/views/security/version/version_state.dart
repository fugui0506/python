import 'package:cgwallet/common/common.dart';
import 'package:get/get.dart';

class VersionState {
  final title = Lang.versionViewTitle.tr;

  final _isButtonDisable = false.obs;
  bool get isButtonDisable => _isButtonDisable.value;
  set isButtonDisable(bool value) => _isButtonDisable.value = value;
}
