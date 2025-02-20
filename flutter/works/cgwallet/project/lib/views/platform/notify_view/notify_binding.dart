import 'package:get/get.dart';

import 'index.dart';

class NotifyBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<NotifyController>(() => NotifyController());
  }
}
