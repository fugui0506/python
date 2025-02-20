import 'package:cgwallet/common/common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:get/get.dart';

import 'index.dart';

class EditNicknameView extends GetView<EditNicknameController> {
  const EditNicknameView({super.key});

  @override
  Widget build(BuildContext context) {
    /// appbar
    var appBar = MyAppBar.normal(title: controller.state.title);

    /// 页面构成
    return KeyboardDismissOnTap(child: Scaffold(
      appBar: appBar, 
      backgroundColor: Theme.of(context).myColors.background,
      body: _buildBody(context),
    ));
  }

  Widget _buildBody(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: _buildContent(context),
    );
  }

  Widget _buildContent(BuildContext context) {
    return Column(
      children: [
        _buildInput(context),
        const SizedBox(height: 20),
        _buildConfirmButton(context),
      ],
    );
  }

  Widget _buildInput(BuildContext context) {
    return MyInput.normal(controller.nicknameController, controller.nicknameFocusNode,
      hintText: Lang.editNicknameViewHintText.tr,
    );
  }

  Widget _buildConfirmButton(BuildContext context) {
    return Obx(() => MyButton.filedLong(
        text: Lang.editNicknameViewConfirm.tr,
        onPressed: controller.state.isButtonDisable ? null : controller.onEditNickname,
      )
    );
  }
}
