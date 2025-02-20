// import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:cgwallet/common/common.dart';
import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'index.dart';

class WebviewController extends GetxController {
  final state = WebviewState();
  final WebViewArgumentsModel? arguments = Get.arguments;

  // InAppWebViewController? webController;
  late final WebViewController webController;

  @override
  void onInit() {
    super.onInit();
    if (arguments?.title != null) state.title = arguments!.title;
    if (arguments?.url != null) state.url = arguments!.url;
  }

  @override
  onReady() async {
    super.onReady();
    await Future.delayed(MyConfig.app.timePageTransition);
    final isUrlValid = await checkUrlIsValid(state.url);
    if (!isUrlValid) {
      return;
    }
    webController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate( NavigationDelegate(
        onPageStarted: (String url) async {
          await runJavaScript();
        },
        onPageFinished: (String url) async {
          MyLogger.w(url);
          state.isWebView = true;
        },
        onHttpError: (HttpResponseError error) {
          MyLogger.w(error);
        },
        onWebResourceError: (WebResourceError error) {
          MyLogger.w(error);
        },
      ))
    ..loadRequest(Uri.parse(state.url));
  }

  Future<void> runJavaScript() async {
    await webController.runJavaScript("""
      console.log("Checking replaceAll polyfill at onLoadStart");
      if (!String.prototype.replaceAll) {
        String.prototype.replaceAll = function(str, newStr) {
          if (typeof str === 'string' && typeof newStr === 'string') {
            return this.replace(new RegExp(str.replace(/[.*+?^\${}()|[\\]\\\\]/g, '\\\\\$&'), 'g'), newStr);
          } else {
            console.error('Invalid arguments for replaceAll');
            return this;
          }
        };
        console.log("replaceAll polyfill injected at onLoadStart");
      } else {
        console.log("replaceAll already exists at onLoadStart");
      }
    """);
  }
}
