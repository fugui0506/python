import 'package:get/get.dart';

import 'index.dart';

class BuyCoinsQuicklyBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BuyCoinsQuicklyController>(() => BuyCoinsQuicklyController());
  }
}
