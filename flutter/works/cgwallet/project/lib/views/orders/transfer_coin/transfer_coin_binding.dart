import 'package:get/get.dart';

import 'index.dart';

class TransferCoinBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TransferCoinController>(() => TransferCoinController());
  }
}
