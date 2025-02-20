import 'package:get/get.dart';

import 'index.dart';

class BuyOrderListBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BuyOrderListController>(() => BuyOrderListController());
  }
}
