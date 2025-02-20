import 'package:cgwallet/common/common.dart';
import 'package:cgwallet/views/frame/home/index.dart';
import 'package:get/get.dart';

import 'index.dart';

class NotifyController extends GetxController {
  final state = NotifyState();

  Worker? indexChangedListener;

  @override
  void onInit() {
    state.index.value = state.type;
    super.onInit();
  }

  @override
  void onReady() async {
    super.onReady();
    await Future.delayed(MyConfig.app.timePageTransition);
    await getNotify(state.type);
    state.isLoading = false;

    indexChangedListener = debounce(state.index, (callback) async {
      state.isLoading = true;
      await getNotify(callback);
      state.isLoading = false;
    }, time: MyConfig.app.timeDebounce);
  }

  @override
  void onClose() {
    indexChangedListener?.call();
    final homeController = Get.find<HomeController>();
    homeController.getUnReadCount();
    super.onClose();
  }

  void onIndex(int index) {
    if (state.index.value == index) {
      return;
    }
    state.index.value = index;
  }

  Future<void> getNotify(int typeId) async {
    await state.notifyList.value.update(typeId: typeId);
    state.notifyList.refresh();
  }
}
