import 'package:get/get.dart';

import 'activity_trade_price_controller.dart';

class ActivityTradePriceBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ActivityTradePriceController>(() => ActivityTradePriceController());
  }
}