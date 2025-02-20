import 'package:cgwallet/common/common.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';
// import 'package:flutter_inappwebview/flutter_inappwebview.dart';


import 'index.dart';

class WebviewView extends GetView<WebviewController> {
  const WebviewView({super.key});

  @override
  Widget build(BuildContext context) {
    /// appbar
    var appBar = MyAppBar.normal(
      title: controller.state.title,
    );

    /// 页面构成
    return Scaffold(
      appBar: appBar,
      body: Obx(() => controller.state.isWebView 
        ? SafeArea(child: WebViewWidget(controller: controller.webController))
        : Container(color: Theme.of(context).myColors.onBackground)
      ),
    );
  }
}
