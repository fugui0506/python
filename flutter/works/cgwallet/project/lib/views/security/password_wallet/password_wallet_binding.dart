import 'package:get/get.dart';

import 'index.dart';

class PasswordWalletBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PasswordWalletController>(() => PasswordWalletController());
  }
}
