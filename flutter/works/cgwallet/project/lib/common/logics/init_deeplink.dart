import 'package:app_links/app_links.dart';
import 'package:cgwallet/common/common.dart';
import 'package:cgwallet/views/orders/pay/pay_controller.dart';
import 'package:get/get.dart';

Future<void> initDeepLink() async {
  final appLinks = AppLinks();

  appLinks.uriLinkStream.listen((uri) async {
    await commonDeepLink(uri.toString());
  });
}

Future<void> commonDeepLink(String data) async {
  MyLogger.w('DeepLink Success: $data');

  final resultString = data.split('?').last.replaceAll('%20', ' ').split(';');
  // 处理 deep link 数据并导航到对应页面
  // 处理和解析 URL
  if (UserController.to.userInfo.value.token.isNotEmpty) {
    if (Get.currentRoute == MyRoutes.payView) {
      final payController = Get.find<PayController>();
      payController.state.data.value = resultString;
      payController.state.data.refresh();
    } else {
      Get.toNamed(MyRoutes.payView, arguments: resultString);
    }
  } else {
    UserController.to.deepLinkQrcodeResultToList = resultString;
    // MyAlert.snackbar('请先登录');
  }
}