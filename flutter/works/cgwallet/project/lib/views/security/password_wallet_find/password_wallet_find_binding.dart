import 'package:get/get.dart';

import 'index.dart';

class PasswordWalletFindBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PasswordWalletFindController>(() => PasswordWalletFindController());
  }
}
