import 'package:cgwallet/common/common.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';


import 'index.dart';

class IndexController extends GetxController {
  final state = IndexState();
  final ScrollController scrollController = ScrollController();

  @override
  void onReady() async {
    super.onReady();
    await Future.delayed(MyConfig.app.timePageTransition);
    checkAndUpdateCustomerData();
  }

  void goLoginView() {
    Get.offAllNamed(MyRoutes.loginView);
    MyShared.to.set(MyConfig.shard.isUsedAppKey, 'true');
  }
}
