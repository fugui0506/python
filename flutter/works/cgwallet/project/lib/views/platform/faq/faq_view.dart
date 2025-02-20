import 'package:cgwallet/common/common.dart';
import 'package:cgwallet/views/views.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FAQView extends GetView<FAQController> {
  const FAQView({super.key});

  @override
  Widget build(BuildContext context) {
    /// appbar
    var appBar = MyAppBar.normal(
      title: controller.state.title,
    );

    /// 页面构成
    return Scaffold(
      appBar: appBar,
      backgroundColor: Theme.of(context).myColors.background,
      body: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    return SafeArea(child: SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
      child: Obx(() => FaqListView(faqList: controller.state.faqList.value, isShowTitle: false, isLoading: controller.state.isLoading)),
    ));
  }
}
