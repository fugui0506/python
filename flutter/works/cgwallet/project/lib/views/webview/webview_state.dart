import 'package:cgwallet/common/common.dart';
import 'package:get/get.dart';

class WebviewState {
  final _isWebView = false.obs;
  bool get isWebView => _isWebView.value;
  set isWebView(bool value) => _isWebView.value = value;

  String url = 'https://csh5.hfxg.xyz/?cert=CIQCEAUYASCoAij11aORijI.5SGw1jgA2tj88HGSI8rrA5-qjCoJiwMaIAxWBPaFMTQwlvDMtslsVJYU7u7cYbiimGLCKCSHB2XWznAa_fumAw&pty=qlfUuCMtQVg3CLrsjePP';
  String title = Lang.webViewTitle.tr;
}
