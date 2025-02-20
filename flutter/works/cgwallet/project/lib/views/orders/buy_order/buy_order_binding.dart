import 'package:get/get.dart';

import 'index.dart';

class BuyOrderBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BuyOrderController>(() => BuyOrderController());
  }
}
