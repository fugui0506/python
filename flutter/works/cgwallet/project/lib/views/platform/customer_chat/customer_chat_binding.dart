import 'package:get/get.dart';

import 'index.dart';

class CustomerChatBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CustomerChatController>(() => CustomerChatController());
  }
}
