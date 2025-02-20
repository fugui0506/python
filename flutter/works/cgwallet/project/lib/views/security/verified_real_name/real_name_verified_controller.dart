import 'dart:convert';

import 'package:cgwallet/common/common.dart';
import 'package:cgwallet/views/views.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class RealNameVerifiedController extends GetxController {
  final state = RealNameVerifiedState();

  final nameController = TextEditingController();
  final nameFocusNode = FocusNode();

  final idController = TextEditingController();
  final idFocusNode = FocusNode();

  final pageController = PageController();


  @override
  void onReady() async {
    super.onReady();
    await Future.delayed(MyConfig.app.timePageTransition);
    nameController.addListener(inputLinstener);
    idController.addListener(inputLinstener);
  }

  @override
  void onClose() {
    nameController.removeListener(inputLinstener);
    idController.removeListener(inputLinstener);
    super.onClose();
  }

  void onNext() {
    Get.focusScope?.unfocus();
    state.isDisableButtonNext = true;
    pageController.nextPage(duration: MyConfig.app.timePageTransition, curve: Curves.linear);

  }

  void inputLinstener(){
    if (nameController.text.isNotEmpty && idController.text.isNotEmpty) {
      state.isDisableButtonNext = false;
    } else {
      state.isDisableButtonNext = true;
    }
  }

  void idLinstener(){
    if (state.idFront.isNotEmpty && state.idback.isNotEmpty) {
      state.isDisableButtonConfirm= false;
    } else {
      state.isDisableButtonConfirm = true;
    }
  }

  void onPickImage(bool isFront) async {
    Get.focusScope?.unfocus();
    final image = await MyGallery.to.pickImage();
    if (image != null) {
      final iamgeBytes = await image.readAsBytes();
      if (isFront) {
        state.idFront.value = iamgeBytes;
      } else {
        state.idback.value = iamgeBytes;
      }
    }
    idLinstener();
  }

  Future<void> onUploadIdCardPic() async {
    Get.focusScope?.unfocus();
    state.isDisableButtonConfirm = true;
    showLoading();
    await UserController.to.dio?.post(ApiPath.auth.uploadIdCardPic,
      onSuccess: (code, msg, results) async {
        await confirmInfo();
      }, 
      onError: () async {
        state.isDisableButtonConfirm = false;
      }, 
      data:  {
        "frontPicBase64": base64Encode(state.idFront),
        "backPicBase64": base64Encode(state.idback),
      }
    );
    hideLoading();
  }

  Future<void> confirmInfo() async{
    await UserController.to.dio?.post(ApiPath.auth.confirmInfo,
      onSuccess: (code, msg, results) async {
        final token = await Get.toNamed(MyRoutes.faceVerifiedView);
        if (token != null) {
          await UserController.to.updateUserInfo();
          await realNameVerify(token, onError: () {
            Get.back();
            state.isDisableButtonConfirm = false;
          }, onSuccess: () {
            Get.back();
            MyAlert.snackbar(msg);
          });
        } else {
          state.isDisableButtonConfirm = false;
        }
      }, 
      onError: () async {
        state.isDisableButtonConfirm = false;
      }, 
      data:  {
        "realName": nameController.text,
        "idCardNo": idController.text,
      }
    );
  }
}
