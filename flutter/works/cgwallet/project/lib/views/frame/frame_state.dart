import 'package:cgwallet/common/common.dart';
import 'package:get/get.dart';



class FrameState {
  final _pageIndex = 0.obs;
  set pageIndex(int value) => _pageIndex.value = value;
  int get pageIndex => _pageIndex.value;

  final noticeRead = NoticeReadModel.empty().obs;
}
