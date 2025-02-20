import 'package:get/get.dart';

import 'index.dart';

class FAQBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<FAQController>(() => FAQController());
  }
}
