import 'package:cgwallet/common/common.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'index.dart';

class PersonalInfoView extends GetView<PersonalInfoController> {
  const PersonalInfoView({super.key});

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
    return SingleChildScrollView(padding: const EdgeInsets.all(16), child: Column(children: [
      _buildItem(context, title: Lang.personalInfoViewAvatar.tr, content: Obx(() => MyCard.avatar(radius: 15, child: MyImage(imageUrl: UserController.to.userInfo.value.user.avatarUrl))), onPressed: _chooiseAvatar),
      const SizedBox(height: 6),
      _buildItem(context, title: Lang.personalInfoViewNickName.tr, content: Obx(() => Text(UserController.to.userInfo.value.user.nickName, style: Theme.of(context).myStyles.label)), onPressed: controller.goEditNicknameView),
      const SizedBox(height: 6),
      _buildItem(context, title: Lang.personalInfoViewUID.tr, content: Obx(() => Text(UserController.to.userInfo.value.user.id.toString(), style: Theme.of(context).myStyles.labelSmall))),
      const SizedBox(height: 6),
      _buildItem(context, title: Lang.personalInfoViewLastLoginTime.tr, content: Obx(() => Text(UserController.to.userInfo.value.user.lastAt, style: Theme.of(context).myStyles.labelSmall))),
      const SizedBox(height: 6),
      _buildItem(context, title: Lang.personalInfoViewLastLoginIP.tr, content: Obx(() => Text(UserController.to.userInfo.value.user.lastIp, style: Theme.of(context).myStyles.labelSmall))),
      const SizedBox(height: 20),
      _buildLogoutButton(context),
    ]));
  }

  void _logout() {
    MyAlert.dialog(
      title: Lang.personalInfoViewLogout.tr,
      content: Lang.personalInfoViewLogoutAlert.tr,
      onConfirm: controller.onLogout
    );
  }

  void _chooiseAvatar() {
    controller.state.avatarIndex = -1;
    MyAlert.bottomSheet(
      padding: EdgeInsets.zero,
      child: Padding(padding: const EdgeInsets.all(32), child: Column(
        crossAxisAlignment: CrossAxisAlignment.center, 
        children: [
          Text(Lang.personalInfoViewAvatarTitle.tr, style: Get.theme.myStyles.labelBigger),
          const SizedBox(width: double.infinity, height: 20),
          _buildAvatar(),
          const SizedBox(width: double.infinity, height: 32),
          _buildButtons(),
        ]
      ))
    );
  }

  Widget _buildButtons() {
    return Row(children: [
      Expanded(child: MyButton.filedLong(onPressed: controller.onPickAvatar, text: Lang.album.tr, color: Get.theme.myColors.secondary)),
      const SizedBox(width: 16),
      Expanded(child: Obx(() => MyButton.filedLong(onPressed: controller.state.avatarIndex == -1 ? null :  controller.onSaveAvatar, text: Lang.save.tr))),
    ]);
  }

  Widget _buildAvatar() {
    const spacing = 10.0;
    const runSpacing = 10.0;
    double radius = ((Get.width - 64) - 5 * spacing) / 6 / 2;
    return Obx(() => Wrap(
      spacing: spacing,
      runSpacing: runSpacing,
      children: controller.state.avatarList.value.list.isEmpty 
        ? List.filled(18, 0).map((e) => MyCard.avatar(radius: radius, child: Get.theme.myIcons.loadingIcon)).toList()
        : controller.state.avatarList.value.list.asMap().entries.map((e) => Obx(() => MyButton.widget(
          onPressed: controller.state.avatarIndex == e.key ? null : () => controller.state.avatarIndex = e.key, 
          child: MyCard.avatar(
            border: controller.state.avatarIndex == e.key ? Border.all(color: Get.theme.myColors.light, width: 2) : null,
            radius: radius, 
            boxShadow: controller.state.avatarIndex == e.key ? [BoxShadow(color: Get.theme.myColors.primary, blurRadius: 12, spreadRadius: 2)] : null,
            child: MyImage(imageUrl: e.value.avatarUrl, key: ValueKey(e.value.avatarUrl)) 
          ),
        ))).toList(),
    ));
  }

  Widget _buildLogoutButton(BuildContext context) {
    return MyButton.filedLong(
      onPressed: _logout,
      text: Lang.personalInfoViewLogout.tr,
    );
  }

  Widget _buildItem(BuildContext context, {
    required String title,
    void Function()? onPressed,
    required Widget content,
  }) {
    final left = Flexible(child: Text(title, style: Theme.of(context).myStyles.labelSmall, overflow: TextOverflow.ellipsis));
    final right = Row(children: [content, Theme.of(context).myIcons.right]);
    return MyButton.widget(onPressed: onPressed, child: MyCard.normal(
      color: Theme.of(context).myColors.cardBackground,
      padding: const EdgeInsets.all(16),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        left, const SizedBox(width: 16), onPressed == null ? content : right
      ]),
    ));
  }
}
