import 'package:cgwallet/common/common.dart';
import 'package:get/get.dart';

import 'index.dart';

class FAQController extends GetxController {
  final state = FAQState();

  @override
  void onReady() async {
    super.onReady();
    await Future.delayed(MyConfig.app.timePageTransition);
    await updateData();
  }

  Future<void> updateData() async {
    await getFaqList();
    state.isLoading = false;
  }

  Future<void> getFaqList() async {
    await state.faqList.value.update();
    state.faqList.refresh();
  }
}
