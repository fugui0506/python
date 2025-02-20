import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'common/common.dart';

void main() async {
  await init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      // onGenerateRoute: MyPages.onGenerateRoute,
      initialRoute: MyRoutes.indexView,
      title: 'CGpay',
      theme: MyTheme.light,
      darkTheme: MyTheme.dark,
      themeMode: ThemeMode.light,
      locale: Get.deviceLocale,
      fallbackLocale: MyLang.fallbackLocale,
      localizationsDelegates: MyLang.localizationsDelegates,
      supportedLocales: MyLang.supportedLocales,
      debugShowCheckedModeBanner: false,
      translations: MyLang(),
      defaultTransition: Transition.rightToLeftWithFade,
      getPages: MyPages.getPages,
      popGesture: true,
      transitionDuration: MyConfig.app.timePageTransition,
      unknownRoute: MyPages.unknownRoute,
      builder: (context, child) => MyMaterialBuilder(child: child!),
    );
  }
}
