import 'dart:ui';

import 'package:cgwallet/common/common.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';



part 'lang_keys.dart';
part "key_en.dart";
part 'key_zh.dart';

class MyLang extends Translations {
  static const defaultLocale = Locale('zh', 'Hans_CN');
  static const fallbackLocale = Locale('zh', 'Hans_CN');

  static const localizationsDelegates = [
    GlobalMaterialLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
  ];

  static const supportedLocales = [
    Locale('zh', 'Hans_CN'), // 中文简体
    Locale('en', 'US'), // 美国英语
  ];

  final _keys = {
    'zh_Hans_CN': zh,
    'en_US': en,
  };

  @override
  Map<String, Map<String, String>> get keys => _keys;

  /// 更改语言
  static Future<void> updateLocale(String localeString, bool save) async {
    late Locale locale;

    if (localeString.startsWith('zh')) {
      locale = const Locale('zh');
      DeviceService.to.locale.value = locale;
      DeviceService.to.localeName.value = Lang.languageChinese.tr;
    } else if (localeString.startsWith('en')) {
      locale = const Locale('en');
      DeviceService.to.locale.value = locale;
      DeviceService.to.localeName.value = Lang.languageEnglish.tr;
    } else {
      locale = defaultLocale;
      DeviceService.to.locale.value = locale;
      DeviceService.to.localeName.value = Lang.languageChinese.tr;
    }

    await Get.updateLocale(locale);

    if (save) MyShared.to.set(MyConfig.shard.localKey, localeString);

    MyLogger.w('当前APP语言：${Get.locale}');
    MyLogger.w('当前系统语言：${Get.deviceLocale}', isNewline: false);
  }

  static Future<void> systemLocale() async {
    DeviceService.to.locale.value = Get.deviceLocale ?? defaultLocale;
    await updateLocale('${DeviceService.to.locale.value}', false);
    await MyShared.to.delete(MyConfig.shard.localKey);
  }

  // 设置语言
  static Future<void> initLocale() async {
    // String localeString = await MyShared.to.get(MyConfig.shard.localKey);
    // if (localeString.isEmpty) {
    //   DeviceService.to.locale.value = Get.deviceLocale ?? defaultLocale;
    //   await updateLocale('${DeviceService.to.locale.value}', false);
    // } else {
    //   await updateLocale(localeString, false);
    // }
    await updateLocale('zh_CN', false);
  }
}
