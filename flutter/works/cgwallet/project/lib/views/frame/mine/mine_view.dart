import 'package:cgwallet/common/common.dart';
import 'package:cgwallet/views/views.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MineView extends StatelessWidget {
  const MineView({super.key});

  @override
  Widget build(BuildContext context) {
    /// 页面构成
    return GetBuilder<MineController>(
      init: MineController(),
      builder: (controller) => _buildScaffold(context, controller),
    );
  }

  Widget _buildScaffold(BuildContext context, MineController controller) {
    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      appBar: _buildAppBar(context, controller), 
      body: _buildBody(context, controller),
      backgroundColor: Theme.of(context).myColors.background,
    );
  }

  MyAppBar _buildAppBar(BuildContext context, MineController controller) {
    return MyAppBar.transparent();
  }

  Widget _buildBody(BuildContext context,  MineController controller) {
    return Container(
      width: double.infinity,
      height: Get.height,
      decoration: BoxDecoration(image: Theme.of(context).myIcons.mineViewBackground),
      child: _buildContent(context, controller),
    );
  }

  Widget _buildContent(BuildContext context, MineController controller) {
    final column = Column(children: [
      _buildAvatar(context, controller),
      const SizedBox(height: 8),
      _buildNickName(context, controller),
      const SizedBox(height: 2),
      _buildUid(context, controller),
      const SizedBox(height: 20),
      _buildTutorial(context, controller),
      const SizedBox(height: 10),
      _buildButtons(context, controller),
      const SizedBox(height: 10),
      _buildCommons(context, controller),
      const SizedBox(height: 10),
      _buildActivityIcons(context, controller),
      const SizedBox(height: 10),
      SizedBox(height: 58.0 + MediaQuery.of(context).padding.bottom)
    ]);
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16), 
      child: SafeArea(bottom: false, child: column));
  }

  Widget _buildActivityIcons(BuildContext context, MineController controller) {
    final redWidget = MyCard.avatar(
      radius: 5, 
      color: Get.theme.myColors.error, 
      border: Border.all(color: Get.theme.myColors.onPrimary, width: 2),
    );

    final redActivity = Obx(() => UserController.to.activityList.value.isRed 
      ? Positioned(right: 4, top: 4, child: redWidget) 
      : const SizedBox()
    );
    return Row(children: [
      Expanded(child: MyButton.widget(onPressed: controller.goActivitySignInView, child: Stack(children: [
        Theme.of(context).myIcons.tutorialSignIn,
        redActivity,
      ]))),
      const SizedBox(width: 10),
      Expanded(child: MyButton.widget(onPressed: controller.goActivityTradePriceView, child: Stack(children: [
        Theme.of(context).myIcons.tutorialTrade,
        redActivity,
      ]))),
    ]);
  }

  Widget _buildRedWidget() {
    return MyCard.avatar(
      radius: 5,
      color: Get.theme.myColors.error,
      border: Border.all(color: Get.theme.myColors.cardBackground, width: 2),
    );
  }
  
  Widget _buildCommons(BuildContext context, MineController controller) {
    return MyCard.normal(
      color: Theme.of(context).myColors.cardBackground,
      child: Column(children: [
        _buildCommonItem(context: context, icon: Theme.of(context).myIcons.mineViewNotify, title: Lang.mineViewSystemNotify.tr, onPressed: controller.goNotifyView),
        _buildCommonItem(context: context, icon: Theme.of(context).myIcons.mineViewFaq, title: Lang.mineViewFaq.tr, onPressed: controller.goFAQView),
        Obx(() {
          if (UserController.to.redDot.value.versionDot <= 0) {
            return _buildCommonItem(context: context, icon: Theme.of(context).myIcons.mineViewVersion, title: Lang.mineViewVersion.tr, content: 'V ${DeviceService.to.packageInfo.version}', onPressed: controller.goVersionView);
          }
          return Stack(alignment: AlignmentDirectional.center, children: [
            _buildCommonItem(context: context, icon: Theme.of(context).myIcons.mineViewVersion, title: Lang.mineViewVersion.tr, content: 'V ${DeviceService.to.packageInfo.version}', onPressed: controller.goVersionView),
            Positioned(right: 8, child: _buildRedWidget()),
          ]);
        }),
        _buildCommonItemRichText(context: context, icon: Theme.of(context).myIcons.mineViewFeedback, title: Lang.mineViewFeedback.trArgs([Lang.mineViewPrice.tr]), onPressed: controller.goFeedbackPriceView, richText: Lang.mineViewPrice.tr, richTextStyle: Theme.of(context).myStyles.labelRed),
        // _buildCommonItem(context: context, icon: Theme.of(context).myIcons.mineViewSettings, title: Lang.mineViewSettings.tr, onPressed: controller.goSettingsView),
      ]),
    );
  }

  Widget _buildCommonItem({
    required BuildContext context,
    required MyAssets icon,
    required String title,
    String? content,
    void Function()? onPressed,
  }) {
    return MyButton.widget(
      onPressed: onPressed,
      child: Container(color: Theme.of(context).myColors.background.withOpacity( 0), padding: const EdgeInsets.all(16), child: Row(children: [
        icon,
        const SizedBox(width: 16),
        Expanded(child: Text(title, style: Theme.of(context).myStyles.labelBig, maxLines: 1, overflow: TextOverflow.ellipsis)),
        const SizedBox(width: 16),
        if (content != null) Text(content, style: Theme.of(context).myStyles.labelSmall, maxLines: 1),
        Theme.of(context).myIcons.right,
      ])),
    );
  }

  Widget _buildCommonItemRichText({
    required BuildContext context,
    required MyAssets icon,
    required String title,
    String? content,
    void Function()? onPressed,
    required String richText,
    required TextStyle richTextStyle,
  }) {
    int startIndex = title.indexOf(richText);
    int endIndex = startIndex + richText.length;

    List<TextSpan> textSpans = [];

    if (startIndex > 0) {
      textSpans.add(
        TextSpan(text: title.substring(0, startIndex)),
      );
    }

    textSpans.add(
      TextSpan(
        text: richText,
        style: richTextStyle,
      ),
    );

    if (endIndex < title.length) {
      textSpans.add(
        TextSpan(text: title.substring(endIndex)),
      );
    }

    return MyButton.widget(
      onPressed: onPressed,
      child: Container(color: Theme.of(context).myColors.background.withOpacity( 0), padding: const EdgeInsets.all(16), child: Row(children: [
        icon,
        const SizedBox(width: 16),
        Expanded(
            child: RichText(text: TextSpan(style: Theme.of(context).myStyles.label, children: textSpans), overflow: TextOverflow.ellipsis),
        ),
        const SizedBox(width: 16),
        if (content != null) Text(content, style: Theme.of(context).myStyles.labelSmall, maxLines: 1),
        SizedBox(height: 16, child: Theme.of(context).myIcons.feedbackPrice),
        // const SizedBox(width: 8),
        Theme.of(context).myIcons.right,
      ])),
    );
  }

  Widget _buildButtons(BuildContext context, MineController controller) {
    return Row(children: [
      Expanded(child: _buildButtonItem(context, title: Lang.mineViewWalletHistory.tr, onPressed: controller.goWalletHistoryView, icon: Theme.of(context).myIcons.mineViewWalletHistory)),
      const SizedBox(width: 6),
      Expanded(child: _buildButtonItem(context, title: Lang.mineViewPromotions.tr, onPressed: controller.goPromotionListView, icon: Theme.of(context).myIcons.mineViewPromotions)),
      const SizedBox(width: 6),
      Expanded(child: _buildButtonItem(context, title: Lang.mineViewAccount.tr, onPressed: controller.goWalletManagerView, icon: Theme.of(context).myIcons.mineViewAccount)),
      const SizedBox(width: 6),
      Expanded(child: _buildButtonItem(context, title: Lang.mineViewSafe.tr, onPressed: controller.goSecurityView, icon: Theme.of(context).myIcons.mineViewSafe)),
    ]);
  }

  Widget _buildButtonItem(BuildContext context, {
    required String title,
    required void Function()? onPressed,
    Widget? icon
  }) {
    return MyButton.widget(onPressed: onPressed, child: MyCard.normal(
      padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
      child: Column(children: [
        SizedBox(height: 40, child: Center(child: icon)),
        SizedBox(height: 22, child: Center(child: Padding(padding: const EdgeInsets.fromLTRB(4, 0, 4, 0), child: Text(title, style: Theme.of(context).myStyles.label, overflow: TextOverflow.ellipsis)))),
      ]),
    ));
  }

  Widget _buildAvatar(BuildContext context, MineController controller) {
    final avatar = MyCard.avatar(radius: 36, child: Obx(() => MyImage(imageUrl: UserController.to.userInfo.value.user.avatarUrl)));
    final edit = MyCard.avatar(
      border: Border.all(color: Theme.of(context).myColors.mineViewEdit, width: 2),
      radius: 12, 
      color: Theme.of(context).myColors.light, 
      child: Center(child: SizedBox(width: 12, height: 12, child: Theme.of(context).myIcons.mineViewEdit))
    );
    return MyButton.widget(onPressed: controller.goPersonalInfoView, child: Stack(alignment: Alignment.bottomRight, children: [avatar, edit]));
  }

  Widget _buildNickName(BuildContext context, MineController controller) {
    return Obx(() => Text(UserController.to.userInfo.value.user.nickName, style: Theme.of(context).myStyles.appBarTitle));
  }

  Widget _buildUid(BuildContext context, MineController controller) {
    return Text('UID: ${UserController.to.userInfo.value.user.id}', style: Theme.of(context).myStyles.labelSmall);
  }

  Widget _buildTutorial(BuildContext context, MineController controller) {
    final left =  Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(children: [
        SizedBox(height: 32, child: Theme.of(context).myIcons.coinCgb),
        const SizedBox(width: 10),
        Text(Lang.mineViewTutorialTitle.tr, style: Theme.of(context).myStyles.mineViewTutorialTitle, overflow: TextOverflow.ellipsis)
      ]),
      const SizedBox(height: 8),
      Text(Lang.mineViewTutorialContent.tr, style: Theme.of(context).myStyles.labelSmall, overflow: TextOverflow.ellipsis)
    ]);
    final right = SizedBox(height: 90, child: Theme.of(context).myIcons.mineViewTutorial);
    return MyButton.widget(
      onPressed: controller.goTutorialView,
      child: MyCard.normal(
        padding: const EdgeInsets.fromLTRB(16, 0, 0, 0),
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Flexible(child: left), const SizedBox(width: 10), right]),
      ),
    );
  }
}
