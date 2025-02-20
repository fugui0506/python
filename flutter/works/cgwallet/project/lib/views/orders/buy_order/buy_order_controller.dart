import 'package:cgwallet/common/common.dart';
import 'package:cgwallet/views/views.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class BuyOrderController extends GetxController {
  final state = BuyOrderState();

  final minTextController = TextEditingController();
  final minFocusNode = FocusNode();

  final maxTextController = TextEditingController();
  final maxFocusNode = FocusNode();

  final amountController = TextEditingController();
  final amountFocusNode = FocusNode();

  final RefreshController refreshController = RefreshController();

  Worker? worker;

  @override
  void onReady() async {
    super.onReady();
    await Future.delayed(MyConfig.app.timePageTransition);
    inputAddListener();
    await getData();
    await UserController.to.updateOrderSetting();

    state.isLoading = false;

    worker = debounce(state.params, (callback) async {
      state.params.value.page = 1;
      state.isLoading = true;
      await updateOrderMarketList();
      state.isLoading = false;
      refreshController.resetNoData();
    }, time: MyConfig.app.timeDebounce);
  }

  @override
  void onClose() {
    inputRemoveListener();
    worker?.call();
    super.onClose();
  }

  void inputAddListener() {
    amountController.addListener(listener);
  }

  void inputRemoveListener() {
    amountController.removeListener(listener);
  }

  void onAmount(int index) async {
    Get.focusScope?.unfocus();

    if (state.amountIndex == index) {
      state.amountIndex = 0;
    } else {
      state.amountIndex = index;
      
    }

    if (state.amountIndex != 0) {
      await Future.delayed(MyConfig.app.timePageTransition);
      minTextController.text = state.amountIndex == 3 ? state.params.value.minQuantity ?? '0' : '0';
      maxTextController.text = state.amountIndex == 3 ? state.params.value.maxQuantity ?? '0' : '0';
    }
  }

  void onAmountAll(OrderMarketInfoModel data) {
    amountController.text = double.parse(data.forSaleQuantity) < double.parse(data.maxAmt)
      ? data.forSaleQuantity
      : data.maxAmt;
  }

  Future<void> getData() async {
    await Future.wait([
      updateOrderMarketList(),
      getPublicNoticeList(),
      getMarqueeList(),
    ]);
  }

  void onResetAmount() {
    Get.focusScope?.unfocus();
    state.amountIndex = 0;
    minTextController.text = '0';
    maxTextController.text = '0';
  }

  void onConfirmAmount() {
    Get.back();
    state.params.update((val) {
      val!.sort = state.amountIndex;
      val.minQuantity = minTextController.text;
      val.maxQuantity = maxTextController.text;
    });

    if (state.amountIndex == 1) {
      state.amountTitle = Lang.buyOrderViewSmall.tr;
    } else if (state.amountIndex == 2) {
      state.amountTitle = Lang.buyOrderViewMax.tr;
    } else if (state.amountIndex == 3) {
      if (minTextController.text.isNotEmpty && maxTextController.text.isEmpty) {
        state.amountTitle = '> ${minTextController.text}';
      } else if (minTextController.text.isEmpty && maxTextController.text.isNotEmpty) {
        state.amountTitle = '< ${maxTextController.text}';
      } else if (minTextController.text.isNotEmpty && maxTextController.text.isNotEmpty) {
        state.amountTitle = '${minTextController.text} - ${maxTextController.text}';
      } else {
        state.amountTitle = Lang.buyOrderViewAmount.tr;
      }
    } else {
      state.amountTitle = Lang.buyOrderViewAmount.tr;
    }
  }

  void listener() {
    // if ((minTextController.text.isNotEmpty || maxTextController.text.isNotEmpty) && (minFocusNode.hasFocus || maxFocusNode.hasFocus)) {
    //   state.amountIndex = 0;
    // }
    state.errorText = '';
    state.amountText = amountController.text;
    if (amountController.text.isEmpty || state.collectIndex == -1 || state.bankInfo.value.id == -1) {
      state.isButtonDisable = true;
    } else {
      state.isButtonDisable = false;
    }
  }

  void resetBuyData() {
    state.collectIndex = -1;
    state.cardIndex = 0;
    state.isButtonDisable = true;
    amountController.text = '';
    state.errorText = '';
  }

  void onChooseCollect(OrderMarketInfoModel data, MapEntry<int, Collect> e) {
    state.cardIndex = 0;
    if (state.collectIndex == e.key) {
      if(getBankInfoList(data.collects[state.collectIndex].categoryId).list.isEmpty) {
        state.isButtonDisable = true;
      }
      state.collectIndex = -1;
    } else {
      state.collectIndex = e.key;
      final bankInfoList = getBankInfoList(e.value.categoryId);
      if (bankInfoList.list.isNotEmpty && e.key != -1) {
        state.bankInfo.value = bankInfoList.list[state.cardIndex];
      } else {
        state.bankInfo.value = BankInfoModel.empty();
      }
      state.bankInfo.refresh();
    }
    listener();

  }

  void onBuyCoin(OrderMarketInfoModel data) async {
    
    if (data.isDivide == 1 && double.parse(amountController.text) < double.parse(data.minAmt)) {
      state.errorText = '${Lang.buyOrderViewErrorMin.tr} ${data.minAmt}';
      return;
    }

    final max = double.parse(data.forSaleQuantity) < double.parse(data.maxAmt)
      ? data.forSaleQuantity
      : data.maxAmt;

    if (data.isDivide == 1 && double.parse(amountController.text) > double.parse(max)) {
      state.errorText = '${Lang.buyOrderViewErrorMax.tr} $max';
      return;
    }

    Get.back();
    showLoading();
    await buy(data);
    hideLoading();
  }

  void onLine() {
    state.onlineIndex = state.onlineIndex == 0 ? 1 : 0;
    state.params.update((val) {
      val!.isOnline = state.onlineIndex;
    });
  }

  void onIsRelease() {
    state.isReleaseIndex = state.isReleaseIndex == 0 ? 1 : 0;
    state.params.update((val) {
      val!.isRelease = state.isReleaseIndex;
    });
  }

  void onBanks() async {
    final result = await showCategoryAllSheet(state.categoryIndex);
    if (result != null) {
      if (result.id == -1) {
        state.categoryIndex = -1;
        state.categoryTitle = Lang.buyOrderViewBanks.tr;
        state.params.value.payCategoryId = null;
        state.params.refresh();
      } else {
        state.categoryIndex = UserController.to.categoryList.value.list.indexWhere((element) => element.id == result.id);
        state.categoryTitle = result.categoryName;
        state.params.value.payCategoryId = result.id;
        state.params.refresh();
      }
    }
  }

  Future<void> updateOrderMarketList() async {
    await state.orderMarketList.value.onRefresh(state.params.toJson());
    state.orderMarketList.refresh();
  }

  Future<void> buy(OrderMarketInfoModel data) async {
    final bankInfoList = getBankInfoList(data.collects[state.collectIndex].categoryId);

    await UserController.to.dio?.post<OrderSubInfoModel>(ApiPath.market.buy,
      onSuccess: (code, msg, result) async {
        await Get.toNamed(MyRoutes.buyOrderInfoView, arguments: result.sysOrderId);
        await data.updateForId(data.sysOrderId);
        state.orderMarketList.refresh();
        Future.delayed(MyConfig.app.timeWait).then((v) => UserController.to.updateUserInfo());
      },
      data: {
        "sysOrderId": data.sysOrderId,
        // "transPassword": MyCrypto.encryptString(value, aesKey),
        "quantity": amountController.text,
        "memberAccountCollectId": bankInfoList.list[state.cardIndex].id,
      },
      onModel: (m) => OrderSubInfoModel.fromJson(m),
    );
  }

  void onRefresh() async {
    state.params.value.page = 1;
    await state.orderMarketList.value.onRefresh(state.params.toJson());
    state.orderMarketList.refresh();
    refreshController.refreshCompleted();
    refreshController.resetNoData();
  }

  void onLoading() async {
    state.params.value.page += 1;
    final isNoData = await state.orderMarketList.value.onLoading(state.params.toJson());
    if (isNoData) {
      refreshController.loadNoData();
    } else {
      refreshController.loadComplete();
    }
    state.orderMarketList.refresh();
  }

  void onChooseCard(MapEntry<int, BankInfoModel> e) {
    Get.back();
    state.cardIndex = e.key;
    state.bankInfo.value = e.value;
    state.bankInfo.refresh();
  }

  void onAdd(CategoryInfoModel categoryInfo) async {
    Get.back();
    showBlock();
    await Future.delayed(MyConfig.app.timePageTransition);
    // final arguments = UserController.to.categoryList.value.list[state.collectIndex];
    hideBlock();
    final result = await Get.toNamed(MyRoutes.walletAddView, arguments: categoryInfo);
    if (result != null) {
      final HomeController homeController = Get.find();
      homeController.getUnReadCount();
    }
  }

  void showPublicMessageBox() {
    if (state.publicNoteList.value.list.isNotEmpty) {
      getNoticesBox(data: state.publicNoteList.value, isPublicNotice: false);
    }
  }

  Future<void> getMarqueeList() async {
    await state.marqueeList.value.updateMarket();
    state.marqueeList.refresh();
    // print(state.marqueeList.toJson());
  }

  Future<void> getPublicNoticeList() async {
    final path = ApiPath.market.getPopupNotice;
    final sharedKey = '${MyConfig.shard.isHideMarketNoticeKey}_${UserController.to.userInfo.value.user.id}';

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
}
