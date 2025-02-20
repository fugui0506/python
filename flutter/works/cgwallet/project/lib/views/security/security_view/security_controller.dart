import 'package:cgwallet/common/common.dart';
import 'package:get/get.dart';

import 'index.dart';

class SecurityController extends GetxController {
  final state = SecurityState();

  @override
  void onReady() async {
    super.onReady();
    await Future.delayed(MyConfig.app.timePageTransition);
  }

  void goPasswordSignView() {
    Get.toNamed(MyRoutes.passwordSignView);
  }

  void onChangePhone() {
    MyAlert.snackbar(Lang.securityViewPhoneAlert.tr);
  }

  void goPasswordWalletView() async {
    final result = await Get.toNamed(MyRoutes.passwordWalletView);
    if (result != null) {
      await Future.delayed(MyConfig.app.timeWait);
      await UserController.to.updateIsSetWalletPassword();
    }
  }

  void goRealNameVerifiedView() async {
    await Get.toNamed(MyRoutes.realNameVerifiedView);
  }

  String getSecurityType() {
    if ([1, 3].contains(UserController.to.userInfo.value.user.isAuth)) {
      return Lang.securityViewRealNameCertified.tr;
    } else if ([2].contains(UserController.to.userInfo.value.user.isAuth)) {
      return Lang.securityViewRealNameCertificationFailed.tr;
    } else {
      return Lang.securityViewRealNameGoToCertification.tr;
    }
  }

  
}
