import 'package:get/get.dart';

import 'index.dart';

class FlashOrderInfoBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<FlashOrderInfoController>(() => FlashOrderInfoController());
  }
}
