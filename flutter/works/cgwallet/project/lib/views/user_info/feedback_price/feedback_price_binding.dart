import 'package:get/get.dart';

import 'index.dart';

class FeedbackPriceBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<FeedbackPriceController>(() => FeedbackPriceController());
  }
}