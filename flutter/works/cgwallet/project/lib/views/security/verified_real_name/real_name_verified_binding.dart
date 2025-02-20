import 'package:get/get.dart';

import 'index.dart';

class RealNameVerifiedBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<RealNameVerifiedController>(() => RealNameVerifiedController());
  }
}
