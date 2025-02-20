import 'package:cgwallet/common/common.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'index.dart';

class ChatFaqInfoView extends GetView<ChatFaqInfoController> {
  const ChatFaqInfoView({super.key});

  @override
  Widget build(BuildContext context) {
    /// appbar
    var appBar = MyAppBar.normal(
      title: controller.state.chatFaqInfo.title,
    );

    /// 页面构成
    return Scaffold(
      appBar: appBar,
      backgroundColor: Theme.of(context).myColors.background,
      body: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    return MyCard(
      // margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      height: double.infinity,
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      color: Theme.of(context).myColors.cardBackground,
      child: SingleChildScrollView(
          child: SafeArea(
              // child: controller.state.chatFaqInfo.picUrl.isEmpty
              //     ? MyHtml(data: controller.state.chatFaqInfo.answer)
              //     : MyImage(imageUrl: controller.state.chatFaqInfo.picUrl)
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                if (controller.state.chatFaqInfo.answer.isNotEmpty)
                  MyHtml(data: controller.state.chatFaqInfo.answer),
                if (controller.state.chatFaqInfo.picUrl.isNotEmpty)
                  const SizedBox(height: 10),
                if (controller.state.chatFaqInfo.picUrl.isNotEmpty)
                  MyImage(imageUrl: controller.state.chatFaqInfo.picUrl, width: double.infinity),
              ])
          )
      ),
    );
  }
}
