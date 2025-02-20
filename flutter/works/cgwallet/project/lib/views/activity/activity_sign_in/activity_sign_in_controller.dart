import 'package:cgwallet/common/common.dart';
import 'package:get/get.dart';

import 'index.dart';

class ActivitySignInController extends GetxController {
  final state = ActivitySignInState();

  @override
  void onReady() async {
    super.onReady();
    await Future.delayed(MyConfig.app.timePageTransition);
    await updateActivityData();
    state.isLoading = false;
  }

  Future<void> updateActivityData() async {
    await state.activityData.value.update();
    state.activityData.refresh();
  }

  void updateUserInfoAndActivityList() {
    UserController.to.updateUserInfo();
    UserController.to.updateActivityList();
  }

  Future<void> signIn() async {
    showLoading();
    await UserController.to.dio?.post(ApiPath.activity.signIn,
      onSuccess: (code, msg, data) async {
        await updateActivityData();
        Future.delayed(MyConfig.app.timeWait).then((value) => updateUserInfoAndActivityList());
      },
    );
    hideLoading();
  }

  Future<void> getReward(RechargeReward data) async {
    showLoading();
    await UserController.to.dio?.post(ApiPath.activity.getReward,
      onSuccess: (code, msg, data) async {
        await updateActivityData();
        MyAlert.snackbar(msg);
        Future.delayed(MyConfig.app.timeWait).then((value) => updateUserInfoAndActivityList());
      },
      data: {
        "days": data.consecutiveDays,
        "id": data.id,
      }
    );
    hideLoading();
  }
}
