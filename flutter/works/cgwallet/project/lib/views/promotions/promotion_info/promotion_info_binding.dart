import 'package:get/get.dart';

import 'index.dart';

class PromotionInfoBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PromotionInfoController>(() => PromotionInfoController());
  }
}
