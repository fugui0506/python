import 'package:cgwallet/common/common.dart';
import 'package:get/get.dart';

import 'index.dart';

class FrameController extends GetxController {
  final state = FrameState();

  @override
  void onReady() async {
    super.onReady();
    await Future.delayed(MyConfig.app.timePageTransition);
  }

  void onChanged(int index) {
    Get.focusScope?.unfocus();
    if (index == 4) {
      goScanView();
    } else {
      state.pageIndex = index;
    }

    if (index != 1) {
      final flashExchangeController = Get.find<FlashExchangeController>();
      flashExchangeController.resetFlashExchangeViewData();
    }
  }

  void goScanView() {
    Get.toNamed(MyRoutes.scanView);
  }
}
