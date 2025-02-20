import 'dart:async';
import 'package:cgwallet/common/common.dart';
import 'package:cgwallet/views/frame/home/index.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import 'index.dart';

class ScanController extends GetxController {
  final state = ScanState();
  final MobileScannerController mobileScannerController = MobileScannerController();


  @override
  void onReady() async {
    super.onReady();
    await Future.delayed(MyConfig.app.timePageTransition);
  }

  void onDetect(BarcodeCapture barcodeCapture) async {
    MyLogger.w(barcodeCapture.barcodes.first.displayValue);
    await commonCode(barcodeCapture.barcodes.first.displayValue);
  }

  Future<void> commonCode(String? code) async {
    if (code != null) {
      if (code.contains(MyConfig.key.qrcodeKey)) {
        final codeList = code.split(';');
        if (codeList[1] == '1') {
          Get.offNamed(MyRoutes.transferCoinView, arguments: codeList[2]);
        } else  if(codeList[1] == '2') {
          Get.offNamed(MyRoutes.payView, arguments: codeList);
        }
      } else {
        await Future.delayed(MyConfig.app.timePageTransition);
        MyAlert.snackbar('${Lang.scanViewResult.tr} $code');
      }
    } else {
      MyAlert.snackbar(Lang.scanViewMessage.tr);
    }
  }

  void goQrcodeView() {
    final homeController = Get.find<HomeController>();
    homeController.goQrcodeView();
  }

  void onScan(BuildContext context) async {
    final ImagePicker picker = ImagePicker();

    final XFile? image = await picker.pickImage(
      source: ImageSource.gallery,
    );

    if (image == null) {
      return;
    }

    final BarcodeCapture? barcodeCapture = await mobileScannerController.analyzeImage(
      image.path,
    );

    if (!context.mounted) {
      return;
    }

    await Future.delayed(MyConfig.app.timePageTransition);

    if (barcodeCapture != null && barcodeCapture.barcodes.first.displayValue != null) {
      MyLogger.w('插件扫描成功：${barcodeCapture.barcodes.first.displayValue}');
      onDetect(barcodeCapture);
    } else {
      MyLogger.w('插件未扫描到任何结果...');
      await decodeQRCode(image.path, callBack: (v) {
        MyLogger.w('原生扫描结果：$v', isNewline: false);
        commonCode(v);
      });
    }
  }

  // 识别图片中的二维码
  Future<void> decodeQRCode(
    String filePath, {
    Function(String? result)? callBack,
  }) async {
    try {
      final String result = await MyConfig.channel.channelImage.invokeMethod('decodeQRCode', {"path": filePath});
      MyLogger.w('Decoded QR Code: $result');
      callBack?.call(result);
    } catch (e) {
      callBack?.call(null);
    }
  }
}


