import 'package:cgwallet/common/common.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';

class MyShared extends GetxService {
  static final MyShared _instance = MyShared._privateConstructor();
  MyShared._privateConstructor();
  static MyShared get to => _instance;

  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();
  final teskQueue = MyTaskQueue();

  void set (String key, String value) async {
    teskQueue.addTask(() async => _set(key, value));
  }
  
  // 存储数据
  Future<void> _set(String key, String value) async {
    await delete(key);
    await Future.delayed(MyConfig.app.timePageTransition);
    await _secureStorage.write(
      key: key, 
      value: value.encryptChun(MyConfig.key.aesKey),
      iOptions: const IOSOptions(synchronizable: false),
    );
  }

  // 读取数据
  Future<String> get(String key) async {
    String? value = await _secureStorage.read(key: key);
    return value == null || value.isEmpty ? '' : value.decryptChun(MyConfig.key.aesKey);
  }

  /// 删除
  Future<void> delete(String key) async {
    await _secureStorage.delete(key: key);
  }

  /// 删除
  Future<void> deleteAll() async {
    await _secureStorage.deleteAll();
  }
}
