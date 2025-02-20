import 'package:cgwallet/common/common.dart';
import 'package:get/get.dart';



class LoginState {
  final captchForCode = CaptchaModel.empty().obs;
  final captchForPassword = CaptchaModel.empty().obs;
  final captchForRegister = CaptchaModel.empty().obs;

  final signState = SignState.loginForPassword.obs;

  final _isRemenberPassword = false.obs;
  bool get isRemenberPassword => _isRemenberPassword.value;
  set isRemenberPassword(bool value) => _isRemenberPassword.value = value;

  final _isLoading = false.obs;
  bool get isLoading => _isLoading.value;
  set isLoading(bool value) => _isLoading.value = value;

  final _isButtonDisable = true.obs;
  bool get isButtonDisable => _isButtonDisable.value;
  set isButtonDisable(bool value) => _isButtonDisable.value = value;

  String validate = '';
}

enum SignState {
  loginForPassword,
  loginForCode,
  register,
  forgotPassword,
}
