import 'package:get/get.dart';

import 'index.dart';

class WalletAddBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<WalletAddController>(() => WalletAddController());
  }
}
