import 'dart:io';

import 'package:cgwallet/common/common.dart';
import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

class MyGallery {
  static final MyGallery _instance = MyGallery._privateConstructor();
  MyGallery._privateConstructor();
  static MyGallery get to => _instance;

  // 从相册选择图片
  Future<XFile?> pickImage() async {
    try {
      // 请求权限
      await MyRequest.to.requestPhotosPermission();

      // 使用 ImagePicker 从相册中选择图片
      final pickedFile = await ImagePicker().pickImage(
        source: ImageSource.gallery,
        maxWidth: 1080,
        maxHeight: 1080,
        imageQuality: 30,
      );

      if (pickedFile == null) {
        MyLogger.w('没有获取到图片...');
      } else {
        MyLogger.w('图片获取成功: --> (${pickedFile.path})');
      }

      return pickedFile;
    } catch (e) {
      MyLogger.w('获取图片失败...');
      return null;
    }
  }

  // 从相册选择视频
  Future<XFile?> pickVideo() async {
    try {
      // 请求权限
      await MyRequest.to.requestPhotosPermission();

      // 使用 ImagePicker 从相册中选择图片
      final pickedFile = await ImagePicker().pickVideo(
        source: ImageSource.gallery,
        maxDuration: const Duration(seconds: 30),
      );

      if (pickedFile == null) {
        MyLogger.w('没有获取到视频...');
      } else {
        MyLogger.w('视频获取成功: --> (${pickedFile.path})');
      }

      return pickedFile;
    } catch (e) {
      MyLogger.w('获取视频失败...');
      return null;
    }
  }

  // 从相册选择视频
  Future<XFile?> pickMedia() async {
    try {
      // 请求权限
      await MyRequest.to.requestPhotosPermission();

      // 使用 ImagePicker 从相册中选择图片
      final pickedFile = await ImagePicker().pickMedia(
        maxWidth: 1080,
        maxHeight: 1080,
        imageQuality: 30,
      );

      if (pickedFile == null) {
        MyLogger.w('没有获取到媒体...');
      } else {
        MyLogger.w('媒体获取成功: --> (${pickedFile.path})');
      }

      return pickedFile;
    } catch (e) {
      MyLogger.w('获取媒体失败...');
      return null;
    }
  }

  // 拍照
  Future<XFile?> cameraImage() async {
    try {
      await MyRequest.to.requestCameraPermission();
      final pickedFile = await ImagePicker().pickImage(
        source: ImageSource.camera,
        maxWidth: 1080,
        maxHeight: 1080,
        imageQuality: 30,
      );

      if (pickedFile == null) {
        MyLogger.w('没有获取到图片...');
      } else {
        MyLogger.w('图片获取成功: --> (${pickedFile.path})');
      }

      return pickedFile;
    } catch (e) {
      MyLogger.w('获取图片失败...');
      return null;
    }
  }

  // 拍视频
  Future<XFile?> cameraVideo() async {
    try {
      await MyRequest.to.requestCameraPermission();

      final pickedFile = await ImagePicker().pickVideo(
        source: ImageSource.camera,
        preferredCameraDevice: CameraDevice.rear,
        maxDuration: const Duration(seconds: 10),
      );

      if (pickedFile == null) {
        MyLogger.w('没有获取到视频...');
      } else {
        MyLogger.w('视频获取成功: --> (${pickedFile.path})');
      }

      return pickedFile;
    } catch (e) {
      MyLogger.w('获取视频失败...');
      return null;
    }
  }

  /// 将图片临时储存
  Future<File?> saveImageToTemp(List<int> bytes) async {
    try {
      bool permissionGranted = await MyRequest.to.requestStoragePermission();
      if (!permissionGranted) {
        throw Exception("Storage permission denied");
      }

      // 获取存储目录
      Directory? extDir = await getApplicationDocumentsDirectory();

      // 创建保存图片的目录
      String directoryPath = extDir.path;

      // 将图片数据写入文件
      File imageFile = File('$directoryPath/${DateTime.now().microsecondsSinceEpoch}.png');
      
      await imageFile.writeAsBytes(bytes);
      MyLogger.w('文件储存成功 --> ${imageFile.path}');
      return imageFile;
    } catch (e) {
      MyLogger.w('文件储存失败');
      return null;
    }
  }

  /// 将图片保存至相册
  Future<bool> saveImageToGallery(File imageFile) async {
    try {
      bool permissionGranted = await MyRequest.to.requestStoragePermission();
      if (!permissionGranted) {
        throw Exception("Storage permission denied");
      }

      final result = await MyConfig.channel.channelImage.invokeMethod('saveImageToGallery', {
        'path': imageFile.path,
      });

      if (result == true) {
        MyLogger.w('图片保存: $result');
        return true;
      }

      return false;
    } catch (e) {
      MyLogger.w('图片保存出错 --> $e');
      return false;
    }
  }

  // 选取文件
  Future<FilePickerResult?> pickFile() async {
    try {
      // 请求权限
      await MyRequest.to.requestStoragePermission();

      // 使用 ImagePicker 从相册中选择图片
      final pickedFile = await FilePicker.platform.pickFiles(
        allowMultiple: true,
        type: FileType.custom,
        allowedExtensions: ['jpg', 'png', 'gif', 'pdf', 'docx', 'xlsx'],
      );

      if (pickedFile == null) {
        MyLogger.w('没有获取到文件...');
      } else {
        MyLogger.w('图片获取成功: --> (${pickedFile.files.first.path})');
      }

      return pickedFile;
    } catch (e) {
      MyLogger.w('获取文件失败...');
      return null;
    }
  }
}