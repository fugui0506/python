import 'package:get/get.dart';

import 'index.dart';

class WalletHistoryBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<WalletHistoryController>(() => WalletHistoryController());
  }
}
