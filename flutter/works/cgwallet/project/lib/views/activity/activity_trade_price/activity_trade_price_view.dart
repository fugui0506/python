import 'package:cgwallet/common/common.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'activity_trade_price_controller.dart';

class ActivityTradePriceView extends GetView<ActivityTradePriceController> {
  const ActivityTradePriceView({super.key});

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
    return SingleChildScrollView(child: Theme.of(context).myIcons.tutorialTradeInfo);
  }
}
