import 'package:get/get.dart';

import 'index.dart';

class EditNicknameBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<EditNicknameController>(() => EditNicknameController());
  }
}
