import 'package:cgwallet/common/common.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'index.dart';

class SettingsView extends GetView<SettingsController> {
  const SettingsView({super.key});

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
      child: _buildContent(context),
    );
  }

  void onChangeLanguage() {
    var child = Column(children: [
      Obx(() => _buildItemSetting(icon: Get.theme.myIcons.langChinese, title: Lang.languageChinese.tr, onPressed: controller.onLanguageChinese, isCheck: DeviceService.to.localeName.value == Lang.languageChinese.tr)),
      Obx(() => _buildItemSetting(icon: Get.theme.myIcons.langEnglish, title: Lang.languageEnglish.tr, onPressed: controller.onLanguageEnglish, isCheck: DeviceService.to.localeName.value == Lang.languageEnglish.tr, bottom: false))
    ]);
    MyAlert.bottomSheet(child: child);
  }

  Widget _buildItemSetting({
    bool bottom = true,
    required Widget icon,
    required String title,
    void Function()? onPressed,
    bool isCheck = false,
  }) {
    final iconWidget = SizedBox(width: 24, height: 24, child: Center(child: icon));
    const spacer = SizedBox(width: 10);
    final card = MyCard.normal(
      padding: const EdgeInsets.all(16),
      color: isCheck ? Get.theme.myColors.primary.withOpacity( 0.3) : Get.theme.myColors.itemCardBackground,
      margin: bottom ? const EdgeInsets.only(bottom: 10) : null,
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Flexible(child: Row(children: [
          iconWidget,
          spacer,
          Flexible(child: Text(title, style: Get.theme.myStyles.label, overflow: TextOverflow.ellipsis))
        ])),
        spacer,
        if(isCheck) MyCard.avatar(radius: 12, color: Get.theme.myColors.primary, child: Center(child: Get.theme.myIcons.checkLight))
      ]),
    );
    return MyButton.widget(onPressed: onPressed, child: card);
  }

  void onChangeTheme() {
    var child = Column(children: [
      Obx(() => _buildItemSetting(icon: Get.theme.myIcons.themeLight, title: Lang.themeLight.tr, onPressed: controller.onThemeLight, isCheck: DeviceService.to.themeMode.value == '2')),
      Obx(() => _buildItemSetting(icon: Get.theme.myIcons.themeDark, title: Lang.themeDark.tr, onPressed: controller.onThemeDark, isCheck: DeviceService.to.themeMode.value == '1')),
      Obx(() => _buildItemSetting(icon: Get.theme.myIcons.themeSystem, title: Lang.themeSystem.tr, onPressed: controller.onThemeSystem, isCheck: DeviceService.to.themeMode.value == '0', bottom: false))
    ]);
    MyAlert.bottomSheet(child: child);
  }

  Widget _buildContent(BuildContext context) {
    return MyCard(
      color: Theme.of(context).myColors.cardBackground,
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Obx(() => _buildItemContent(context, onPressed: onChangeLanguage, icon: Theme.of(context).myIcons.language, title: Lang.settingsViewLanguage.tr, content: DeviceService.to.localeName.value)),
          Obx(() => _buildItemContent(context, onPressed: onChangeTheme, icon: Theme.of(context).myIcons.theme, title: Lang.settingsViewTheme.tr, 
            content: DeviceService.to.themeMode.value == '0' ? Lang.themeSystem.tr : DeviceService.to.themeMode.value == '1' ? Lang.themeDark.tr : Lang.themeLight.tr
          )),
          _buildItemContent(context, onChanged: controller.onAudio, icon: Theme.of(context).myIcons.audio, title: Lang.settingsViewAudioAlert.tr, isOpen: true),
          _buildItemContent(context,  onChanged: controller.onVibration, icon: Theme.of(context).myIcons.vibration, title: Lang.settingsViewShock.tr, bottom: false, isOpen: true),
        ],
      ),
    );
  }

  Widget _buildItemContent(BuildContext context, {
    bool bottom = true,
    required Widget icon,
    required String title,
    void Function()? onPressed,
    void Function(bool)? onChanged,
    bool isOpen = true,
    String? content,
  }) {
    final iconWidget = SizedBox(width: 24, height: 24, child: Center(child: icon));
    final open = isOpen.obs;
    final toggleWidget = Obx(() => Switch(
        activeColor: Theme.of(context).myColors.primary,
        value: open.value, 
        onChanged: (v) {
          open.value = v;
          onChanged?.call(v);
        },
      ));
    const spacer = SizedBox(width: 10);
    final card = MyCard.normal(
      padding: onChanged != null ? const EdgeInsets.fromLTRB(16, 8, 16, 8) : const EdgeInsets.all(16),
      color: Theme.of(context).myColors.itemCardBackground,
      margin: bottom ? const EdgeInsets.only(bottom: 10) : null,
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Flexible(child: Row(children: [
          iconWidget,
          spacer,
          Flexible(child: Text(title, style: Theme.of(context).myStyles.label, overflow: TextOverflow.ellipsis))
        ])),
        spacer,
        if(content != null) Text(content, style: Theme.of(context).myStyles.labelSmall),
        onChanged != null ? toggleWidget : Theme.of(context).myIcons.right
      ]),
    );
    return MyButton.widget(onPressed: onPressed, child: card);
  }

}
