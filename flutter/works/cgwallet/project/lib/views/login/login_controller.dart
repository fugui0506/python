import 'dart:convert';

import 'package:cgwallet/common/common.dart';
import 'package:cgwallet/views/views.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

class LoginController extends GetxController {
  final state = LoginState();
  final scrollController = ScrollController();

  final accountTextController = TextEditingController();
  final accountFocusNode = FocusNode();

  final passwordTextController = TextEditingController();
  final passwordFocusNode = FocusNode();

  final rePasswordTextController = TextEditingController();
  final rePasswordFocusNode = FocusNode();

  final caputcharTextController = TextEditingController();
  final caputcharFocusNode = FocusNode();

  final phoneTextController = TextEditingController();
  final phoneFocusNode = FocusNode();

  final phoneCodeTextController = TextEditingController();
  final phoneCodeFocusNode = FocusNode();


  @override
  void onReady() async {
    super.onReady();
    await Future.delayed(MyConfig.app.timePageTransition);
    checkAndUpdateCustomerData();
  }

  @override
  void onInit() {
    super.onInit();
    setRemberAccount();
    textEditingControllerAddLinster();
  }

  @override
  void onClose() {
    textEditingControllerDispose();
    super.onClose();
  }

  Future<void> setRemberAccount() async {
    final isRememberPassword = await MyShared.to.get(MyConfig.shard.accountKey);
    if (isRememberPassword.isNotEmpty) {
      state.isRemenberPassword = true;
      accountTextController.text = await MyShared.to.get(MyConfig.shard.accountKey);
    }
  }

  void goLogin() {
    state.signState.value = SignState.loginForPassword;
    reset();
  }

  void goRegister() {
    state.signState.value = SignState.register;
    reset();
  }

  void goLoginForCode() {
    state.signState.value = SignState.loginForCode;
    reset();
  }

  void goLoginForPasswrod() {
    state.signState.value = SignState.loginForPassword;
    reset();
  }

  void goForgotPassword() {
    state.signState.value = SignState.forgotPassword;
    reset();
  }

  void onLoding(String value) {
    state.isButtonDisable = true;
    state.isLoading = true;
    showBlock();
    state.validate = value;
  }

  void check(void Function() future) {
    Get.focusScope?.unfocus();
    state.isButtonDisable = true;
    showCaptcha(
      onSuccess: (value) async {
        if (value.isNotEmpty) {
          onLoding(value);
          future.call();
        }
      },
      onError: () {
        state.isButtonDisable = false;
      },
      onClose: () {
        state.isButtonDisable = false;
      },
    );
  }

  void onLoginForPassword() {
    check(loginForPassword);
  }

  void onRegister() {
    check(register);
  }

  void onForgotPassword() {
    check(forgotPassword);
  }

  void onLoginForPhoneCode() {
    check(loginForPhoneCode);
  }

  void onRemenberAccount() {
    state.isRemenberPassword = !state.isRemenberPassword;
  }

  void textEditingControllerAddLinster() {
    accountTextController.addListener(linster);
    passwordTextController.addListener(linster);
    rePasswordTextController.addListener(linster);
    caputcharTextController.addListener(linster);
    phoneTextController.addListener(linster);
    phoneCodeTextController.addListener(linster);
  }

  void textEditingControllerDispose() {
    accountTextController.removeListener(linster);
    passwordTextController.removeListener(linster);
    rePasswordTextController.removeListener(linster);
    caputcharTextController.removeListener(linster);
    phoneTextController.removeListener(linster);
    phoneCodeTextController.removeListener(linster);
  }

  void linster() {
    if (state.signState.value == SignState.loginForPassword) {
      if (accountTextController.text.isEmpty || passwordTextController.text.isEmpty) {
        state.isButtonDisable = true;
      } else {
        state.isButtonDisable = false;
      }
    }

    if (state.signState.value == SignState.loginForCode) {
      if (phoneTextController.text.isEmpty || phoneCodeTextController.text.isEmpty) {
        state.isButtonDisable = true;
      } else {
        state.isButtonDisable = false;
      }
    }

    if (state.signState.value == SignState.register) {
      if (accountTextController.text.isEmpty || passwordTextController.text.isEmpty || rePasswordTextController.text.isEmpty || phoneTextController.text.isEmpty || phoneCodeTextController.text.isEmpty) {
        state.isButtonDisable = true;
      } else {
        state.isButtonDisable = false;
      }
    }

    if (state.signState.value == SignState.forgotPassword) {
      if (passwordTextController.text.isEmpty || rePasswordTextController.text.isEmpty || phoneTextController.text.isEmpty || phoneCodeTextController.text.isEmpty) {
        state.isButtonDisable = true;
      } else {
        state.isButtonDisable = false;
      }
    }
  }

  void reset() {
    Get.focusScope?.unfocus();
    if (state.signState.value == SignState.loginForPassword) {
      setRemberAccount();
    } else {
      accountTextController.text = '';
    }
    passwordTextController.text = '';
    rePasswordTextController.text = '';
    caputcharTextController.text = '';
    phoneTextController.text = '';
    phoneCodeTextController.text = '';
    linster();
  }


  Future<void> goFrameView() async {
    Get.offAllNamed(MyRoutes.frameView);
  }

  void verifyFailed() {
    Get.back();
    state.isLoading = false;
    state.isButtonDisable = false;
    UserController.to.clearUserInfo();
  }

  // 设置用户信息：登录成功后
  void setUserInfo(UserInfoModel data) {
    UserController.to.userInfo.value = data;
    UserController.to.userInfo.value.createAt = DateTime.now().millisecondsSinceEpoch;
    UserController.to.userInfo.refresh();
    MyShared.to.set(MyConfig.shard.userInfoKey, jsonEncode(UserController.to.userInfo.value.toJson()));
  }

  Future<void> loginForPassword() async {
    state.isLoading = true;

    await UserController.to.dio?.post<UserInfoModel>(ApiPath.base.accountLogin, 
      onSuccess: (code, msg, data) async {
        setUserInfo(data);

        // 是否保存账号信息
        if (state.isRemenberPassword) {
          MyShared.to.set(MyConfig.shard.accountKey, accountTextController.text);
        } else {
          MyShared.to.delete(MyConfig.shard.accountKey);
        }

        await goFrameView();

      },
      onModel: (json) => UserInfoModel.fromJson(json),
      data: {
        "username": accountTextController.text,
        "password": passwordTextController.text.encrypt(MyConfig.key.aesKey),
        "captcha": caputcharTextController.text,
        "captchaId": state.captchForPassword.value.captchaId,
        'validate': state.validate,
      },
      onError: () {
        state.isLoading = false;
      }
    );
    hideBlock();
  }

  Future<void> register() async {
    state.isLoading = true;

    await UserController.to.dio?.post<UserInfoModel>(ApiPath.base.register, 
      onSuccess: (code, msg, data) async {
        setUserInfo(data);
        await goFrameView();
      },
      onModel: (json) => UserInfoModel.fromJson(json),
      data: {
        'username': accountTextController.text,
        'phone': phoneTextController.text,
        'password': passwordTextController.text.encrypt(MyConfig.key.aesKey),
        'rePassword': rePasswordTextController.text.encrypt(MyConfig.key.aesKey),
        'verificationCode': phoneCodeTextController.text,
        'captcha': caputcharTextController.text,
        'captchaId': state.captchForPassword.value.captchaId,
      },
      onError: () {
        state.isLoading = false;
      }
    );

    hideBlock();
  }

  Future<void> forgotPassword() async {
    state.isLoading = true;

    await UserController.to.dio?.post(ApiPath.base.forgetPassword, 
      onSuccess: (code, msg, data) async {
        goLogin();
        MyAlert.snackbar(msg);
      },
      data: {
        "phone": phoneTextController.text,
        "newPassword": passwordTextController.text.encrypt(MyConfig.key.aesKey),
        "reNewPassword": rePasswordTextController.text.encrypt(MyConfig.key.aesKey),
        "verificationCode": phoneCodeTextController.text,
      },
      onError: () {
        state.isLoading = false;
      }
    );

    hideBlock();
  }

  Future<void> loginForPhoneCode() async {
    state.isLoading = true;

    await UserController.to.dio?.post<UserInfoModel>(ApiPath.base.phoneLogin, 
      onSuccess: (code, msg, data) async {
        setUserInfo(data);
        await goFrameView();
      },
      onModel: (json) => UserInfoModel.fromJson(json),
      data: {
        "phone": phoneTextController.text,
        "verificationCode": phoneCodeTextController.text,
        "captcha": caputcharTextController.text,
        "captchaId": state.captchForPassword.value.captchaId,
        'validate': state.validate,
      },
      onError: () {
        state.isLoading = false;
      }
    );

    hideBlock();
  }

  void goSettingsView() {
    Get.toNamed(MyRoutes.settingsView);
  }
}
