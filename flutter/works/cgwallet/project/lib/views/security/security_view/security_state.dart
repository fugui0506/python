

import 'package:cgwallet/common/common.dart';
import 'package:get/get.dart';

class SecurityState {
  final title = Lang.securityViewTitle.tr;

  final _securityType = ''.obs;
  String get securityType => _securityType.value;
  set securityType(String value) => _securityType.value = value;
}
