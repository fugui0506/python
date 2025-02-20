import 'package:cgwallet/common/common.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';



Future<void> init() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 导入全局控制器
  // DeviceService 设备相关的服务
  await Get.put(DeviceService()).initComplete;
  
  // 导入用户控制器
  // user: 用户控制器
  await Get.put(UserController()).initComplete;
}
