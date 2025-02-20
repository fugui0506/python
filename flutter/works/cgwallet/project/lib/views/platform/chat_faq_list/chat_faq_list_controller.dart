import 'package:cgwallet/common/common.dart';
import 'package:get/get.dart';

import 'index.dart';

class ChatFaqListController extends GetxController {
  final state = ChatFaqListState();

  @override
  void onReady() async {
    super.onReady();
    await getChatFaqList();
    await Future.delayed(MyConfig.app.timePageTransition);
  }

  Future<void> getChatFaqList() async {
    await state.chatFaqList.value.update(typeId: state.chatFaqType.id);
    state.chatFaqList.refresh();
    state.isLoading = false;
    if (state.chatFaqList.value.list.isEmpty) {
      state.isNoData = true;
    }
  }
}
