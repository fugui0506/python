import 'package:get/get.dart';

import 'index.dart';

class FaceVerifiedBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<FaceVerifiedController>(() => FaceVerifiedController());
  }
}
