import 'dart:typed_data';

import 'package:cgwallet/common/common.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'dart:ui' as ui;

import 'index.dart';

class QrcodeController extends GetxController {
  final state = QrcodeState();

  GlobalKey repaintKey = GlobalKey();


  @override
  void onReady() async {
    super.onReady();
    await Future.delayed(MyConfig.app.timePageTransition);
  }

  Future<void> saveQrcode() async {
    state.isButtonDisable = true;
    try {
      RenderRepaintBoundary boundary = repaintKey.currentContext?.findRenderObject() as RenderRepaintBoundary;
      ui.Image image = await boundary.toImage();
      ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      if (byteData == null) {
        return;
      }
      Uint8List pngBytes = byteData.buffer.asUint8List();
      final imageFile = await MyGallery.to.saveImageToTemp(pngBytes);
      if (imageFile != null) {
        final isSave = await MyGallery.to.saveImageToGallery(imageFile);
        if (isSave) {
          MyAlert.snackbar(Lang.saveImageToGallerySuccess.tr);
        } else {
          MyAlert.snackbar(Lang.saveImageToGalleryFailed.tr);
        }
      } else {
        MyAlert.snackbar(Lang.saveImageToGalleryFailed.tr);
      }
    } catch (e) {
      MyAlert.snackbar(Lang.saveImageToGalleryFailed.tr);
    }
    await Future.delayed(MyConfig.app.timeWait);
    state.isButtonDisable = false;
  }
      
}
