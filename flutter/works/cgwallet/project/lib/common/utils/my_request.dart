import 'package:permission_handler/permission_handler.dart';

class MyRequest {
  static final MyRequest _instance = MyRequest._privateConstructor();
  MyRequest._privateConstructor();
  static MyRequest get to => _instance;

  // 请求外部储存的读取和写入权限
  Future<bool> requestStoragePermission() async {
    var status = await Permission.storage.status;
    if (!status.isGranted) {
      var result = await Permission.storage.request();
      return result == PermissionStatus.granted ? true : false;
    }
    return true;
  }

  // 请求相册的权限
  Future<bool> requestPhotosPermission() async {
    var status = await Permission.photos.status;
    if (!status.isGranted) {
      var result = await Permission.photos.request();
      return result == PermissionStatus.granted ? true : false;
    }
    return true;
  }

  // 请求相机的权限
  Future<bool> requestCameraPermission() async {
    var status = await Permission.camera.status;
    if (!status.isGranted) {
      var result = await Permission.camera.request();
      return result == PermissionStatus.granted ? true : false;
    }
    return true;
  }
}