import 'package:get/get.dart';

class PayState {
  final _payed = 0.obs;
  int get payed => _payed.value;
  set payed(int value) => _payed.value = value;

  final _seconds = 0.obs;
  int get seconds => _seconds.value;
  set seconds(int value) => _seconds.value = value;

  final _countDown = '00:00'.obs;
  String get countDown => _countDown.value;
  set countDown(String value) => _countDown.value = value;

  final data = <String>['', '', '', '', '', '', '', '', ''].obs;
}
