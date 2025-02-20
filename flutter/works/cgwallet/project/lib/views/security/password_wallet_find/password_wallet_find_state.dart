import 'package:cgwallet/common/common.dart';
import 'package:get/get.dart';

class PasswordWalletFindState {
  final title = Lang.walletPasswordFindPassword.tr;

  final _isButtonDisable = true.obs;
  bool get isButtonDisable => _isButtonDisable.value;
  set isButtonDisable(bool value) => _isButtonDisable.value = value;

  final loading = true.obs;
  final codeTimer = 0.obs;
}
