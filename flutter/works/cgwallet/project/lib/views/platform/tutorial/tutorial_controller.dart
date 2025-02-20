import 'package:cgwallet/common/common.dart';
import 'package:get/get.dart';

import 'index.dart';

class TutorialController extends GetxController {
  final state = TutorialState();

  @override
  void onReady() async {
    super.onReady();
    await Future.delayed(MyConfig.app.timePageTransition);
    await getTutorial();
  }

  Future<void> getTutorial() async {
    await state.tutorialList.value.update();
    state.tutorialList.refresh();
    state.isLoading = false;
  }
}
