import 'package:get/get.dart';

import 'index.dart';

class TransferBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TransferController>(() => TransferController());
  }
}
