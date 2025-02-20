import 'package:cgwallet/common/common.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'index.dart';

class VersionView extends GetView<VersionController> {
  const VersionView({super.key});

  @override
  Widget build(BuildContext context) {
    /// appbar
    var appBar = MyAppBar.normal(
      title: controller.state.title,
    );

    /// 页面构成
    return Scaffold(
      appBar: appBar,
      backgroundColor: Theme.of(context).myColors.background,
      body: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    final column = Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
      const SizedBox(height: 32),
      Theme.of(context).myIcons.logo,
      const SizedBox(width: double.infinity, height: 10),
      Text('${Lang.versionViewVersion.tr} ${DeviceService.to.packageInfo.version}'),
      const SizedBox(height: 32),
      Obx(() => MyButton.filedShort(onPressed: controller.state.isButtonDisable ? null : controller.getVersion, text: Lang.versionViewCheck.tr)),
      const Spacer(),
      Text(Lang.versionViewBottom.tr, style: Theme.of(context).myStyles.labelSmall),
      const SizedBox(height: 16),
    ]);

    return SafeArea(child: column);
  }
}
