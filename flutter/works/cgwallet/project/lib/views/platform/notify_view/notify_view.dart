import 'package:cgwallet/common/common.dart';
import 'package:cgwallet/views/frame/home/index.dart';
import 'package:cgwallet/views/widgets/notify_list_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'index.dart';

class NotifyView extends GetView<NotifyController> {
  const NotifyView({super.key});

  @override
  Widget build(BuildContext context) {
    final HomeController homeController = Get.find();

    final redWidget = MyCard.avatar(
      radius: 6,
      color: Get.theme.myColors.error,
      border: Border.all(color: Get.theme.myColors.cardBackground, width: 2),
    );

    /// appbar
    var appBar = MyAppBar.normalWidget(
      title: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        Stack(children: [
          Obx(() => MyButton.filedShort(
              onPressed: () => controller.onIndex(1),
              text: Lang.notifyViewTitleSystem.tr,
              color: controller.state.index.value == 1 ? Theme.of(context).myColors.primary : Theme.of(context).myColors.cardBackground,
              textColor: controller.state.index.value == 1 ? Theme.of(context).myColors.onPrimary : Theme.of(context).myColors.textDefault
          )),
          Obx(() => homeController.state.noticeRead.value.systemCount > 0 ? Positioned(right: 4, top: 8, child: redWidget) : const SizedBox())
        ]),
        const SizedBox(width: 16),
        Stack(children: [
          Obx(() => MyButton.filedShort(
              onPressed: () => controller.onIndex(2),
              text: Lang.notifyViewTitlePersonal.tr,
              color: controller.state.index.value == 2 ? Theme.of(context).myColors.primary : Theme.of(context).myColors.cardBackground,
              textColor: controller.state.index.value == 2 ? Theme.of(context).myColors.onPrimary : Theme.of(context).myColors.textDefault
          )),
          Obx(() => homeController.state.noticeRead.value.singleCount > 0 ? Positioned(right: 4, top: 8, child: redWidget) : const SizedBox())
        ]),
        const SizedBox(width: 40),
      ]),
    );

    /// 页面构成
    return Scaffold(
      appBar: appBar,
      backgroundColor: Theme.of(context).myColors.background,
      body: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Obx(() => NotifyListView(
        data: controller.state.notifyList.value,
        isLoading: controller.state.isLoading,
        itemPressed: (index) {
          if (controller.state.notifyList.value.list[index].isRead == 0) {
            final homeController = Get.find<HomeController>();
            homeController.getUnReadCount();
            controller.state.notifyList.value.list[index].isRead = 1;
            controller.state.notifyList.refresh();
          }
        },
      ))
    );
  }
}
