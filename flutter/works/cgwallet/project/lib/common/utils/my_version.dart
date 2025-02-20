import 'package:cgwallet/common/common.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

Future<void> checkUpdate({VoidCallback? onNext}) async {
  showLoading();
  await UserController.to.updateVersion();
  hideLoading();
  await checkVersion(isAlert: false, onNext: onNext);
}

Future<void> checkVersion({required bool isAlert, VoidCallback? onNext}) async {
  if (_isUpdateVersion(DeviceService.to.packageInfo.version, UserController.to.versionInfo.version)) {
    await MyAlert.version(onNext: onNext);
  } else {
    if (isAlert) {
      MyAlert.snackbar(Lang.versionViewSnackContent.tr);
    }
    onNext?.call();
  }
}

bool _isUpdateVersion(String locale, String service) {
  final localData = _getVersionData(locale);
  final serviceData = _getVersionData(service);

  for (int i = 0; i < 3; i++) {
    int comparison = localData[i].compareTo(serviceData[i]);
    if (comparison < 0) {
      return true;
    } else if (comparison > 0) {
      return false;
    }
  }
  return false;
}

List<int> _getVersionData(String version) {
  List<String> strList = version.split('.').map((e) => e.replaceAll(RegExp(r'\D'), '')).toList();

  List<String> newStrList = List.filled(3, '0');
  for (int i = 0; i < strList.length && i < 3; i++) {
    newStrList[i] = strList[i].isEmpty ? '0' : strList[i];
  }

  return newStrList.map(int.parse).toList();
}
