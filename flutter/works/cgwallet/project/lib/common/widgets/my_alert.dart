import 'dart:typed_data';

import 'package:cgwallet/common/common.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class MyAlert {
  static void snackbar(String msg) {
    if (Get.isSnackbarOpen) {
      return;
    }
    Get.rawSnackbar(
      messageText: Center(child: MyCard.snackbar(msg)),
      snackPosition: SnackPosition.TOP,
      borderRadius: 8,
      animationDuration: const Duration(milliseconds: 500),
      duration: const Duration(milliseconds: 2000),
      backgroundColor: Colors.transparent,
    );
  }

  static void saveImage({String? title, required String imageUrl, EdgeInsetsGeometry? padding, EdgeInsetsGeometry? margin}) async {
    final loadingBox = Center(child: MyCard(
      borderRadius: BorderRadius.circular(16),
      padding: padding ?? const EdgeInsets.all(16),
      color: Get.theme.myColors.cardBackground,
      margin: margin ?? const EdgeInsets.all(20),
      child:  ConstrainedBox(
        constraints: BoxConstraints(maxHeight: Get.height * 0.72),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          if (title != null) Text(title),
          if (title != null) const SizedBox(height: 20),
          Flexible(child: SingleChildScrollView(child: MyImage(imageUrl: imageUrl, fit: BoxFit.fitWidth, width: double.infinity))),
          const SizedBox(height: 16),
          Row(children: [
            Expanded(child: MyButton.filedLong(onPressed: () async {
              Get.back();
            }, text: Lang.close.tr, textColor: Get.theme.myColors.onButtonUnselect, color: Get.theme.myColors.buttonUnselect)),

            const SizedBox(width: 8),

            Expanded(child: MyButton.filedLong(onPressed: () async {
              Get.back();
              final imageFile = await MyCache.to.getSingleFile(imageUrl);
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
            }, text: Lang.saveImageToGallery.tr)),
          ])
        ]),
      )
    ));
    final child = Column(mainAxisAlignment: MainAxisAlignment.center, children: [loadingBox]);
    return Get.dialog(child);
  }

  static Future<Uint8List?> showAvatar(Uint8List bytes) async {
    final image = Image.memory(bytes, fit: BoxFit.cover, width: Get.width - 20 - 20 - 20 - 20, height: Get.width - 20 - 20 - 20 - 20);
    final loadingBox = Center(child: MyCard(
      borderRadius: BorderRadius.circular(20),
      padding: const EdgeInsets.all(20),
      color: Get.theme.myColors.itemCardBackground,
      margin: const EdgeInsets.all(20),
      child: Column(children: [
        MyCard.normal(child: Stack(alignment: Alignment.center, children: [
          image,
          Positioned.fill(child: Container(color: Get.theme.myColors.dark.withOpacity( 0.4))),
          MyCard.avatar(radius: (Get.width - 20 - 20 - 20 - 20) / 2, child: image)
        ])),
        const SizedBox(height: 20),
        Row(children: [
          Expanded(child: MyButton.filedLong(
            color: Get.theme.myColors.buttonCancel, 
            textColor: Get.theme.myColors.onButtonCancel, 
            onPressed: () async {
              Get.back();
            }, 
            text: Lang.cancel.tr
          )),
          const SizedBox(width: 8),
          Expanded(child: MyButton.filedLong(onPressed: () async {
            Get.back(result: bytes);
          }, text: Lang.confirm.tr)),          
        ],)
      ]),
    ));
    final child = Column(mainAxisAlignment: MainAxisAlignment.center, children: [loadingBox]);
    final result = await Get.dialog<Uint8List?>(child);
    return result;
  }

  static Future<dynamic> show({
    Widget? child,
    double? margin,
    double? borderRadius,
  }) async {
    final generalDialog = Get.generalDialog<void>(
      barrierDismissible: true,
      barrierLabel: '',
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (context, animation, secondaryAnimation) {
        return SafeArea(child: Dialog(
          insetPadding: margin == null ? const EdgeInsets.all(20) : EdgeInsets.all(margin),
          backgroundColor: Theme.of(context).myColors.cardBackground,
          shape: RoundedRectangleBorder(borderRadius: borderRadius == null ? BorderRadius.circular(10) : BorderRadius.circular(borderRadius)),
          child: ClipRRect(
            borderRadius: borderRadius == null ? BorderRadius.circular(10) : BorderRadius.circular(borderRadius),
            child: MyCard.dialog(child: child),
          ),
        ));
      },
    );

    final result = await generalDialog;
    return result;
  }

  static Future<void> version({VoidCallback? onNext}) async {
    final content = Stack(children: [
      Transform.translate(offset: const Offset(0, -50), child: Column(children: [
        Get.theme.myIcons.version,
      ])),
      Material(color: Colors.transparent, child: Column(children: [
        const SizedBox(height: 120),
        Text(Lang.versionViewAlertTitle.tr, style: Get.theme.myStyles.labelPrimaryBiggest),
        const SizedBox(height: 6),
        Text(UserController.to.versionInfo.version, style: Get.theme.myStyles.label),
        const SizedBox(height: 6),
        Expanded(child: ListView(children: [
          Text(Lang.versionViewAlertContent.tr, style: Get.theme.myStyles.labelBigger),
          const SizedBox(height: 10),
          Text(UserController.to.versionInfo.content, style: Get.theme.myStyles.label),
        ])),
        const SizedBox(height: 16),
        SizedBox(width: Get.width - 40 - 40 - 40 - 40, child: MyButton.filedLong(onPressed: () {
          Get.back(result: true);
          if (GetPlatform.isAndroid) {
            launchUrl(Uri.parse(UserController.to.versionInfo.androidUrl));
          } else if (GetPlatform.isIOS) {
            launchUrl(Uri.parse(UserController.to.versionInfo.iosUrl));
          }
        }, text: Lang.versionViewAlertNow.tr)),
        if(UserController.to.versionInfo.force == 0)
          SizedBox(width: Get.width - 40 - 40 - 40 - 40, child: MyButton.filedLong(onPressed: () => Get.back(), text: Lang.versionViewAlertLater.tr, color: Get.theme.myColors.itemCardBackground, textColor: Get.theme.myColors.onCardBackground)),
      ])),
    ],);
    final box = Center(child: Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Get.theme.myColors.cardBackground,
      ),
      padding: const EdgeInsets.fromLTRB(40, 0, 40, 20),
      margin: const EdgeInsets.all(40),
      child: SizedBox(width: double.infinity, height: Get.height * 0.6, child: content),
    ));
    final child = Column(mainAxisAlignment: MainAxisAlignment.center, children: [box]);
    final result = await Get.dialog(child);
    if (UserController.to.versionInfo.force != 0 || result != null) {
      version(onNext: onNext);
    } else {
      onNext?.call();
    }
  }

  static Future<void> version2() async {
    final content = Stack(children: [
      Transform.translate(offset: const Offset(0, -50), child: Column(children: [
        Get.theme.myIcons.version,
      ])),
      Material(color: Colors.transparent, child: Column(children: [
        const SizedBox(height: 120),
        // Text(Lang.versionViewAlertTitle.tr, style: Get.theme.myStyles.labelPrimaryBiggest),
        // const SizedBox(height: 6),
        // Text(UserController.to.versionInfo.version, style: Get.theme.myStyles.label),
        // const SizedBox(height: 6),
        Expanded(child: ListView(children: [
          Text(Lang.versionViewAlertContent.tr, style: Get.theme.myStyles.labelBigger),
          const SizedBox(height: 10),
          Obx(() {
            return Text(UserController.to.redDot.value.content, style: Get.theme.myStyles.label);
          }),
        ])),
        const SizedBox(height: 16),
        SizedBox(width: Get.width - 40 - 40 - 40 - 40, child: MyButton.filedLong(onPressed: () {
          Get.back(result: true);
        }, text: Lang.iKnown.tr)),
        // if(UserController.to.versionInfo.force == 0)
        //   SizedBox(width: Get.width - 40 - 40 - 40 - 40, child: MyButton.filedLong(onPressed: () => Get.back(), text: Lang.versionViewAlertLater.tr, color: Get.theme.myColors.itemCardBackground, textColor: Get.theme.myColors.onCardBackground)),
      ])),
    ],);
    final box = Center(child: Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Get.theme.myColors.cardBackground,
      ),
      padding: const EdgeInsets.fromLTRB(40, 0, 40, 20),
      margin: const EdgeInsets.all(40),
      child: SizedBox(width: double.infinity, height: Get.height * 0.6, child: content),
    ));
    final child = Column(mainAxisAlignment: MainAxisAlignment.center, children: [box]);
    await Get.dialog(child);
  }

  static Future<dynamic> dialog({
    String? title,
    String? content,
    String? confirmText,
    String? cancelText,
    void Function()? onConfirm,
    void Function()? onCancel,
    bool showCancelButton = true,
    bool showConfirmButton = true,
    bool isDismissible = true,
  }) async {
    final generalDialog = await Get.generalDialog(
      barrierDismissible: isDismissible,
      barrierLabel: '',
      transitionDuration: const  Duration(milliseconds: 300),
      pageBuilder: (context, animation, secondaryAnimation) {
        final singleButton = MyButton.filedLong(
          onPressed: () {
            Get.back(result: true);
            showCancelButton ? onCancel?.call() : onConfirm?.call();
          }, 
          text: showCancelButton ? cancelText ?? Lang.confirm.tr : confirmText ?? Lang.confirm.tr, 
          textColor: Theme.of(context).myColors.onPrimary,
        );

        Widget confirmButton = MyButton.filedLong(
          onPressed: () {
            Get.back(result: true);
            onConfirm?.call();
          }, 
          text: confirmText ?? Lang.confirm.tr, 
          textColor: Theme.of(context).myColors.onPrimary
        );

        final cancelButton = MyButton.filedLong(
          onPressed: () {
            Get.back(result: true);
            onCancel?.call();
          }, 
          text: cancelText ?? Lang.cancel.tr, 
          color: Theme.of(context).myColors.buttonCancel,
          textColor: Theme.of(context).myColors.onButtonCancel,
        );
        
        return Dialog(
          backgroundColor: Theme.of(context).myColors.cardBackground,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: ConstrainedBox(
            constraints: BoxConstraints(maxHeight: Get.height * 0.72),
            child: MyCard.dialog(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (title != null)
                    Text(title, style: Theme.of(context).myStyles.appBarTitle),
                  if (content != null)
                    const SizedBox(height: 20),
                  if (content != null)
                    Flexible(child: SingleChildScrollView(child: ConstrainedBox(constraints: const BoxConstraints(minHeight: 60), child: Center(child: Text(content, style: Theme.of(context).myStyles.content, textAlign: TextAlign.center))))),
                  const SizedBox(height: 20),
                  if (showCancelButton || showConfirmButton)
                    (showCancelButton && !showConfirmButton) || (!showCancelButton && showConfirmButton)
                      ? singleButton
                      : Row(children: [Expanded(child: cancelButton), const SizedBox(width: 10), Expanded(child: confirmButton)]),
                ],
              ),
            ),
          ),
        );
      },
    );

    if (!isDismissible && generalDialog == null) {
      await dialog(
        title: title,
        content: content,
        confirmText: confirmText,
        cancelText: cancelText,
        onConfirm: onConfirm,
        onCancel: onCancel,
        isDismissible: isDismissible,
        showCancelButton: showCancelButton,
        showConfirmButton: showConfirmButton,
      );
      return;
    } 
  }

  static Future<dynamic> bottomSheet({
    required Widget child,
    EdgeInsetsGeometry? padding,
    bool isFullScreen = false,
  }) async {
    final disMissButton = MyButton.widget(onPressed: () {
      if (Get.isBottomSheetOpen != null && Get.isBottomSheetOpen!) {
        Get.back();
      }
    }, child: Container(
      color: Get.theme.myColors.background.withOpacity( 0), 
      width: double.infinity, 
      height: double.infinity,
    ));

    // final content = Column(
    //   mainAxisAlignment: MainAxisAlignment.end,
    //   children: [
    //     const SafeArea(child: SizedBox(height: 32)),
    //     Flexible(child: MyCard.bottomSheet(padding: padding, child: IntrinsicHeight(child: child)))
    //   ]
    // );

    final content = MyCard.bottomSheet(
      padding: padding,
      child: IntrinsicHeight(child: child)
    );


    final bottomSheet = Stack(alignment: Alignment.bottomCenter, children: [disMissButton, content]);
    return Get.bottomSheet(bottomSheet,
      isScrollControlled: true,
    );
  }
}