import 'package:cgwallet/common/common.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:get/get_utils/get_utils.dart';
import 'package:get/route_manager.dart';

import 'feedback_price_state.dart';

class FeedbackPriceController extends GetxController {
  final FeedbackPriceState state = FeedbackPriceState();

  final textController = TextEditingController();
  final focusNode = FocusNode();

  @override
  void onReady() async {
    super.onReady();
    await Future.delayed(MyConfig.app.timePageTransition);
    await state.feedbackRemark.value.update();
    state.feedbackRemark.refresh();
    textController.addListener(listener);
  }

  void listener() {
    if (textController.text.isEmpty) {
      state.isButtonDisable = true;
    } else {
      state.isButtonDisable = false;
    }
  }

  @override
  void onClose() {
    textController.removeListener(listener);
    super.onClose();
  }

  void getImage(int index) async {
    final imageFile = await MyGallery.to.pickImage();
    if (imageFile!= null) {
      final sizeB = await imageFile.length();
      final sizeM = sizeB / 1024 / 1024;
      if (sizeM > 3) {
        MyAlert.snackbar('单个文件大小不能超过3M');
      } else {
        state.filePaths[index] = imageFile.path;
        state.filePaths.refresh();
      }
    }
  }

  void cleanImage(int index) {
    state.filePaths[index] = '';
    // state.fileName = "";
  }

  void commit() async {
    state.isButtonDisable = true;
    Get.focusScope?.unfocus();

    if (textController.text.length < 10) {
      await MyAlert.dialog(
        content: Lang.feedbackPriceViewTextLengthShort.tr,
        showCancelButton: false,
      );
      state.isButtonDisable = false;
    } else {
      showLoading();
      if (state.filePaths.isNotEmpty) {
        await uploading();
      } else {
        await feedback();
      }
    }
  }

  Future<void> uploading() async {
    // final multipartFile = await MultipartFile.fromFile(
    //   state.filePath,
    //   filename: state.fileName,
    //   // contentType: MediaType.parse('application/octet-stream'),
    // );

    final paths = state.filePaths.where((e) => e.isNotEmpty).toList();

    final multipartFiles = await Future.wait(
      paths.map((filePath) async {
        return MultipartFile.fromFile(
          filePath,
          filename: filePath.split('/').last,
        );
      }),
    );

    await UserController.to.dio?.upload(ApiPath.me.uploadFeedbackAttachment,
      onSuccess: (code, msg, data) async {
        final url = data as String;
        await feedback(attachment: url);
      },
      onError: () {
        state.isButtonDisable = false;
      },
      data: {
        "file": multipartFiles
      }
    );
    hideLoading();
  }

  Future<void> feedback({String? attachment}) async {
    await UserController.to.dio?.post(ApiPath.me.feedback,
      onSuccess: (code, msg, data) async {
        await MyAlert.show(
          margin: 32,
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            const SizedBox(height: 16),
            Get.theme.myIcons.success,
            const SizedBox(height: 16),
            Text(Lang.feedbackPriceViewAlertSuccessTitle.tr, style: Get.theme.myStyles.labelGreenBigger),
            const SizedBox(height: 4),
            Text(Lang.feedbackPriceViewAlertSuccessContent.tr, style: Get.theme.myStyles.label),
            const SizedBox(height: 32),
            MyButton.filedLong(onPressed: () {
              Get.back();
            }, text: Lang.confirm.tr),
            // const SizedBox(height: 16),
          ]),
        );
        Get.back();
      },
      onError: () {
        state.isButtonDisable = false;
      },
      data: {
        "content": textController.text,
        "attachment": attachment,
      }
    );
    hideLoading();
  }
}
