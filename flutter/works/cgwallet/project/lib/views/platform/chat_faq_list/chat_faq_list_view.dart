import 'package:cgwallet/common/common.dart';
import 'package:cgwallet/views/views.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChatFaqListView extends GetView<ChatFaqListController> {
  const ChatFaqListView({super.key});

  @override
  Widget build(BuildContext context) {
    /// appbar
    var appBar = MyAppBar.normal(
      title: controller.state.chatFaqType.categoryName,
    );

    /// 页面构成
    return Scaffold(
      appBar: appBar,
      backgroundColor: Theme.of(context).myColors.background,
      body: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    return Obx(() => controller.state.isLoading ? loadingWidget : controller.state.isNoData ? noDataWidget : _buildContent(context));
  }

  Widget _buildContent(BuildContext context) {
    final hot = Stack(
      alignment: Alignment.center,
      children: [
        SizedBox(width: 50, height: 16, child: Theme.of(context).myIcons.helpHot),
        SizedBox(width: 50, height: 16, child: Center(child: Padding(padding: const EdgeInsets.fromLTRB(8, 0, 8, 0), child: FittedBox(child: Text(Lang.faqHot.tr, style: Theme.of(context).myStyles.onButton))))),
      ],
    );

    return MyCard.normal(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      padding: const EdgeInsets.all(16),
      color: Theme.of(context).myColors.cardBackground,
      child: SingleChildScrollView(
        child: Column(children: controller.state.chatFaqList.value.list.asMap().entries.map((e) => MyButton.widget(
          onPressed: () {
            Get.toNamed(MyRoutes.chatFaqInfoView, arguments: e.value);
          },
          child: MyCard.normal(
            margin: e.key == controller.state.chatFaqList.value.list.length - 1 ? null : const EdgeInsets.only(bottom: 4),
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            color: Theme.of(context).myColors.primary.withOpacity( 0.1),
            child: Row(children: [
              Expanded(child: Row(children: [
                MyCard.avatar(
                    radius: 10,
                    color: Theme.of(context).myColors.primary,
                    child: Padding(padding: const EdgeInsets.all(4), child: FittedBox(child: Text("${e.value.sort}", style: Theme.of(context).myStyles.labelLight, textAlign: TextAlign.center)))
                ),
                const SizedBox(width: 10),
                Flexible(child: Text(e.value.title, style: Theme.of(context).myStyles.labelPrimary, overflow: TextOverflow.ellipsis)),
                if (e.value.symbol == 1) hot,
              ])),
              const SizedBox(height: 8),
              Theme.of(context).myIcons.right
            ])
          ),
        )).toList()),
      ),
    );
  }
}
