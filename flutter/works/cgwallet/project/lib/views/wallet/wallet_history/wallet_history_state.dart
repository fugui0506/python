import 'package:cgwallet/common/common.dart';
import 'package:get/get.dart';

class WalletHistoryState {
  final title = Lang.walletHistoryViewTitle.tr;

  final parmas = _Parmas.empty().obs;
  final generalTypeList = GeneralTypeListModel.empty().obs;
  final walletHistory = WalletHistoryListModel.empty().obs;

  final _dateIndex = 3.obs;
  int get dateIndex => _dateIndex.value;
  set dateIndex(int value) => _dateIndex.value = value;

  final _typeIndex = 0.obs;
  int get typeIndex => _typeIndex.value;
  set typeIndex(int value) => _typeIndex.value = value;

  final _isLoading = true.obs;
  bool get isLoading => _isLoading.value;
  set isLoading(bool value) => _isLoading.value = value;

  final _isNodata = false.obs;
  bool get isNodata => _isNodata.value;
  set isNodata(bool value) => _isNodata.value = value;
}

class _Parmas {
  int dateType;
  List<int> typeIds;

  _Parmas({
    required this.dateType,
    required this.typeIds,
  });

  factory _Parmas.empty() => _Parmas(
    dateType: 3,
    typeIds: [],
  );

  Map<String, dynamic> toJson() => {
    "dateType": dateType,
    "typeIds": List<dynamic>.from(typeIds.map((x) => x)),
  };
}