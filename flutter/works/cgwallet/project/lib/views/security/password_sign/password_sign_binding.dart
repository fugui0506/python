import 'package:get/get.dart';

import 'index.dart';

class PasswordSignBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PasswordSignController>(() => PasswordSignController());
  }
}
