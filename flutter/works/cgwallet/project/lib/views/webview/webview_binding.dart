import 'package:get/get.dart';

import 'index.dart';

class WebviewBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<WebviewController>(() => WebviewController());
  }
}
