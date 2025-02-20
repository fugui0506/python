import 'package:cgwallet/common/common.dart';
import 'package:get/get.dart';

import 'index.dart';

class VerifiedResultController extends GetxController {
  final state = VerifiedResultState();

  @override
  void onReady() async {
    super.onReady();
    await Future.delayed(MyConfig.app.timePageTransition);
  }
}
