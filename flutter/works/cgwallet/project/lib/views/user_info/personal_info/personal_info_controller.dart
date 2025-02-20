import 'dart:convert';

import 'package:cgwallet/common/common.dart';
import 'package:get/get.dart';
import 'index.dart';

class PersonalInfoController extends GetxController {
  final state = PersonalInfoState();

  @override
  void onReady() async {
    super.onReady();
    await Future.delayed(MyConfig.app.timePageTransition);
    updateAvatarData();
  }

  @override
  void onClose() {
    state.avatarList.value.stopUpdate();
    super.onClose();
  }

  void onLogout() async {
    await UserController.to.logout();
  }

  void goEditNicknameView() {
    Get.toNamed(MyRoutes.editNickNameView);
  }

  Future<void> updateAvatarData() async {
    await state.avatarList.value.update();
    state.avatarList.refresh();
  }

  Future<void> onPickAvatar() async {
    Get.back();
    showBlock();
    final avatarFile = await MyGallery.to.pickImage();
    if (avatarFile != null) {
      final avatarBytes = await avatarFile.readAsBytes();
      hideBlock();
      final image = await MyAlert.showAvatar(avatarBytes);
      if (image != null) {
        showLoading();
        final avatarBase64 = base64Encode(avatarBytes);
        await editAvatar(avatarBase64:avatarBase64);
        hideLoading();
      }
    } else {
      hideBlock();
    }
  }

  Future<void> onSaveAvatar() async {
    Get.back();
    showLoading();
    await editAvatar(id: state.avatarList.value.list[state.avatarIndex].id);
    hideLoading();
  }

  Future<void> editAvatar({String? avatarBase64, int? id}) async {
    await UserController.to.dio?.post(ApiPath.base.editAvatar,
      onSuccess: (code, msg, results) async {
        UserController.to.userInfo.update((val) {
          val!.user.avatarUrl = results as String;
        });
      },
      data: {
        if (avatarBase64 != null) "pic_base64": avatarBase64,
        if (id != null) "id": id,
      },
    );
  }
}
