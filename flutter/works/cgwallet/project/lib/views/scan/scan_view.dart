import 'package:cgwallet/common/common.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
// import 'package:camera/camera.dart';


import 'index.dart';

class ScanView extends GetView<ScanController> {
  const ScanView({super.key});


  @override
  Widget build(BuildContext context) {
    final mobileScanner = MobileScanner(
      controller: controller.mobileScannerController,
      onDetect: controller.onDetect,
    );

    // final marker = Positioned.fill(
    //   child: CustomPaint(
    //     painter: HollowPainter(),
    //   ),
    // );

    final buttons = Column(
      children: [
        const Spacer(),
        SafeArea(child: Row(children: [
          const SizedBox(width: 16),
          MyButton.icon(onPressed: controller.goQrcodeView, icon: Theme.of(context).myIcons.qrcodeMy),
          const Spacer(),
          MyButton.icon(onPressed: () => controller.onScan(context), icon: Theme.of(context).myIcons.qrcodePick),
          const SizedBox(width: 16),
        ]))
      ],
    );

    return Scaffold(
      appBar: MyAppBar.white(title: Lang.scanViewTitle.tr),
      backgroundColor: Theme.of(context).myColors.background,
      extendBodyBehindAppBar: true,
      extendBody: true,
      body: Stack(children: [mobileScanner, buttons]),
    );
  }
}

// class HollowPainter extends CustomPainter {
//   @override
//   void paint(Canvas canvas, Size size) {
//     final double centerX = size.width / 2;
//     final double centerY = size.height / 2;
//     const double radius = 16;

//     final path = Path();
//     path.addRRect(RRect.fromRectAndRadius(
//       Rect.fromCenter(center: Offset(centerX, centerY), width: centerX, height: centerX),
//       const Radius.circular(radius)
//     ));

//     final maskPaint = Paint()..color = Colors.black.withOpacity( 0.8);
//     canvas.saveLayer(Rect.fromLTWH(0, 0, size.width, size.height), maskPaint);
//     canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), maskPaint);
//     canvas.drawPath(path, Paint()..blendMode = BlendMode.clear);
//     canvas.restore();
//   }

//   @override
//   bool shouldRepaint(covariant CustomPainter oldDelegate) {
//     return false;
//   }
// }