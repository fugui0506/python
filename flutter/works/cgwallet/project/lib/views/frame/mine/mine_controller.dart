import 'package:cgwallet/common/common.dart';
import 'package:cgwallet/views/views.dart';
import 'package:get/get.dart';

class MineController extends GetxController {
  final state = MineState();

  @override
  void onReady() async {
    super.onReady();
    await Future.delayed(MyConfig.app.timePageTransition);
  }

  void goTutorialView() {
    Get.toNamed(MyRoutes.tutorialView);
  }

  void goWalletHistoryView() {
    Get.toNamed(MyRoutes.walletHistoryView);
  }

  void goPromotionListView() {
    Get.toNamed(MyRoutes.promotionListView);
  }

  void goFAQView() {
    Get.toNamed(MyRoutes.faqView);
  }

  void goNotifyView() {
    Get.toNamed(MyRoutes.notifyView, arguments: 1);
  }

  void goFeedbackPriceView() {
    Get.toNamed(MyRoutes.feedbackPriceView);
  }

  void goSettingsView() {
    Get.toNamed(MyRoutes.settingsView);
  }

  void goSecurityView() {
    Get.toNamed(MyRoutes.securityView);
  }

  void goWalletManagerView() {
    checkRealName(() => Get.toNamed(MyRoutes.walletManagerView));
  }

  void goVersionView() async {
    if (UserController.to.redDot.value.versionDot > 0) {
      UserController.to.readVersionNotice();

      await MyAlert.version2();
      await Future.delayed(const Duration(minutes: 5));
      UserController.to.checkVersionRedDot();
    } else {
      Get.toNamed(MyRoutes.versionView);
    }
  }

  void goPersonalInfoView() {
    Get.toNamed(MyRoutes.personalInfoView);
  }

  Future<void> goActivitySignInView() async {
    showLoading();
    await UserController.to.activityList.value.update();
    hideLoading();
    if (UserController.to.activityList.value.activity.first.activitySwitch == 1) {
      Get.toNamed(MyRoutes.activitySignInView);
    } else {
      MyAlert.snackbar(Lang.activityClosed.tr);
    }
  }

  Future<void> goActivityTradePriceView() async {
    Get.toNamed(MyRoutes.activityTradePrice);
  }
}
