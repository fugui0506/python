import 'package:cgwallet/common/common.dart';
import 'package:get/get.dart';

import 'index.dart';

class ChatFaqInfoController extends GetxController {
  final state = ChatFaqInfoState();

  @override
  void onReady() async {
    super.onReady();
    await Future.delayed(MyConfig.app.timePageTransition);
  }
}
