import 'package:cgwallet/common/common.dart';
import 'package:get/get.dart';

import 'index.dart';

class PromotionListController extends GetxController {
  final state = PromotionListState();

  @override
  void onReady() async {
    super.onReady();
    await Future.delayed(MyConfig.app.timePageTransition);
    await getPromotions();
  }

  Future<void> getPromotions() async {
    await state.promotionList.value.update();
    state.promotionList.refresh();
    state.isLoading = false;
  }

  void goPromotionInfoView(PromotionModel data) {
    Get.toNamed(MyRoutes.promotionInfoView, arguments: data);
  }
}
