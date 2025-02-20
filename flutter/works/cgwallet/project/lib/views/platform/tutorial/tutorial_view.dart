import 'package:cgwallet/common/common.dart';
import 'package:cgwallet/views/views.dart';
import 'package:cgwallet/views/widgets/tutorial_list_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TutorialView extends GetView<TutorialController> {
  const TutorialView({super.key});

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
      body: Obx(() => _buildBody(context)),
    );
  }

  Widget _buildBody(BuildContext context) {
    if (controller.state.isLoading) {
      return loadingWidget;
    }
    if (controller.state.tutorialList.value.list.isEmpty) {
      return noDataWidget;
    }
    return SingleChildScrollView(
      // padding: const EdgeInsets.all(16),
      child: TutorialListView(tutorialList: controller.state.tutorialList.value),
    );
  }
}
