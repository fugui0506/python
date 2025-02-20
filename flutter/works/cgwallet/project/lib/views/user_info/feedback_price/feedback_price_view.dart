import 'dart:io';

import 'package:cgwallet/common/common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:get/get.dart';

import 'index.dart';

class FeedbackPriceView extends GetView<FeedbackPriceController> {
  const FeedbackPriceView({super.key});

  @override
  Widget build(BuildContext context) {
    /// appbar
    var appBar = MyAppBar.normal(
      title: controller.state.title,
    );

    /// 页面构成
    return KeyboardDismissOnTap(child: Scaffold(
      appBar: appBar,
      backgroundColor: Theme.of(context).myColors.background,
      body: _buildBody(context),
    ));
  }

  Widget _buildBody(BuildContext context) {
    final content = Column( children: [
      Expanded(child: SingleChildScrollView(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const SizedBox(height: 10),
        Text(Lang.feedbackPriceViewInputTitle.tr, style: Theme.of(context).myStyles.labelBig),
        const SizedBox(height: 10, width: double.infinity),
        MyInput(
          controller: controller.textController,
          focusNode: controller.focusNode,
          hintText: Lang.feedbackPriceViewInputHintText.tr,
          color: Theme.of(context).myColors.cardBackground,
          padding: const EdgeInsets.all(16),
          maxLength: 200,
          minLines: 3,
          maxLines: 5,
        ),
        const SizedBox(height: 10, width: double.infinity),
        Text(Lang.feedbackPriceViewUpdateTitle.tr, style: Theme.of(context).myStyles.labelBig),
        const SizedBox(height: 10, width: double.infinity),

        Obx(() {
          return Row(children: controller.state.filePaths.asMap().entries.map((e) {
            final isHavaImage = false.obs;
            if (e.value.isNotEmpty) {
              isHavaImage.value = true;
            }

            Widget background = isHavaImage.value
              ? Image.file(File(e.value), fit: BoxFit.fill, width: double.infinity,)
              : const SizedBox();

            Widget clear = MyButton.widget(
              onPressed: () => controller.cleanImage(e.key),
              child: Center(child: MyCard.avatar(
                radius: 20, color: Theme.of(context).myColors.light,
                child: Padding(padding: const EdgeInsets.all(10), child: Theme.of(context).myIcons.close))
              ),
            );

            Widget add = MyButton.widget(
              onPressed: () => controller.getImage(e.key),
              child: MyCard(width: double.infinity, height: double.infinity, child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                Opacity(opacity: 0.4, child: Theme.of(context).myIcons.add),
                const SizedBox(height: 8),
                Text('上传附件', style: Theme.of(context).myStyles.labelSmall),
              ])),
            );

            Widget button = isHavaImage.value ? clear : add;

            return MyCard(
              margin: e.key == 1 ? const EdgeInsets.fromLTRB(8, 0, 8, 0) : null,
              border: Border.all(color: Theme.of(context).myColors.inputBorder.withOpacity( 0.6), width: 1),
              borderRadius: BorderRadius.circular(10),
              width: (Get.width - 32 - 16) / 3,
              height: (Get.width - 32 - 16) / 3,
              color: Theme.of(context).myColors.itemCardBackground,
              child: ClipRRect(borderRadius: BorderRadius.circular(10),child: Stack(children: [background, button]),),
            );
          }).toList());
        }),
        const SizedBox(height: 32),
        Obx(() => MyButton.filedLong(onPressed: controller.state.isButtonDisable ? null : controller.commit, text: Lang.feedbackPriceViewConfirm.tr)),
        const SizedBox(height: 32),
        Obx(() => controller.state.feedbackRemark.value.remark == null ? const SizedBox() : MyCard.normal(
          padding: const EdgeInsets.all(16),
          color: Theme.of(context).myColors.buttonDisable.withOpacity( 0.2),
          child: Column(children: [
            Row(children: [
              Theme.of(context).myIcons.feedbackRemark,
              const SizedBox(width: 8),
              Text('提示说明', style: Theme.of(context).myStyles.labelPrimaryBig)
            ],),
            MyHtml(data: '${controller.state.feedbackRemark.value.remark}')
          ],),
        ))
      ]))),
    ]);
    return MyCard(
      // padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: content,
    );
  }
}
