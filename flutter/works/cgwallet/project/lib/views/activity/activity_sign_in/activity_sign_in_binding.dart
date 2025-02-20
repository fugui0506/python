import 'package:get/get.dart';

import 'index.dart';

class ActivitySignInBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ActivitySignInController>(() => ActivitySignInController());
  }
}
