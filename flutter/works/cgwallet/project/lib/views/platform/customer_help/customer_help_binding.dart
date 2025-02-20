import 'package:get/get.dart';

import 'index.dart';

class CustomerHelpBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CustomerHelpController>(() => CustomerHelpController());
  }
}
