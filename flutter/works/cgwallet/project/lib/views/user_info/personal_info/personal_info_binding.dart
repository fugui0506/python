import 'package:get/get.dart';

import 'index.dart';

class PersonalInfoBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PersonalInfoController>(() => PersonalInfoController());
  }
}
