import 'package:cgwallet/common/common.dart';
import 'package:cgwallet/views/views.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class FaceVerifiedView extends GetView<FaceVerifiedController> {
  const FaceVerifiedView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar.normal(title: controller.state.title, actions: [customerButton()]),
      backgroundColor: Theme.of(context).myColors.background,
      body: const FaceVerifiedStatefulView(),
    );
  }
}

