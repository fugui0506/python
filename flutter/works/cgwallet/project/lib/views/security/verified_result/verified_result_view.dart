import 'package:cgwallet/common/common.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'index.dart';

class VerifiedResultView extends GetView<VerifiedResultController> {
  const VerifiedResultView({super.key});

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
    return SingleChildScrollView(
      padding: const EdgeInsets.all(32),
      child: Column(children: [
        const SizedBox(height: 16),
        controller.state.isPass ? Theme.of(context).myIcons.success : Theme.of(context).myIcons.failed,
        const SizedBox(height: 10),
        controller.state.isPass 
          ? Text(Lang.verifiedResultViewSuccessful.tr, style: Theme.of(context).myStyles.labelGreenBigger)
          : Text(Lang.verifiedResultViewFailed.tr, style: Theme.of(context).myStyles.labelRedBigger),
        const SizedBox(height: 32),
        controller.state.isPass 
          ? MyButton.filedLong(onPressed: () => Get.back(), text: Lang.verifiedResultViewBack.tr)
          : MyButton.filedLong(onPressed: () => Get.back(), text: Lang.verifiedResultViewAgain.tr),
      ]),
    );
  }
    
}
