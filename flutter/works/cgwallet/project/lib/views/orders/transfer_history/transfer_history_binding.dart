import 'package:get/get.dart';

import 'index.dart';

class TransferHistoryBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TransferHistoryController>(() => TransferHistoryController());
  }
}
