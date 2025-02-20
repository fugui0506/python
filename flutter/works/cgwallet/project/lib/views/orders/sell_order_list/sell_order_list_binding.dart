import 'package:get/get.dart';

import 'index.dart';

class SellOrderListBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SellOrderListController>(() => SellOrderListController());
  }
}
