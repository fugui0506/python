import 'package:cgwallet/common/common.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'index.dart';

class PromotionInfoView extends GetView<PromotionInfoController> {
  const PromotionInfoView({super.key});

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
      body: SingleChildScrollView(child: MyImage(
        width: double.infinity,
        imageUrl: controller.state.promotionInfo.detail
      )),
    );
  }
}
