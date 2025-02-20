import 'package:cgwallet/common/common.dart';
import 'package:cgwallet/views/views.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PromotionListView extends GetView<PromotionListController> {
  const PromotionListView({super.key});

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
      body: Obx(() => _buildBody(context))
    );
  }

  Widget _buildBody(BuildContext context) {
    if (controller.state.isLoading) {
      return loadingWidget;
    }

    if (controller.state.promotionList.value.list.isEmpty) {
      return noDataWidget;
    }

    return SafeArea(child: SingleChildScrollView(
      child: Column(
        children: controller.state.promotionList.value.list.asMap().entries.map(
          (e) =>_buildPromotionItem(context, e.value)
        ).toList()
      )
    ));
  }

  Widget _buildPromotionItem(BuildContext context, PromotionModel data) {
    final width = Get.width - 32;
    final height = width / 350 * 150;
    final borderRadius = BorderRadius.circular(10);
    final image = MyImage(
      borderRadius: borderRadius,
      fit: BoxFit.contain,
      imageUrl: data.banner, 
      height: height, 
      width: double.infinity
    );
    final title = Container(
      width: double.infinity,
      color: Theme.of(context).myColors.dark.withOpacity( 0.3),
      padding: const EdgeInsets.fromLTRB(16, 6, 16, 6),
      child: Text(data.title, style: Theme.of(context).myStyles.contentLight, maxLines: 2, overflow: TextOverflow.ellipsis)
    );
    return MyButton.widget(onPressed: () => controller.goPromotionInfoView(data), child: MyCard(
      color: Theme.of(context).myColors.cardBackground,
      borderRadius: borderRadius,
      margin: const EdgeInsets.fromLTRB(16, 6, 16, 6),
      border: Border.all(width: 1, color: Get.theme.myColors.carouselBorder),
      boxShadow: [BoxShadow(blurRadius: 8,color: Colors.black.withOpacity( 0.2))],
      child: ClipRRect(
        borderRadius: borderRadius,
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [image, title]
        ),
      ),
    ));
  }
}