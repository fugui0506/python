import 'package:get/get.dart';

import 'index.dart';

class ChatFaqInfoBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ChatFaqInfoController>(() => ChatFaqInfoController());
  }
}
