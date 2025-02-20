import 'package:get/get.dart';

import 'index.dart';

class QrcodeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<QrcodeController>(() => QrcodeController());
  }
}
