import 'package:get/get.dart';

import 'index.dart';

class SellOrderBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SellOrderController>(() => SellOrderController());
  }
}
