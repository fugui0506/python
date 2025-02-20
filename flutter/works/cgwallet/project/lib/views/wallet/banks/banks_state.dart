import 'package:cgwallet/common/common.dart';
import 'package:get/get.dart';

class BanksState {
  final bankNameMapList = BankNameMapListModel.empty().obs;

  // 搜索结果
  var currtent = <BankNameModel>[].obs;

  final _isSearch = false.obs;
  bool get isSearch => _isSearch.value;
  set isSearch(bool value) => _isSearch.value = value;

  final _isLoading = true.obs;
  bool get isLoading => _isLoading.value;
  set isLoading(bool value) => _isLoading.value = value;
}
