import 'package:cgwallet/common/common.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

Widget get noDataWidget => Column(
  crossAxisAlignment: CrossAxisAlignment.center, 
  children: [
    const SizedBox(height: 40, width: double.infinity),
    Get.theme.myIcons.noData,
    const SizedBox(height: 10),
    Text(Lang.noData.tr, style: Get.theme.myStyles.labelSmall),
  ]
);

Widget get closeWidget => MyCard.avatar(
  radius: 14, 
  color: Get.theme.myColors.cardBackground, 
  child: MyButton.icon(onPressed: () => Get.back(), 
  icon: Get.theme.myIcons.close)
);

Widget get loadingWidget => Column(
  crossAxisAlignment: CrossAxisAlignment.center, 
  children: [
    const SizedBox(height: 20, width: double.infinity),
    Get.theme.myIcons.loadingIcon
  ]
);

Widget get online => Row(children: [
  MyCard.avatar(radius: 4, color: Get.theme.myColors.secondary),
  const SizedBox(width: 4),
  Text(Lang.online.tr, style: Get.theme.myStyles.labelGreen)
]);

Widget get offline => Row(children: [
  MyCard.avatar(radius: 4, color: Get.theme.myColors.buttonDisable),
  const SizedBox(width: 4),
  Text(Lang.offline.tr, style: Get.theme.myStyles.offline)
]);

Widget get orderSplit => MyCard(
  borderRadius: BorderRadius.circular(4),
  color: Get.theme.myColors.primary.withOpacity( 0.2),
  padding: const EdgeInsets.symmetric(vertical: 1, horizontal: 4),
  child: Text(Lang.orderSplit.tr, style: Get.theme.myStyles.labelPrimary),
);

Widget get orderSplitOnprimary => MyCard(
  borderRadius: BorderRadius.circular(4),
  color: Get.theme.myColors.onPrimary,
  padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 4),
  child: Text(Lang.orderSplit.tr, style: Get.theme.myStyles.labelPrimary),
);

Widget customerButton({String? sysOrderId}) => MyButton.icon(
  onPressed: () {
    Get.toNamed(MyRoutes.customerView, arguments: sysOrderId);
  }, 
  icon: Get.theme.myIcons.customer()
);
