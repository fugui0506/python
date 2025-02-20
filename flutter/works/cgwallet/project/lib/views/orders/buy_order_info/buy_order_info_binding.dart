import 'package:get/get.dart';

import 'index.dart';

class BuyOrderInfoBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BuyOrderInfoController>(() => BuyOrderInfoController());
  }
}
