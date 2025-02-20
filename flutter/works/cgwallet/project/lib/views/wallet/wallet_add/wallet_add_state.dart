import 'package:cgwallet/common/common.dart';
import 'package:get/get.dart';

class WalletAddState {
  final bank = BankNameModel.empty().obs;

  final _accountType = ''.obs;
  String get accountType => _accountType.value;
  set accountType(String value) => _accountType.value = value;

  final _index = 0.obs;
  int get index => _index.value;
  set index(int value) => _index.value = value;

  final _imageBytes = <int>[].obs;
  List<int> get imageBytes => _imageBytes;
  set imageBytes(List<int> value) => _imageBytes.value = value;

  final _isButtonDisable = true.obs;
  bool get isButtonDisable => _isButtonDisable.value;
  set isButtonDisable(bool value) => _isButtonDisable.value = value;

  final _isLoading = false.obs;
  bool get isLoading => _isLoading.value;
  set isLoading(bool value) => _isLoading.value = value;

  final _alipayIndex = 0.obs;
  int get alipayIndex => _alipayIndex.value;
  set alipayIndex(int value) => _alipayIndex.value = value;
}
