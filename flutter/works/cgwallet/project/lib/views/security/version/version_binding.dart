import 'package:get/get.dart';

import 'index.dart';

class VersionBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<VersionController>(() => VersionController());
  }
}
