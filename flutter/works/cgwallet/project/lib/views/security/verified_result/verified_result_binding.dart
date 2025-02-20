import 'package:get/get.dart';

import 'index.dart';

class VerifiedResultBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<VerifiedResultController>(() => VerifiedResultController());
  }
}
