import 'package:cgwallet/common/common.dart';
import 'package:get/get.dart';

import 'index.dart';

class ChatController extends GetxController {
  final state = ChatState();

  @override
  void onReady() async {
    super.onReady();
    await Future.delayed(MyConfig.app.timePageTransition);
  }

  void onNotifyView(int type) {
    // type == 1 系统公告
    // type == 2 个人通知
    Get.toNamed(MyRoutes.notifyView, arguments: type);
  }

  void onCustomer() {
    Get.toNamed(MyRoutes.customerHelpView);
  }
}
