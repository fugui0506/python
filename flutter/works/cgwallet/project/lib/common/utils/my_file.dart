import 'dart:io';

import 'package:cgwallet/common/common.dart';

class MyFile {
  static final MyFile _instance = MyFile._privateConstructor();
  MyFile._privateConstructor();
  static MyFile get to => _instance;

   Future<void> deleteFile(File file) async {
    // 删除选取的图片文件
    try {
      await file.delete();
      MyLogger.w('临时文件删除成功 --> (${file.path})');
    } catch (e) {
      // 打印删除文件时的错误信息
      MyLogger.w('临时文件删除失败 --> (${file.path}) --> $e');
    }
  }
}