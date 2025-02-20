import 'package:get/get.dart';

import 'banks_index.dart';

class BanksBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BanksController>(() => BanksController());
  }
}
