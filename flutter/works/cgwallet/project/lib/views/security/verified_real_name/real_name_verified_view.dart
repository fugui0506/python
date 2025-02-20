import 'dart:typed_data';

import 'package:cgwallet/common/common.dart';
import 'package:cgwallet/views/views.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:get/get.dart';

class RealNameVerifiedView extends GetView<RealNameVerifiedController> {
  const RealNameVerifiedView({super.key});

  @override
  Widget build(BuildContext context) {
    /// appbar
    var appBar = MyAppBar.normal(
      title: controller.state.title,
      actions: [customerButton()],
    );

    /// 页面构成
    return KeyboardDismissOnTap(child: Scaffold(
      appBar: appBar,
      backgroundColor: Theme.of(context).myColors.background,
      body: _buildBody(context),
    ));
  }

  Widget _buildBody(BuildContext context) {
    return PageView(
      controller: controller.pageController,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        _buildStepOne(context),
        _buildStepTwo(context),
      ]
    );
  }

  Widget _buildStepOne(BuildContext context) {
    return SingleChildScrollView(padding: const EdgeInsets.all(16), child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _buildInput(context, Lang.realNameViewName.tr, Lang.realNameViewNameHintText.tr, controller.nameController, controller.nameFocusNode),
        const SizedBox(height: 8),
        _buildInput(context, Lang.realNameViewID.tr, Lang.realNameViewIDHintText.tr, controller.idController, controller.idFocusNode),
        const SizedBox(height: 20),
        Obx(() => MyButton.filedLong(onPressed: controller.state.isDisableButtonNext ? null : controller.onNext, text: Lang.realNameViewNext.tr)),
        const SizedBox(height: 40),
        MyCard.normal(
          color: Theme.of(context).myColors.itemCardBackground,
          padding: const EdgeInsets.all(16),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(Lang.realNameViewNoticeTitle.tr, style: Theme.of(context).myStyles.labelBig),
            const SizedBox(height: 10),
            Text(Lang.realNameViewNoticeContent.tr, style: Theme.of(context).myStyles.contentSmall),
          ]),
        ),
      ]
    ));
  }

  Widget _buildStepTwo(BuildContext context) {
    
    final content = SingleChildScrollView(padding: const EdgeInsets.all(16), child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(Lang.realNameViewNoticeIDFrontTitle.tr, style: Theme.of(context).myStyles.labelBigger),
        const SizedBox(height: 8, width: double.infinity),
        _buildCard(context, true),
        const SizedBox(height: 4),
        Text(Lang.realNameViewNoticeIDFrontContent.tr, style: Theme.of(context).myStyles.labelSmall),

        const SizedBox(height: 20),

        Text(Lang.realNameViewNoticeIDFrontTitle.tr, style: Theme.of(context).myStyles.labelBigger),
        const SizedBox(height: 8),
        _buildCard(context, false),
        const SizedBox(height: 4),
        Text(Lang.realNameViewNoticeIDFrontContent.tr, style: Theme.of(context).myStyles.labelSmall),

      ]
    ));

    final button = Obx(() => MyButton.filedLong(onPressed: controller.state.isDisableButtonConfirm ? null : controller.onUploadIdCardPic, text: Lang.realNameViewConfirmID.tr));

    return SafeArea(child: Column(children: [
      Expanded(child: content),
      Padding(padding: const EdgeInsets.fromLTRB(16, 10, 16, 0), child: button),
    ]));
  }

  Widget _buildCard(BuildContext context, bool isFront) {
    final front = Obx(() => controller.state.idFront.isEmpty
      ? Theme.of(context).myIcons.idFront
      : Image.memory(Uint8List.fromList(controller.state.idFront), width: double.infinity, fit: BoxFit.cover)
    );

    final back = Obx(() => controller.state.idback.isEmpty
      ? Theme.of(context).myIcons.idBack
      : Image.memory(Uint8List.fromList(controller.state.idback), width: double.infinity, fit: BoxFit.cover)
    );

    final iconCamera = MyCard.avatar(
      radius: 40, 
      color: Theme.of(context).myColors.dark.withOpacity( 0.5), 
      child: Center(child: Obx(() => controller.state.idFront.isEmpty 
        ? Theme.of(context).myIcons.camera 
        : Text(Lang.realNameViewUploadAgain.tr, style: Theme.of(context).myStyles.onButton))
      ),
    );

    final card = MyCard.normal(
      color: Theme.of(context).myColors.cardBackground,
      padding: const EdgeInsets.all(16),
      child: SizedBox(
        width: double.infinity,
        height: 220,
        child: Stack(alignment: Alignment.center, children: [isFront ? front : back, iconCamera]),
      ),
    );

    return MyButton.widget(onPressed: () => controller.onPickImage(isFront), child: card);
  }

  Widget _buildInput(
    BuildContext context, 
    String label, 
    String hintText,
    TextEditingController textEditingController, 
    FocusNode focusNode,
  ) {
    final prefixIcon = Padding(padding: const EdgeInsets.only(left: 16, right: 16), child: Column(
      mainAxisAlignment: MainAxisAlignment.center, 
      children: [Text(label, style: Theme.of(context).myStyles.label)]
    ));
    return MyInput.normal(
      textEditingController, focusNode,
      color: Theme.of(context).myColors.cardBackground,
      // borderRadius: BorderRadius.circular(10),
      hintText: hintText,
      // textAlign: TextAlign.end,
      // border: OutlineInputBorder(borderSide: BorderSide.none, borderRadius: BorderRadius.circular(10)),
      // padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
      prefixIcon: prefixIcon,
    );
  }
}
