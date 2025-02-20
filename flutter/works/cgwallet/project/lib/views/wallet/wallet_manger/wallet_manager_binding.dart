import 'package:get/get.dart';

import 'index.dart';

class WalletMangerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<WalletMangerController>(() => WalletMangerController());
  }
}
