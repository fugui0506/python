import 'package:cgwallet/common/common.dart';
import 'package:get/get.dart';

class RealNameVerifiedState {
  final title = Lang.realNameViewTitle.tr;

  // final _pageIndex = 0.obs;
  // int get pageIndex => _pageIndex.value;
  // set pageIndex(int value) => _pageIndex.value = value;

  final _isDisableButtonNext = true.obs;
  bool get isDisableButtonNext => _isDisableButtonNext.value;
  set isDisableButtonNext(bool value) => _isDisableButtonNext.value = value;

  final _isDisableButtonConfirm = true.obs;
  bool get isDisableButtonConfirm => _isDisableButtonConfirm.value;
  set isDisableButtonConfirm(bool value) => _isDisableButtonConfirm.value = value;

  final idFront = <int>[].obs;
  final idback = <int>[].obs;

}
