import 'package:cgwallet/common/common.dart';
import 'package:get/get.dart';

import 'index.dart';

class CustomerController extends GetxController {
  final state = CustomerState();
  final String? sysOrderId = Get.arguments;

  @override
  void onReady() async {
    super.onReady();
    await Future.delayed(MyConfig.app.timePageTransition);
    await getCustomerApiUrl();
    state.isLoading = false;
  }

  Future<void> getCustomerApiUrl() async {
    await state.chatFaqTypeList.value.update();
    state.chatFaqTypeList.refresh();
    state.isLoading = false;
    if (UserController.to.userInfo.value.token.isNotEmpty) {
      if (UserController.to.customerData.value.customer.isEmpty) {
        state.isNodata = true;
      } else {
        state.isNodata = false;
      }
    } else {
      if (UserController.to.guestCustomerData.value.customer.isEmpty) {
        state.isNodata = true;
      } else {
        state.isNodata = false;
      }
    }
  }

  void onTouristCustomer(String apiUrl, String imageUrl, Customer customer) async {
    UserController.to.goCustomerChatView(
      cert: customer.cret, 
      apiUrl: apiUrl,
      imageUrl: imageUrl,
      userId: UserController.to.guestCustomerData.value.chatId,
      sign: UserController.to.guestCustomerData.value.sign,
      tenantId: int.parse(UserController.to.guestCustomerData.value.chatUrl),
    );
  }

  void onLoginCustomer(String apiUrl, String imageUrl, Customer customer) {
    UserController.to.goCustomerChatView(
      cert: customer.cret, 
      sysOrderId: sysOrderId,
      apiUrl: apiUrl,
      imageUrl: imageUrl,
      userId: UserController.to.userInfo.value.user.id,
      tenantId: int.parse(UserController.to.customerData.value.chatUrl),
      avatarUrl: UserController.to.userInfo.value.user.avatarUrl,
      sign: UserController.to.customerData.value.sign,
    );
  }
}
