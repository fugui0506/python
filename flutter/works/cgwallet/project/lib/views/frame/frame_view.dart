import 'package:cgwallet/common/common.dart';
import 'package:cgwallet/views/views.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FrameView extends GetView<FrameController> {
  const FrameView({super.key});


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Theme.of(context).myColors.background,
      body: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        Obx(() => IndexedStack(
          index: controller.state.pageIndex,
          children: const [
            HomeView(),
            FlashExchangeView(),
            ChatView(),
            MineView(),
        ])),
        _buildBottomNavigationBar(context),
      ],
    );
  }

  Widget _buildBottomNavigationBar(BuildContext context) {
    final floatButton = Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Theme.of(context).myColors.bottomNavigationBackground,
      ),
      child: MyButton.widget(onPressed: controller.goScanView, child: Column(children: [
        MyButton.icon(onPressed: controller.goScanView, icon: Theme.of(context).myIcons.bottomScan),
      ])),
    );

    const iconHeight = 24.0;
    const textHeight = 18.0;

    final redWidget = MyCard.avatar(
      radius: 5, 
      color: Get.theme.myColors.error, 
      border: Border.all(color: Get.theme.myColors.cardBackground, width: 2),
    );

    final redMine = Obx(() => UserController.to.activityList.value.isRed || UserController.to.redDot.value.versionDot > 0
      ? Positioned(right: 0, top: 0, child: redWidget) 
      : const SizedBox()
    );

    final redCustomer = Obx(() {
      int unReadCount = 0;
      for(var item in UserController.to.customerHistoryList.value.list) {
        unReadCount += item.newLength;
      }

      if (unReadCount <= 0 && controller.state.noticeRead.value.countAll <= 0) {
        return const SizedBox();
      }

      return Positioned(right: 0, top: 0, child: redWidget);
    });

    final bottomItems = Row(children: [
      Expanded(child: MyButton.widget(onPressed: () => controller.onChanged(0), child: Container(color: Theme.of(context).myColors.background.withOpacity( 0), child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Obx(() => SizedBox(height: iconHeight, child: controller.state.pageIndex == 0 ? Theme.of(context).myIcons.bottomHome1 : Theme.of(context).myIcons.bottomHome0)),
        Obx(() => SizedBox(height: textHeight, width: double.infinity, child: Center(child: FittedBox(child: Text(Lang.bottomHome.tr, style: controller.state.pageIndex == 0 ? Theme.of(context).myStyles.bottomSelect : Theme.of(context).myStyles.bottomUnselect))))),
      ])))),
      Expanded(child: MyButton.widget(onPressed: () => controller.onChanged(1), child: Container(color: Theme.of(context).myColors.background.withOpacity( 0), child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Obx(() => SizedBox(height: iconHeight, child: controller.state.pageIndex == 1 ? Theme.of(context).myIcons.bottomFlash1 : Theme.of(context).myIcons.bottomFlash0)),
        Obx(() => SizedBox(height: textHeight, width: double.infinity, child: Center(child: FittedBox(child: Text(Lang.bottomFlashExchange.tr, style: controller.state.pageIndex == 1 ? Theme.of(context).myStyles.bottomSelect : Theme.of(context).myStyles.bottomUnselect))))),
      ])))),
      Expanded(child: MyButton.widget(onPressed: () => controller.onChanged(4), child: Container(color: Theme.of(context).myColors.background.withOpacity( 0), child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        SizedBox(height: iconHeight, child: Theme.of(context).myIcons.bottomScan),
        SizedBox(height: textHeight, width: double.infinity, child: Center(child: FittedBox(child: Text(Lang.bottomScan.tr, style: Theme.of(context).myStyles.bottomSelect)))),
      ])))),
      Expanded(child: MyButton.widget(onPressed: () => controller.onChanged(2), child: Container(color: Theme.of(context).myColors.background.withOpacity( 0), child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Stack(children: [SizedBox(height: iconHeight, child: Obx(() => controller.state.pageIndex == 2 ? Theme.of(context).myIcons.bottomChat1 : Theme.of(context).myIcons.bottomChat0)), redCustomer]),
        Obx(() => SizedBox(height: textHeight, width: double.infinity, child: Center(child: FittedBox(child: Text(Lang.bottomChat.tr, style: controller.state.pageIndex == 2 ? Theme.of(context).myStyles.bottomSelect : Theme.of(context).myStyles.bottomUnselect))))),
      ])))),
      Expanded(child: MyButton.widget(onPressed: () => controller.onChanged(3), child: Container(color: Theme.of(context).myColors.background.withOpacity( 0), child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Stack(children: [SizedBox(height: iconHeight, child: Obx(() => controller.state.pageIndex == 3 ? Theme.of(context).myIcons.bottomMine1 : Theme.of(context).myIcons.bottomMine0)), redMine]),
        Obx(() => SizedBox(height: textHeight, width: double.infinity, child: Center(child: FittedBox(child: Text(Lang.bottomMine.tr, style: controller.state.pageIndex == 3 ? Theme.of(context).myStyles.bottomSelect : Theme.of(context).myStyles.bottomUnselect))))),
      ])))),
    ]);
    
    final navigationBar = Stack(
      alignment: Alignment.bottomCenter,
      children: [
        const SizedBox(
          width: double.infinity,
          height: 76,
        ),
        Container(
          color: Theme.of(context).myColors.bottomNavigationBackground,
          child: SizedBox(height: MyConfig.app.bottomHeight, child: bottomItems),
        ),
        Positioned(
          top: 0,
          child: floatButton,
        ),
      ],
    );

    final bottomSafeSpace = Container(
      color: Theme.of(context).myColors.bottomNavigationBackground, 
      child: SafeArea(top: false, child: Container(color: Theme.of(context).myColors.bottomNavigationBackground))
    );

    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        navigationBar,
        bottomSafeSpace,
    ]);
  }
}