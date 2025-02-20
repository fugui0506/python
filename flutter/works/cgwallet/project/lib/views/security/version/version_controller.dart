import 'package:cgwallet/common/common.dart';
import 'package:get/get.dart';

import 'index.dart';

class VersionController extends GetxController {
  final state = VersionState();

  @override
  void onReady() async {
    super.onReady();
    await Future.delayed(MyConfig.app.timePageTransition);
  }

  Future<void> getVersion() async {
    state.isButtonDisable = true;
    showLoading();
    await UserController.to.updateVersion();
    hideLoading();
    state.isButtonDisable = false;
    checkVersion(isAlert: true);
  }
}
