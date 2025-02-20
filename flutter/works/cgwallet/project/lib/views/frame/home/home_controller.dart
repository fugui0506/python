import 'package:cgwallet/common/common.dart';
import 'package:cgwallet/views/views.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';


class HomeController extends GetxController {
  final state = HomeState();
  final RefreshController refreshController = RefreshController();
  final ScrollController scrollController = ScrollController();

  @override
  void onReady() async {
    super.onReady();
    await Future.delayed(MyConfig.app.timePageTransition);
    checkApiUrl(onNext: () => _checkUpdateAndRiskControl());
  }

  Future<void> _checkUpdateAndRiskControl() async {
    if (!UserController.to.isCheckUpdate) {
      checkUpdate(onNext: () async {
        await UserController.to.checkRiskControlled(onNext: initData);
      });
    } else {
      await UserController.to.checkRiskControlled(onNext: initData);
    }
  }

  Future<void> getHomeData() async {
    getUnReadCount();
    getMarqueeList();
    getCarouselList();
    getFaqList();
    getSwapSetting();
  }

  Future<void> getSwapSetting() async {
    final flashExchangeController = Get.find<FlashExchangeController>();
    await flashExchangeController.getFlashExchangeData();
  }

  Future<void> onRefresh() async {
    await Future.wait([
      getHomeData(),
      UserController.to.getAppData(),
      UserController.to.updateUserInfo(),
    ]);
    await UserController.to.wss?.connect();
    refreshController.refreshCompleted();
  }

  void copyUserId() {
    UserController.to.userInfo.value.user.id.toString().copyToClipBoard();
  }

  void copyWalletAddress() async {
    checkRealName(() => UserController.to.userInfo.value.walletAddress.toString().copyToClipBoard());
  }

  void goUserInfoView() {
    Get.toNamed(MyRoutes.personalInfoView);
  }

  void goBuyCoinView() {
    checkRealName(() => Get.toNamed(MyRoutes.buyOrderView));
  }

  void goSellCoinView() {
    checkRealName(() => Get.toNamed(MyRoutes.sellOrderView));
  }

  void goTransferView() {
    checkRealName(() => Get.toNamed(MyRoutes.transferView));
  }

  void goBuyOrdersView() {
    Get.toNamed(MyRoutes.buyOrderListView);
  }

  void goSellOrdersView() {
    Get.toNamed(MyRoutes.sellOrderListView);
  }

  void goNoticeView() {
    Get.toNamed(MyRoutes.notifyView, arguments: 1);
  }

  void goBuyCoinQuicklyView() {
    checkRealName(() => Get.toNamed(MyRoutes.buyCoinsQuicklyView));
  }

  void goQrcodeView() {
    checkRealName(() => Get.toNamed(MyRoutes.qrcodeView));
  }

  Future<void> getUnReadCount() async {
    await state.noticeRead.value.update();
    state.noticeRead.refresh();
    final FrameController frameController = Get.find();
    frameController.state.noticeRead.value = state.noticeRead.value;
    frameController.state.noticeRead.refresh();
  }

  void initData() async {
    if (Get.currentRoute == MyRoutes.frameView) {
      hideLoading();

      setMyDio();

      UserController.to.wss = MyWss();
      UserController.to.wss?.connect();

      final deepLink = UserController.to.deepLinkQrcodeResultToList;
      if (deepLink != null) {
        await Future.delayed(MyConfig.app.timeWait);
        await Get.toNamed(MyRoutes.payView, arguments: deepLink);
        UserController.to.deepLinkQrcodeResultToList = null;
      }

      getHomeData();
      getPublicNoticeList();
      UserController.to.getAppData();
    }
  }

  Future<void> getMarqueeList() async {
    await state.marqueeList.value.update();
    state.marqueeList.refresh();
  }

  Future<void> getCarouselList() async {
    await state.carouselList.value.update();
    state.carouselList.refresh();
  }

  Future<void> getFaqList() async {
    await state.faqList.value.update();
    state.faqList.refresh();
    state.isLoadingFAQ = false;
  }

  Future<void> getPublicNoticeList() async {
    final path = ApiPath.me.getPublicNotice;
    final sharedKey = '${MyConfig.shard.isHidePublicNoticeKey}_${UserController.to.userInfo.value.user.id}';

    await state.publicNoteList.value.update(apiPath: path);
    state.publicNoteList.refresh();

    final hideTime = await MyShared.to.get(sharedKey);

    if (hideTime.isEmpty) {
      showPublicMessageBox();
    } else {
      final isPassToday = MyTimer.isPassToday(int.parse(hideTime));

      if (hideTime.isNotEmpty && !isPassToday) {
        return;
      }

      await MyShared.to.delete(sharedKey);
      showPublicMessageBox();
    }
  }

  void showPublicMessageBox() {
    if (state.publicNoteList.value.list.isNotEmpty) {
      getNoticesBox(data: state.publicNoteList.value, isPublicNotice: true);
    }
  }

  void carouselOnChanged(int index) {
    state.carouselIndex = index;
  }
}
