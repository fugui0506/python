import 'package:cgwallet/common/common.dart';
import 'package:get/get.dart';

import 'index.dart';

class SettingsController extends GetxController {
  final state = SettingsState();

  @override
  void onReady() async {
    super.onReady();
    await Future.delayed(MyConfig.app.timePageTransition);
  }

  void onAudio(bool value) {

  }

  void onVibration(bool value) {

  }

  void onThemeSystem() async {
    Get.back();
    showLoading();
    await MyTheme.changeThemeMode('0');
    hideLoading();
  }

  void onThemeDark() async {
    Get.back();
    showLoading();
    MyTheme.changeThemeMode('1');
    hideLoading();
  }

  void onThemeLight() async {
    Get.back();
    showLoading();
    MyTheme.changeThemeMode('2');
    hideLoading();
  }

  void onLanguageChinese() async {
    Get.back();
    showLoading();
    await Future.delayed(MyConfig.app.timePageTransition);
    await MyLang.updateLocale('zh_CN', true);
    hideLoading();
  }

  void onLanguageEnglish() async {
    Get.back();
    showLoading();
    await Future.delayed(MyConfig.app.timePageTransition);
    await MyLang.updateLocale('en_US', true);
    hideLoading();
  }
}
