import 'package:cgwallet/common/common.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'index.dart';

class IndexView extends GetView<IndexController> {
  const IndexView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar.transparent(),
      extendBody: true,
      extendBodyBehindAppBar: true,
      backgroundColor: Theme.of(context).myColors.background,
      body: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    final page = PageView(
      onPageChanged: (index) => controller.state.pageIndex = index,
      children: [
        Theme.of(context).myIcons.welcome1,
        Stack(alignment: Alignment.center, children: [
          SizedBox(width: double.infinity, height: double.infinity, child: Theme.of(context).myIcons.welcome2),
          Positioned(
            bottom: 32,
            child: SafeArea(
              child: SizedBox(width: Get.width * 0.5, child: MyButton.filedLong(onPressed: controller.goLoginView, text: Lang.tryItNow.tr))
            ),
          ),
        ]),
      ],
    );

    return Stack(alignment: Alignment.center, children: [
      page,
      Positioned(
        bottom: 10,
        child: SafeArea(
          child: Row(children: [
            Obx(() => MyCard.avatar(radius: 3, color: controller.state.pageIndex == 0 ? Theme.of(context).myColors.primary : Theme.of(context).myColors.buttonDisable)),
            const SizedBox(width: 6),
            Obx(() => MyCard.avatar(radius: 3, color: controller.state.pageIndex == 1 ? Theme.of(context).myColors.primary : Theme.of(context).myColors.buttonDisable))
          ],),
        ),
      ),
    ]);
  }
}
