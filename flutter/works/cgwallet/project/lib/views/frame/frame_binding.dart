import 'package:get/get.dart';

import 'index.dart';

class FrameBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<FrameController>(() => FrameController());
  }
}
