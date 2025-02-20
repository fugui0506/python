import 'package:cgwallet/common/common.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

Future<CategoryInfoModel?> showCategorySheet(int index) async {
  CategoryInfoModel? categoryInfo;
  categoryInfo = await MyAlert.bottomSheet(child: Column(children: UserController.to.categoryList.value.list.asMap().entries.map((e) => MyButton.widget(
    onPressed: () {
      Get.back(result: e.value);
    },
    child: MyCard.normal(
      padding: const EdgeInsets.all(16),
      margin: e.key == UserController.to.categoryList.value.list.length - 1 ? null : const EdgeInsets.only(bottom: 4),
      color: index == e.key ? Get.theme.myColors.primary : Get.theme.myColors.inputBank,
      child: Row(children: [
        MyImage(imageUrl: e.value.icon, height: 24),
        const SizedBox(width: 16),
        Text(e.value.categoryName, style: index == e.key ? Get.theme.myStyles.contentLight : Get.theme.myStyles.label),
      ]),
    ))
  ).toList()));
  return categoryInfo;
}

Future<CategoryInfoModel?> showCategoryAllSheet(int index) async {
  CategoryInfoModel? categoryInfo;

  final buttonAll = MyButton.widget(
    onPressed: () {
      Get.back(result: CategoryInfoModel.empty());
    },
    child: MyCard.normal(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(bottom: 4),
      color: index == -1 ? Get.theme.myColors.primary : Get.theme.myColors.inputBank,
      child: Row(children: [
        Icon(Icons.style, color: index == -1 ? Get.theme.myColors.onPrimary : Get.theme.myColors.textDefault.withOpacity( 0.5)),
        const SizedBox(width: 16),
        Text(Lang.buyOrderViewAll.tr, style: index == -1 ? Get.theme.myStyles.contentLight : Get.theme.myStyles.label),
      ]),
    ),
  );

  final categoryList = UserController.to.categoryList.value.list.asMap().entries.map((e) => MyButton.widget(
    onPressed: () {
      Get.back(result: e.value);
    },
    child: MyCard.normal(
      padding: const EdgeInsets.all(16),
      margin: e.key == UserController.to.categoryList.value.list.length - 1 ? null : const EdgeInsets.only(bottom: 4),
      color: index == e.key ? Get.theme.myColors.primary : Get.theme.myColors.inputBank,
      child: Row(children: [
        MyImage(imageUrl: e.value.icon, height: 24),
        const SizedBox(width: 16),
        Text(e.value.categoryName, style: index == e.key ? Get.theme.myStyles.contentLight : Get.theme.myStyles.label),
      ]),
    ))
  ).toList();

  categoryInfo = await MyAlert.bottomSheet(child: Column(children: [
    buttonAll, ...categoryList
  ]));
  return categoryInfo;
}