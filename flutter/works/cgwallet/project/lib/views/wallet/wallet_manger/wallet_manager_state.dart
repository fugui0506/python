import 'package:cgwallet/common/common.dart';
import 'package:get/get.dart';

class WalletMangerState {
  final title = Lang.walletManagerViewTitle.tr;


  final _isLoading = true.obs;
  bool get isLoading => _isLoading.value;
  set isLoading(bool value) => _isLoading.value = value;

  final _index = 0.obs;
  int get index => _index.value;
  set index(int value) => _index.value = value;

  final _refreshTimes = 0.obs;
  int get refreshTimes => _refreshTimes.value;
  set refreshTimes(int value) => _refreshTimes.value = value;

  // 保存所有监听器的引用
  List<List<void Function()>> listeners = [];
}
