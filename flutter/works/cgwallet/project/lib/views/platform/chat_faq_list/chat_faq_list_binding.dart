import 'package:get/get.dart';

import 'index.dart';

class ChatFaqListBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ChatFaqListController>(() => ChatFaqListController());
  }
}
