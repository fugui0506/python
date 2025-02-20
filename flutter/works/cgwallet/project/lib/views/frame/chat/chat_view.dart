
import 'package:cgwallet/common/common.dart';
import 'package:cgwallet/views/frame/home/index.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'index.dart';

class ChatView extends StatelessWidget {
  const ChatView({super.key});

  @override
  Widget build(BuildContext context) {
    /// 页面构成
    return GetBuilder<ChatController>(
      init: ChatController(),
      builder: (controller) => _buildScaffold(context, controller),
    );
  }

  Widget _buildScaffold(BuildContext context, ChatController controller) {
    return Scaffold(
      appBar: _buildAppBar(context, controller), 
      body: _buildBody(context, controller),
      backgroundColor: Theme.of(context).myColors.background,
    );
  }

  MyAppBar _buildAppBar(BuildContext context, ChatController controller) {
    return MyAppBar.normal(title: Lang.chatViewTitle.tr,);
  }

  Widget _buildBody(BuildContext context, ChatController controller) {
    final HomeController homeController = Get.find();
    final redWidget = MyCard.avatar(
      radius: 6, 
      color: Get.theme.myColors.error, 
      border: Border.all(color: Get.theme.myColors.cardBackground, width: 2),
    );

    final notify = Stack(children: [
      Obx(() => _buildItem(
        context: context,
        icon: Theme.of(context).myIcons.chatViewNotify,
        title: Lang.chatViewNotifyTitle.tr,
        content: homeController.state.noticeRead.value.systemContent.isEmpty ? Lang.chatViewNotifyContent.tr : homeController.state.noticeRead.value.systemContent.removeHtmlTags(),
        onPressed: () => controller.onNotifyView(1),
      )),
      Obx(() => homeController.state.noticeRead.value.systemCount > 0 ? Positioned(right: 4, top: 4, child: redWidget) : const SizedBox())
    ]);

    final notifyPersional = Stack(children: [
      Obx(() => _buildItem(
        context: context,
        icon: Theme.of(context).myIcons.chatViewNoticePersonal,
        title: Lang.chatViewNotifyPersonalTitle.tr,
        content: homeController.state.noticeRead.value.singleContent.isEmpty ? Lang.chatViewNotifyPersonalContent.tr : homeController.state.noticeRead.value.singleContent.removeHtmlTags(),
        onPressed: () => controller.onNotifyView(2),
      )),
      Obx(() => homeController.state.noticeRead.value.singleCount > 0 ? Positioned(right: 4, top: 4, child: redWidget) : const SizedBox())
    ]);

    final customer = Stack(alignment: Alignment.center, children: [
      _buildItem(
        context: context,
        icon: Theme.of(context).myIcons.chatViewCustomer,
        title: Lang.chatViewCustomerTitle.tr,
        content: Lang.chatViewCustomerContent.tr,
        onPressed: controller.onCustomer,
      ),
      Obx(() {
        int unReadCount = 0;
        for(var item in UserController.to.customerHistoryList.value.list) {
          unReadCount += item.newLength;
        }

        if (unReadCount <= 0) {
          return const SizedBox();
        }
        final redBox = MyCard.avatar(
            radius: 8,
            color: Theme.of(context).myColors.error,
            child: Center(child: FittedBox(child: Text('$unReadCount', style: Theme.of(context).myStyles.labelLight)))
        );
        return Positioned(right: 12, child: redBox);
      })
    ]);
    
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16), 
      child: Column(children: [
        notify, 
        const SizedBox(height: 10), 
        notifyPersional,
        const SizedBox(height: 10), 
        customer,
      ])
    );
  }

  Widget _buildItem({
    required BuildContext context,
    required MyAssets icon,
    required String title,
    required String content,
    required void Function()? onPressed
  }) {
    final child = MyCard.normal(padding: const EdgeInsets.all(16), child: Row(children: [
      icon,
      const SizedBox(width: 16),
      Flexible(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(title, style: Theme.of(context).myStyles.labelBig, maxLines: 1, overflow: TextOverflow.ellipsis),
        Text(content, style: Theme.of(context).myStyles.contentSmall, maxLines: 1, overflow: TextOverflow.ellipsis),
      ]))
    ]));

    return MyButton.widget(onPressed: onPressed, child: child);
  }
}
