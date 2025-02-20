import 'package:get/get.dart';

import 'index.dart';

class FlashExchangeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<FlashExchangeController>(() => FlashExchangeController());
  }
}
