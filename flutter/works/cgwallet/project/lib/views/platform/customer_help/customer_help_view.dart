import 'package:cgwallet/common/common.dart';
import 'package:cgwallet/views/widgets/icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:get/get.dart';

import 'index.dart';

class CustomerHelpView extends GetView<CustomerHelpController> {
  const CustomerHelpView({super.key});

  @override
  Widget build(BuildContext context) {
    /// appbar
    var appBar = MyAppBar.normalWidget(
      title: MyButton.widget(
        onPressed: controller.moveScrollToTop,
        child: Text(controller.state.title, maxLines: 1, style: Theme.of(context).myStyles.labelBigger),
      ),
    );

    /// 页面构成
    return KeyboardDismissOnTap(child: Scaffold(
      appBar: appBar,
      backgroundColor: Theme.of(context).myColors.background,
      body: _buildBody(context),
    ));
  }

  Widget _buildBody(BuildContext context) {
    return Obx(() => controller.state.isLoading ? loadingWidget : Column(children: [
      Expanded(child: _buildChatBox(context)),
      Obx(() => _buildInputBox(context)),
    ]));
  }

  Widget _buildChatBox(BuildContext context) {
    return MyCard(
      width: double.infinity,
      height: double.infinity,
      color: Theme.of(context).myColors.background,
      borderRadius: BorderRadius.zero,
      child: Obx(() => MyRefreshView(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        onRefresh: controller.onRefresh,
        controller: controller.refreshController,
        scrollController: controller.scrollController,
        children: controller.state.chatItems.asMap().entries.map((e) => _buildItem(context, e.key, e.value)).toList()
      )),
    );
  }

  Widget _buildInputBox(BuildContext context) {
    int unReadCount = 0;
    for(var item in UserController.to.customerHistoryList.value.list) {
      unReadCount += item.newLength;
    }

    if (unReadCount <= 0) {
      return const SizedBox();
    }

    final card = MyCard.normal(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      padding: const EdgeInsets.only(top: 16),
      color: Colors.transparent,
      child: SafeArea(
        child: MyButton.filedWidget(
          onPressed: controller.goCustomerView,
          child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            // Theme.of(context).myIcons.customer(color: Theme.of(context).myColors.light),
            const SizedBox(width: 8),
            Text('您有新消息待查看', style: Theme.of(context).myStyles.labelLight),
            const SizedBox(width: 8),
            MyCard.avatar(
              radius: 8,
              color: Theme.of(context).myColors.error,
              child: Center(child: FittedBox(child: Text('$unReadCount', style: Theme.of(context).myStyles.labelLight)))
            )
          ]),
        )
      ),
    );

    return Stack(children: [
      card,
      Positioned(
        top: 0,
        left: 16,
        child: SizedBox(height: 80, child: Theme.of(context).myIcons.customerNewMessage)
      )
    ]);
  }

  Widget _buildItem(BuildContext context, int index, dynamic e) {
    final customerAvatar = MyCard.avatar(radius: 20, child: Theme.of(context).myIcons.customerAvatar);
    final userAvatar = MyCard.avatar(radius: 20, child: Obx(() => MyImage(imageUrl: UserController.to.userInfo.value.user.avatarUrl)));
    if (e is CustomerHelpModel) {
      return Column(children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(' Hi，在线客服为您解答！', style: Theme.of(context).myStyles.labelBiggest),
            Text(' 遇到问题，请尽管问我～', style: Theme.of(context).myStyles.labelSmall),
          ]),
          const SizedBox(width: 24),
          Flexible(child: FittedBox(child: SizedBox(height: 80, width: 80, child: Theme.of(context).myIcons.customerTitle)))
        ]),
        MyCard.normal(
          padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
          margin: const EdgeInsets.only(bottom: 16),
          color: Theme.of(context).myColors.cardBackground,
          child: Column(children: [
            MyHtml(data: e.title),
            const SizedBox(height: 10),
            Column(children: e.customerQuestions.asMap().entries.map((item) {
              // final isClicked = item.value.isClicked.obs;
              final child = MyCard.normal(
                padding: const EdgeInsets.fromLTRB(10, 10, 4, 10),
                color: Theme.of(context).myColors.itemCardBackground,
                margin: item.key == e.customerQuestions.length - 1 ? null : const EdgeInsets.only(bottom: 4),
                child: Row(children: [
                  Expanded(child: Row(children: [
                    SizedBox(width: 20, child: Text('${item.key + 1}', style: item.value.isClicked ? Theme.of(context).myStyles.label : Theme.of(context).myStyles.labelPrimary)),
                    Text(item.value.title, style: item.value.isClicked ? Theme.of(context).myStyles.label : Theme.of(context).myStyles.labelPrimary),
                  ])),
                  const SizedBox(width: 10),
                  SizedBox(height: 20, child: FittedBox(child: Theme.of(context).myIcons.right)),
                ]),
              );
              return MyButton.widget(onPressed: () {
                item.value.isClicked = true;
                controller.onCustomerQuestions(item.key, item.value);
              }, child: child);
            }).toList())
          ]),
        ),
      ]);
    } else if (e is CustomerQuestionModel) {
      return Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        customerAvatar,
        const SizedBox(width: 8),
        Flexible(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(e.createTime, style: Theme.of(context).myStyles.labelSmall),
          const SizedBox(height: 4),
          MyCard.normal(
            padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
            margin: const EdgeInsets.only(bottom: 16),
            color: Theme.of(context).myColors.cardBackground,
            child:  Column(children: [
              ...e.customerQuestionTypes.asMap().entries.map((item) {
                final child = MyCard.normal(
                  padding: const EdgeInsets.fromLTRB(10, 10, 4, 10),
                  color: Theme.of(context).myColors.itemCardBackground,
                  margin: item.key == e.customerQuestionTypes.length - 1 ? null : const EdgeInsets.only(bottom: 4),
                  child: Row(children: [
                    Expanded(child: Row(children: [
                      SizedBox(width: 20, child: Text('${item.key + 1}', style: item.value.isClicked ? Theme.of(context).myStyles.label : Theme.of(context).myStyles.labelPrimary)),
                      Flexible(child: Text(item.value.title, style: item.value.isClicked ? Theme.of(context).myStyles.label : Theme.of(context).myStyles.labelPrimary, maxLines: 1, overflow: TextOverflow.ellipsis,)),
                    ])),
                    const SizedBox(width: 10),
                    SizedBox(height: 20, child: FittedBox(child: Theme.of(context).myIcons.right)),
                  ]),
                );

                return MyButton.widget(onPressed: () {
                  item.value.isClicked = true;
                  controller.onCustomerAnswer(item.key, item.value);
                }, child: child);
              }),
              if (index == controller.state.chatItems.length - 1)
                const SizedBox(height: 10),
              if (index == controller.state.chatItems.length - 1)
                Text('以上不是我想要的答复', style: Theme.of(context).myStyles.labelSmall),
              if (index == controller.state.chatItems.length - 1)
                const SizedBox(height: 4),
              if (index == controller.state.chatItems.length - 1)
                MyButton.filedLong(onPressed: controller.goCustomerView, text: '人工客服'),
            ]),
          ),
        ])),
        const SizedBox(width: 40 + 8),
      ]);
    } else if (e is CustomerQuestionTypeModel) {
      return Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        customerAvatar,
        const SizedBox(width: 8),
        Flexible(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(e.createTime, style: Theme.of(context).myStyles.labelSmall),
          const SizedBox(height: 4),
          MyCard.normal(
            padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
            margin: const EdgeInsets.only(bottom: 16),
            color: Theme.of(context).myColors.cardBackground,
            child: index != controller.state.chatItems.length - 1
              ? MyHtml(data: e.customerAnswer)
              : Column(children: [
                  MyHtml(data: e.customerAnswer),
                  const SizedBox(height: 10),
                  Text('以上不是我想要的答复', style: Theme.of(context).myStyles.labelSmall),
                  const SizedBox(height: 4),
                  MyButton.filedLong(onPressed: controller.goCustomerView, text: '人工客服'),
            ]),
          ),
        ])),
        const SizedBox(width: 40 + 8),
      ]);
    } else if (e is CustomerUserMessageModel) {
      final msgBox = Column(children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(width: 40 + 8),
            Flexible(child: Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
              Text(e.createTime, style: Theme.of(context).myStyles.labelSmall),
              const SizedBox(height: 4),
              MyCard.normal(
                // margin: EdgeInsets.only(bottom: 16),
                padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
                color: Theme.of(context).myColors.primary,
                child: Text(e.title, style: Theme.of(context).myStyles.labelLight),
              ),
            ])),
            const SizedBox(width: 10),
            userAvatar,
          ],
        ),
        const SizedBox(height: 16),
      ]);
      return msgBox;
    }
    return const SizedBox();
  }
}
