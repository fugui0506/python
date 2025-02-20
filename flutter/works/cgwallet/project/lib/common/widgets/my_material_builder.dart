import 'package:cgwallet/common/common.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void showBlock() {
  _isShowBlock.value = true;
}

void showLoading() {
  _isShowLoading.value = true;
}

void hideLoading() {
  _isShowLoading.value = false;
}

void hideBlock() {
  _isShowBlock.value = false;
}

final _isShowLoading = false.obs;
final _isShowBlock = false.obs;

class MyMaterialBuilder extends StatelessWidget {
  const MyMaterialBuilder({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {

    final loadingIcon = Center(child: SizedBox(width: 20, height: 20, child: CupertinoActivityIndicator(color: Theme.of(context).myColors.onPrimary, radius: 12)));
    final loadingBox = Center(child: MyCard(
      color: Theme.of(context).myColors.dark.withOpacity( 0.1),
      width: 60,
      height: 60,
      borderRadius: BorderRadius.circular(10),
      child: loadingIcon,
    ));
    final loading = Container(width: double.infinity, height: double.infinity, color: Theme.of(context).myColors.dark.withOpacity( 0.3), child: MyCard.loading(child: loadingBox));

    final block = Container(color: Theme.of(context).myColors.dark.withOpacity( 0.1));

    return Stack(children: [
      child,
      Obx(() => _isShowLoading.value ? loading: const SizedBox()),
      Obx(() => _isShowBlock.value ? block : const SizedBox()),
    ]);
  }
}