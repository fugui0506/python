part of 'theme.dart';
class MyIcons {
  MyIcons({required this.myColors});
  final MyColors myColors;

  MyAssets get inputCode => MyAssets(name: 'input_code', style: MyAssetStyle.svg, color: myColors.inputPrefixIcon);
  MyAssets get inputFundPassword => MyAssets(name: 'input_fund_password', style: MyAssetStyle.svg, color: myColors.inputPrefixIcon);
  MyAssets get inputHide => MyAssets(name: 'input_hide', style: MyAssetStyle.svg, color: myColors.inputSuffixIcon);
  MyAssets get inputPassword => MyAssets(name: 'input_password', style: MyAssetStyle.svg, color: myColors.inputPrefixIcon);
  MyAssets get inputPerson => MyAssets(name: 'input_person', style: MyAssetStyle.svg, color: myColors.inputPrefixIcon);
  MyAssets get inputPhoneCode => MyAssets(name: 'input_phone_code', style: MyAssetStyle.svg, color: myColors.inputPrefixIcon);
  MyAssets get inputPhone => MyAssets(name: 'input_phone', style: MyAssetStyle.svg, color: myColors.inputPrefixIcon);
  MyAssets get inputShow => MyAssets(name: 'input_show', style: MyAssetStyle.svg, color: myColors.inputSuffixIcon);
  MyAssets get inputClear => MyAssets(name: 'input_clear', style: MyAssetStyle.svg, color: myColors.inputSuffixIcon);
  MyAssets get close => MyAssets(name: 'input_clear', style: MyAssetStyle.svg, color: myColors.onCardBackground);
  MyAssets get clearLight => MyAssets(name: 'input_clear', style: MyAssetStyle.svg, color: myColors.onPrimary);
  Icon get inputSearch => Icon(Icons.search, color: myColors.inputPrefixIcon);

  MyAssets get loginTitleBackgroundLeft => const MyAssets(name: 'login_title_background_left', style: MyAssetStyle.svg);
  MyAssets get loginTitleBackgroundRight => const MyAssets(name: 'login_title_background_right', style: MyAssetStyle.svg);
  MyAssets get loginTitleSelect => MyAssets(name: '${Get.isDarkMode ? 'dark' : 'light'}/login_title_select', style: MyAssetStyle.png, width: 60);
  MyAssets get loginRememberAccount => const MyAssets(name: 'single_checked', style: MyAssetStyle.svg);
  MyAssets get loginUnRememberAccount => const MyAssets(name: 'single_uncheck', style: MyAssetStyle.svg);

  MyAssets get bottomChat0 => MyAssets(name: 'bottom_chat_0', style: MyAssetStyle.svg, color: myColors.textBottomUnselect);
  // MyAssets get bottomChat1 => const MyAssets(name: 'bottom_chat_1', style: MyAssetStyle.svg);
  MyAssets get bottomChat1 => MyAssets(name: '${Get.isDarkMode ? 'dark' : 'light'}/bottom_chat_1', style: MyAssetStyle.svg);
  MyAssets get bottomFlash0 => MyAssets(name: 'bottom_flash_0', style: MyAssetStyle.svg, color: myColors.textBottomUnselect);
  // MyAssets get bottomFlash1 => const MyAssets(name: 'bottom_flash_1', style: MyAssetStyle.svg);
  MyAssets get bottomFlash1 => MyAssets(name: '${Get.isDarkMode ? 'dark' : 'light'}/bottom_flash_1', style: MyAssetStyle.svg);
  MyAssets get bottomHome0 => MyAssets(name: 'bottom_home_0', style: MyAssetStyle.svg, color: myColors.textBottomUnselect);
  MyAssets get bottomHome1 => const MyAssets(name: 'bottom_home_1', style: MyAssetStyle.svg);
  MyAssets get bottomMine0 => MyAssets(name: 'bottom_mine_0', style: MyAssetStyle.svg, color: myColors.textBottomUnselect);
  MyAssets get bottomMine1 => const MyAssets(name: 'bottom_mine_1', style: MyAssetStyle.svg);
  MyAssets get bottomScan => const MyAssets(name: 'bottom_scan', style: MyAssetStyle.svg);
  
  MyAssets get homeBuyCoin => const MyAssets(name: 'home_buy_coin', style: MyAssetStyle.svg);
  MyAssets get homeBuyOrders => const MyAssets(name: 'home_buy_orders', style: MyAssetStyle.svg);
  MyAssets get homeNewsIcon => const MyAssets(name: 'home_news_icon', style: MyAssetStyle.svg);
  MyAssets get homeNotice0 => const MyAssets(name: 'home_notice_0', style: MyAssetStyle.svg);
  MyAssets get homeNotice1 => const MyAssets(name: 'home_notice_1', style: MyAssetStyle.svg);
  MyAssets get homeQuickBuyButton => const MyAssets(name: 'home_quick_buy_button', style: MyAssetStyle.svg);
  MyAssets get homeSellCoin => const MyAssets(name: 'home_sell_coin', style: MyAssetStyle.svg);
  MyAssets get homeSellOrders => const MyAssets(name: 'home_sell_orders', style: MyAssetStyle.svg);
  MyAssets get homeTransfer => const MyAssets(name: 'home_transfer', style: MyAssetStyle.svg);
  MyAssets get homeCopy => const MyAssets(name: 'copy', style: MyAssetStyle.svg);
  MyAssets get homeAppBarBackground => const MyAssets(name: 'home_appbar_background', style: MyAssetStyle.png);
  MyAssets get homeWalletAddressBackground => const MyAssets(name: 'home_wallet_address_background', style: MyAssetStyle.svg, width: double.infinity, height: double.infinity);
  MyAssets get homeWalletAddress => MyAssets(name: 'home_wallet_address_background', style: MyAssetStyle.svg, width: double.infinity, height: double.infinity, color: myColors.iconDefault);

  DecorationImage get mineViewBackground => DecorationImage(image: AssetImage('assets/images/${Get.isDarkMode ? 'dark' : 'light'}/mine_view_bacground.png'), fit: BoxFit.fitWidth, alignment: Alignment.topCenter);
  DecorationImage get qrcodeViewBackground => const DecorationImage(image: AssetImage('assets/images/qrcode_bakground.png'), fit: BoxFit.fitWidth, alignment: Alignment.topCenter);
  DecorationImage get noticeBackground  => const DecorationImage(image: AssetImage('assets/images/notice_background.jpg'), fit: BoxFit.fill, alignment: Alignment.topCenter);

  MyAssets get mineViewAccount => MyAssets(name: '${Get.isDarkMode ? 'dark' : 'light'}/mine_view_account', style: MyAssetStyle.svg);
  MyAssets get mineViewPromotions => MyAssets(name: '${Get.isDarkMode ? 'dark' : 'light'}/mine_view_promotions', style: MyAssetStyle.svg);
  MyAssets get mineViewWalletHistory => MyAssets(name: '${Get.isDarkMode ? 'dark' : 'light'}/mine_view_wallet_history', style: MyAssetStyle.svg);
  MyAssets get mineViewSafe => MyAssets(name: '${Get.isDarkMode ? 'dark' : 'light'}/mine_view_safe', style: MyAssetStyle.svg);
  MyAssets get mineViewTutorial => const MyAssets(name: 'mine_view_tutorial', style: MyAssetStyle.png);
  MyAssets get mineViewEdit => const MyAssets(name: 'mine_view_edit', style: MyAssetStyle.svg);
  MyAssets get mineViewSettings => MyAssets(name: 'mine_view_settings', style: MyAssetStyle.svg, color: myColors.iconDefault);
  MyAssets get mineViewFeedback => MyAssets(name: 'mine_view_feedback', style: MyAssetStyle.svg, color: myColors.iconDefault);
  MyAssets get mineViewNotify => MyAssets(name: 'mine_view_notify', style: MyAssetStyle.svg, color: myColors.iconDefault);
  MyAssets get mineViewFaq => MyAssets(name: 'mine_view_faq', style: MyAssetStyle.svg, color: myColors.iconDefault);
  MyAssets get mineViewVersion => MyAssets(name: 'mine_view_version', style: MyAssetStyle.svg, color: myColors.iconDefault);
  
  MyAssets get helpHot => const MyAssets(name: 'help_hot', style: MyAssetStyle.svg);
  MyAssets get helpNormal => const MyAssets(name: 'help_normal', style: MyAssetStyle.svg);
  MyAssets get helpTitleIcon => const MyAssets(name: 'help_title_icon', style: MyAssetStyle.svg);

  MyAssets get iAmBuyer_0 => const MyAssets(name: 'i_am_buyer_0', style: MyAssetStyle.svg);
  MyAssets get iAmBuyer_1 => const MyAssets(name: 'i_am_buyer_1', style: MyAssetStyle.svg);
  MyAssets get iAmSeller_0 => const MyAssets(name: 'i_am_seller_0', style: MyAssetStyle.svg);
  MyAssets get iAmSeller_1 => const MyAssets(name: 'i_am_seller_1', style: MyAssetStyle.svg);

  MyAssets get go => const MyAssets(name: 'go', style: MyAssetStyle.gif);
  MyAssets get feedbackRemark => const MyAssets(name: 'feedback_remark', style: MyAssetStyle.svg);

  MyAssets get chatViewNotify => const MyAssets(name: 'chat_view_notify', style: MyAssetStyle.svg);
  MyAssets get chatViewCustomer => const MyAssets(name: 'chat_view_customer', style: MyAssetStyle.svg);
  MyAssets get chatViewNoticePersonal => const MyAssets(name: 'chat_view_notice_personal', style: MyAssetStyle.svg);

  MyAssets get coinCgb => const MyAssets(name: 'coin_cg', style: MyAssetStyle.png);
  MyAssets get coinUsdt => const MyAssets(name: 'coin_usdt', style: MyAssetStyle.svg);
  MyAssets get coinUsdt32 => const MyAssets(name: 'coin_usdt', style: MyAssetStyle.svg, width: 32);
  MyAssets get flashHistory => MyAssets(name: 'flash_history', style: MyAssetStyle.svg, color: myColors.iconDefault);

  Widget get face => Opacity(opacity: Get.isDarkMode ? 0.5 : 1, child: const MyAssets(name: 'face', style: MyAssetStyle.png));
  MyAssets get camera => const MyAssets(name: 'camera', style: MyAssetStyle.svg);
  MyAssets get failed => const MyAssets(name: 'failed', style: MyAssetStyle.svg);
  MyAssets get success => const MyAssets(name: 'success', style: MyAssetStyle.svg);
  MyAssets get successDisable => MyAssets(name: 'success', style: MyAssetStyle.svg, color: myColors.iconDefault,);
  MyAssets get idFront => MyAssets(name: '${Get.isDarkMode ? 'dark' : 'light'}/id_front', style: MyAssetStyle.svg);
  MyAssets get idBack => MyAssets(name: '${Get.isDarkMode ? 'dark' : 'light'}/id_back', style: MyAssetStyle.svg);

  MyAssets get noticeHide0 => MyAssets(name: '${Get.isDarkMode ? 'dark' : 'light'}/notice_hide_0', style: MyAssetStyle.svg);
  MyAssets get noticeHide1 => const MyAssets(name: 'notice_hide_1', style: MyAssetStyle.svg);
  // MyAssets get noticeBackground=> const MyAssets(width: double.infinity, height: double.infinity, name: 'notice_background', style: MyAssetStyle.jpg, fit: BoxFit.fill);

  MyAssets get customerItem => MyAssets(name: '${Get.isDarkMode ? 'dark' : 'light'}/customer_item', style: MyAssetStyle.png);
  MyAssets get customerMain => const MyAssets(name: 'customer_main', style: MyAssetStyle.png);
  MyAssets get customerAvatar => const MyAssets(name: 'customer_avatar', style: MyAssetStyle.png);
  MyAssets get customerNewMessage => const MyAssets(name: 'customer_new_message', style: MyAssetStyle.png);
  MyAssets get customerTitle => const MyAssets(name: 'customer_title', style: MyAssetStyle.png);

  MyAssets get logo => const MyAssets(name: 'logo', style: MyAssetStyle.svg);
  MyAssets get logoOnly => const MyAssets(name: 'logo_only', style: MyAssetStyle.svg);
  MyAssets get version => const MyAssets(name: 'version', style: MyAssetStyle.png);
  MyAssets get copyNormal => MyAssets(name: 'copy', style: MyAssetStyle.svg, color: myColors.iconCopy);
  MyAssets customer({Color? color}) => MyAssets(name: 'customer', style: MyAssetStyle.svg, color: color ?? myColors.iconDefault);
  MyAssets get qrcode => const MyAssets(name: 'qrcode', style: MyAssetStyle.svg);
  MyAssets get noData => MyAssets(name: 'no_data', style: MyAssetStyle.svg, color: myColors.inputSuffixIcon);
  MyAssets get langEnglish => const MyAssets(name: 'lang_us', style: MyAssetStyle.svg);
  MyAssets get langChinese => const MyAssets(name: 'lang_cn', style: MyAssetStyle.svg);
  MyAssets get qrcodeMy => const MyAssets(name: 'qrcode_my', style: MyAssetStyle.svg);
  MyAssets get qrcodePick => const MyAssets(name: 'qrcode_pick', style: MyAssetStyle.svg);

  MyAssets get orderSuccess => const MyAssets(name: 'order_success', style: MyAssetStyle.svg);
  MyAssets get orderCancel => const MyAssets(name: 'order_cancel', style: MyAssetStyle.svg);
  MyAssets get feedbackPrice => const MyAssets(name: 'feedback_price', style: MyAssetStyle.svg);

  MyAssets get newPasswordWallet => const MyAssets(name: 'new_password_wallet', style: MyAssetStyle.svg);
  MyAssets get newPhone => const MyAssets(name: 'new_phone', style: MyAssetStyle.svg);
  MyAssets get newPhoneCode => const MyAssets(name: 'new_phone_code', style: MyAssetStyle.svg);

  MyAssets get welcome1 => const MyAssets(name: 'welcome_1', style: MyAssetStyle.png, fit: BoxFit.cover);
  MyAssets get welcome2 => const MyAssets(name: 'welcome_2', style: MyAssetStyle.png, fit: BoxFit.cover);

  Icon get right => Icon(Icons.chevron_right, color: myColors.iconGrey);
  Icon get brokenImage => Icon(Icons.broken_image, size: 64, color: myColors.onBackground.withOpacity( 0.2));
  Icon get done => const Icon(Icons.done, color: Colors.white, size: 16);
  Icon get downSolid => Icon(Icons.arrow_drop_down, color: myColors.textDefault);
  MyAssets get downSolidHint => MyAssets(name: 'down_hint', style: MyAssetStyle.svg, color: myColors.error, height: 6, width: 10, fit: BoxFit.fill);
  MyAssets get upSolidHint => MyAssets(name: 'up_hint', style: MyAssetStyle.svg, color: myColors.error, height: 6, width: 10, fit: BoxFit.fill);
  Icon get downSolidLight => Icon(Icons.arrow_drop_down, color: myColors.onButtonPressed);
  Icon get upSolid => Icon(Icons.arrow_drop_up, color: myColors.textDefault);
  Icon get upSolidPrimary => Icon(Icons.arrow_drop_up, color: myColors.primary);
  Icon get up => Icon(Icons.keyboard_control_key, color: myColors.textDefault);
  Icon get upPrimary => Icon(Icons.keyboard_control_key, color: myColors.primary);
  Icon get down => Icon(Icons.keyboard_arrow_down, color: myColors.textDefault);
  Icon get downPrimary => Icon(Icons.keyboard_arrow_down, color: myColors.primary);
  Icon get theme => Icon(Icons.dark_mode, color: myColors.textDefault);
  Icon get language => Icon(Icons.language, color: myColors.textDefault);
  Icon get audio => Icon(Icons.volume_up, color: myColors.textDefault);
  Icon get vibration => Icon(Icons.vibration, color: myColors.textDefault);
  Icon get themeLight => Icon(Icons.light_mode, color: myColors.textDefault);
  Icon get themeDark => Icon(Icons.dark_mode, color: myColors.textDefault);
  Icon get themeSystem => Icon(Icons.contrast, color: myColors.textDefault);
  Icon get add => Icon(Icons.add, color: myColors.iconDefault);
  Icon get checkLight => Icon(Icons.check, color: myColors.light);
  Icon get deleteLight => Icon(Icons.delete_forever, color: myColors.light);
  Icon get filter => Icon(Icons.filter_alt_outlined, color: myColors.textDefault);
  Icon get checkBox => Icon(Icons.check_box, color: myColors.inputSuffixIcon);
  Icon get checkBoxPrimary => Icon(Icons.check_box, color: myColors.primary);
  Icon get help => Icon(Icons.question_mark, color: myColors.iconDefault);

  Icon get qiEmoticons => Icon(Icons.mood, color: myColors.iconDefault);
  Icon get qiCameraIcon => Icon(Icons.photo_camera, color: myColors.iconDefault);
  Icon get qiImage => Icon(Icons.image, color: myColors.iconDefault);
  Icon get qiKeyboard => Icon(Icons.keyboard, color: myColors.iconDefault);
  Icon get qiVideo => Icon(Icons.videocam, color: myColors.iconDefault);
  Icon get qiError => Icon(Icons.error, color: myColors.error);
  Icon get qiCopy => Icon(Icons.copy, color: myColors.light);
  Icon get qiReply => Icon(Icons.reply, color: myColors.light);

  MyAssets get turnRight => const MyAssets(name: 'turn_right', style: MyAssetStyle.gif);
  MyAssets get turnLeft => const MyAssets(name: 'turn_left', style: MyAssetStyle.gif);
  MyAssets get openMouth => const MyAssets(name: 'open_mouth', style: MyAssetStyle.gif);
  MyAssets get openEyes => const MyAssets(name: 'open_eyes', style: MyAssetStyle.gif);
  MyAssets get picFront => const MyAssets(name: 'pic_front', style: MyAssetStyle.png);
  MyAssets get payAlready => const MyAssets(name: 'pay_already', style: MyAssetStyle.png);
  

  MyAssets get tutorialSignIn => const MyAssets(name: 'tutorial_sign_in', style: MyAssetStyle.png);
  MyAssets get tutorialTrade => const MyAssets(name: 'tutorial_trade', style: MyAssetStyle.png);
  MyAssets get tutorialTradeInfo => const MyAssets(name: 'tutorial_trade_info', style: MyAssetStyle.jpg);
  MyAssets get hotFire => const MyAssets(name: 'fire', style: MyAssetStyle.gif);

  MyAssets get activitySignInBackground => const MyAssets(name: 'sign_in_background', style: MyAssetStyle.png);
  MyAssets get activitySignInCoin0 => const MyAssets(name: 'sign_in_coin_0', style: MyAssetStyle.png);
  MyAssets get activitySignInCoin1 => const MyAssets(name: 'sign_in_coin_1', style: MyAssetStyle.png);
  MyAssets get activitySignInCoin2 => const MyAssets(name: 'sign_in_coin_2', style: MyAssetStyle.png);

  CupertinoActivityIndicator get loadingIcon => const CupertinoActivityIndicator();

  Widget loading({double? width, double? height, double? radius}) {
    var loading = MyAssets(name: '${Get.isDarkMode ? 'dark' : 'light'}/loading', style: MyAssetStyle.lottie, width: width, height: height);
    return MyCard(borderRadius: BorderRadius.circular(radius ?? 8), child: loading);
  }
}