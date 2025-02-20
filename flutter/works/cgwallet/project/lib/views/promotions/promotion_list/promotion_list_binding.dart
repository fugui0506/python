import 'package:get/get.dart';

import 'index.dart';

class PromotionListBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PromotionListController>(() => PromotionListController());
  }
}
