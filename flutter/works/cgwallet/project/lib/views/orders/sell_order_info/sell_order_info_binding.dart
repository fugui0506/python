import 'package:get/get.dart';

import 'index.dart';

class SellOrderInfoBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SellOrderInfoController>(() => SellOrderInfoController());
  }
}
