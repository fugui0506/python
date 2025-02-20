import 'package:get/get.dart';

import 'index.dart';

class FlashOrderHistoryBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<FlashOrderHistoryController>(() => FlashOrderHistoryController());
  }
}
