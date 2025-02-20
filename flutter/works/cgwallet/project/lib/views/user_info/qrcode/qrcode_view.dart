import 'package:cgwallet/common/common.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_flutter/qr_flutter.dart';


import 'index.dart';

class QrcodeView extends GetView<QrcodeController> {
  const QrcodeView({super.key});

  @override
  Widget build(BuildContext context) {
    return _buildScaffold(context);
  }

  Widget _buildScaffold(BuildContext context) {
    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      appBar: _buildAppBar(context), 
      body: _buildBody(context),
      backgroundColor: Theme.of(context).myColors.background,
    );
  }

  MyAppBar _buildAppBar(BuildContext context) {
    return MyAppBar.transparent(
      title: Lang.qrcodeViewTitle.tr,
    );
  }

  Widget _buildBody(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: Get.isDarkMode ? null : BoxDecoration(image: Theme.of(context).myIcons.qrcodeViewBackground),
      child: SafeArea(child: _buildContent(context)),
    );
  }

  Widget _buildContent(BuildContext context) {
    var data = '${MyConfig.key.qrcodeKey};1;${UserController.to.userInfo.value.walletAddress}';

    final card = MyCard(
      borderRadius: BorderRadius.circular(20),
      color: Theme.of(context).myColors.cardBackground,
      padding: const EdgeInsets.all(32),
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Column(children: [
        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          MyCard.avatar(radius: 20, child: MyImage(imageUrl: UserController.to.userInfo.value.user.avatarUrl)),
          const SizedBox(width: 16),
          Flexible(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            FittedBox(child: Text(UserController.to.userInfo.value.user.nickName, style: Theme.of(context).myStyles.labelBig)),
            FittedBox(child: Text('UID: ${UserController.to.userInfo.value.user.id}', style: Theme.of(context).myStyles.labelSmall)),
          ])),
        ]),
        const SizedBox(height: 20),
        RepaintBoundary(
          key: controller.repaintKey,
          child: Stack(alignment: Alignment.center, children: [
            QrImageView(
              data: data,
              version: QrVersions.auto,
              size: Get.width - 64 - 64,
              backgroundColor: Theme.of(context).myColors.light,
              eyeStyle: QrEyeStyle(eyeShape: QrEyeShape.square, color: Theme.of(context).myColors.dark),
              dataModuleStyle: QrDataModuleStyle(dataModuleShape: QrDataModuleShape.square, color: Theme.of(context).myColors.dark),
              gapless: false,
            ),
            MyCard.avatar(color: Theme.of(context).myColors.cardBackground, radius: 20, child: Center(child: SizedBox(height: 26, child: Theme.of(context).myIcons.logoOnly)))
          ]),
        ),
        const SizedBox(height: 20),
        SizedBox(width: Get.width - 64 - 64, child: Obx(() => controller.state.isButtonDisable ? MyButton.loading() : MyButton.filedLong(onPressed: controller.saveQrcode, text: Lang.qrcodeViewSave.tr))),
      ]),
    );

    return SingleChildScrollView(child: card);
  }
}
