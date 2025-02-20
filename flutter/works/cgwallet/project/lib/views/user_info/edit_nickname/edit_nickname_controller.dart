import 'package:cgwallet/common/common.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import 'index.dart';

class EditNicknameController extends GetxController {
  final state = EditNicknameState();
  final nicknameController = TextEditingController();
  final nicknameFocusNode = FocusNode();

  @override
  void onReady() async {
    super.onReady();
    await Future.delayed(MyConfig.app.timePageTransition);
    nicknameController.addListener(listener);
  }

  @override
  void onClose() {
    nicknameController.removeListener(listener);
    super.onClose();
  }

  void onEditNickname() async {
    Get.focusScope?.unfocus();
    state.isButtonDisable = true;
    await editNickname();
  }

  void listener() {
    if (nicknameController.text.isEmpty) {
      state.isButtonDisable = true;
    } else {
      state.isButtonDisable = false;
    }
  }

  Future<void> editNickname() async {
    showLoading();
    await UserController.to.dio?.post(ApiPath.base.editNickname,
      onSuccess: (code, msg, data) async {
        await UserController.to.updateUserInfo();
        Get.back();
        MyAlert.snackbar(msg);
      },
      data: {
        "nickname": nicknameController.text,
      },
      onError: () {
        state.isButtonDisable = false;
      }
    );
    hideLoading();
  }
}
