import 'package:get/get.dart';

import 'index.dart';

class TutorialBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TutorialController>(() => TutorialController());
  }
}
