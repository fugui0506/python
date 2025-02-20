import 'package:cgwallet/common/common.dart';
import 'package:get/get.dart';

class BuyOrderState {
  final title = Lang.buyOrderViewTitle.tr;
  final params = _ParmasMarketOrdersModel.empty().obs;
  final orderMarketList = OrderMarketListModel.empty().obs;
  final bankInfo = BankInfoModel.empty().obs;
  final marqueeList = MarqueeListModel.empty().obs;

  final _amountTitle = Lang.buyOrderViewAmount.tr.obs;
  String get amountTitle => _amountTitle.value;
  set amountTitle(String value) => _amountTitle.value = value;

  final _categoryTitle = Lang.buyOrderViewBanks.tr.obs;
  String get categoryTitle => _categoryTitle.value;
  set categoryTitle(String value) => _categoryTitle.value = value;

  final _isLoading = true.obs;
  bool get isLoading => _isLoading.value;
  set isLoading(bool value) => _isLoading.value = value;

  final _amountIndex = 0.obs;
  int get amountIndex => _amountIndex.value;
  set amountIndex(int value) => _amountIndex.value = value;

  final _categoryIndex = (-1).obs;
  int get categoryIndex => _categoryIndex.value;
  set categoryIndex(int value) => _categoryIndex.value = value;

  final _onlineIndex = 1.obs;
  int get onlineIndex => _onlineIndex.value;
  set onlineIndex(int value) => _onlineIndex.value = value;

  final _isReleaseIndex = 0.obs;
  int get isReleaseIndex => _isReleaseIndex.value;
  set isReleaseIndex(int value) => _isReleaseIndex.value = value;

  final _collectIndex = (-1).obs;
  int get collectIndex => _collectIndex.value;
  set collectIndex(int value) => _collectIndex.value = value;

  final _cardIndex = 0.obs;
  int get cardIndex => _cardIndex.value;
  set cardIndex(int value) => _cardIndex.value = value;

  final _isButtonDisable = true.obs;
  bool get isButtonDisable => _isButtonDisable.value;
  set isButtonDisable(bool value) => _isButtonDisable.value = value;

  final _errorText = ''.obs;
  set errorText(String vale) => _errorText.value = vale;
  String get errorText => _errorText.value;

  final _amountText = ''.obs;
  set amountText(String vale) => _amountText.value = vale;
  String get amountText => _amountText.value;

  final publicNoteList = PublicNoteListModel.empty().obs;
}

class _ParmasMarketOrdersModel {
  int page;
  int pageSize;
  String? minQuantity;
  String? maxQuantity;
  int status;
  int? payCategoryId;
  int dateType;
  int sort;
  int isOnline;
  int isRelease;

  _ParmasMarketOrdersModel({
    required this.page,
    required this.pageSize,
    required this.minQuantity,
    required this.maxQuantity,
    required this.status,
    required this.payCategoryId,
    required this.dateType,
    required this.sort,
    required this.isOnline,
    required this.isRelease,
  });

  factory _ParmasMarketOrdersModel.empty() => _ParmasMarketOrdersModel(
    page: 1,
    pageSize: 50,
    minQuantity: '0',
    maxQuantity: '0',
    status: 0,
    payCategoryId: null,
    dateType: 3,
    sort: 0,
    isOnline: 1,
    isRelease: 0,
  );

  Map<String, dynamic> toJson() => {
    "page": page,
    "pageSize": pageSize,
    "minQuantity": minQuantity,
    "maxQuantity": maxQuantity,
    "status": status,
    "payCategoryId": payCategoryId,
    "dateType": dateType,
    "sort": sort,
    "isOnline": isOnline,
    "isRelease": isRelease,
  };
}
