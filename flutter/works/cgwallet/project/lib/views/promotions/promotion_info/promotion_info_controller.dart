import 'package:cgwallet/common/common.dart';
import 'package:get/get.dart';

import 'index.dart';

class PromotionInfoController extends GetxController {
  final state = PromotionInfoState();

  @override
  void onReady() async {
    super.onReady();
    await Future.delayed(MyConfig.app.timePageTransition);
  }
}
