import 'package:cgwallet/common/common.dart';
import 'package:cgwallet/views/views.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

class MyPages {
  // 未知页面
  static final unknownRoute = GetPage(
    name: MyRoutes.unknownView,
    page: () => const UnknownView(),
    binding: UnknownBinding(),
  );

  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    MyLogger.w('当前路由 ---> ${settings.name}');

    // 获取getPages中的路由信息，如果未找到路由则返回默认的404页面
    final route = MyPages.getPages.where(
          (page) => page.name == settings.name,
    );

    if (route.isEmpty) {
      return null;
    } else {
      if (UserController.to.isUsedApp.isNotEmpty || settings.name == MyRoutes.indexView) {
        if (UserController.to.userInfo.value.token.isNotEmpty) {
          return GetPageRoute(
            routeName: MyRoutes.frameView,
            page: () => const FrameView(),
            binding: FrameBinding(),
          );
        } else {
          return GetPageRoute(
            routeName: MyRoutes.loginView,
            page: () => const LoginView(),
            binding: LoginBinding(),
          );
        }
      }
      return GetPageRoute(
        routeName: route.first.name,
        page: route.first.page,
        binding: route.first.binding,
      );
    }
  }


  static final List<GetPage> getPages = [
    // 初始页面
    GetPage(
      name: MyRoutes.indexView,
      page: () => const IndexView(),
      binding: IndexBinding(),
      middlewares: [
        MiddlewareIndex(),
      ],
    ),

    // 登录页面框架
    GetPage(
      name: MyRoutes.loginView,
      page: () => const LoginView(),
      binding: LoginBinding(),
    ),

    // webview
    GetPage(
      name: MyRoutes.webView,
      page: () => const WebviewView(),
      binding: WebviewBinding(),
    ),

    // 扫码
    GetPage(
      name: MyRoutes.scanView,
      page: () => const ScanView(),
      binding: ScanBinding(),
    ),

    // 主界面
    GetPage(
      name: MyRoutes.frameView,
      page: () => const FrameView(),
      binding: FrameBinding(),
    ),

    // 人脸识别
    GetPage(
      name: MyRoutes.faceVerifiedView,
      page: () => const FaceVerifiedView(),
      binding: FaceVerifiedBinding(),
    ),

    // 客服
    GetPage(
      name: MyRoutes.customerView,
      page: () => const CustomerView(),
      binding: CustomerBinding(),
    ),

    GetPage(
      name: MyRoutes.customerChatView,
      page: () => const CustomerChatView(),
      binding: CustomerChatBinding(),
    ),

    // 闪兑详情页面
    GetPage(
      name: MyRoutes.flashOrderInfoView,
      page: () => const FlashOrderInfoView(),
      binding: FlashOrderInfoBinding(),
    ),

    // 个人资料
    GetPage(
      name: MyRoutes.personalInfoView,
      page: () => const PersonalInfoView(),
      binding: PersonalInfoBinding(),
    ),

    // 修改昵称
    GetPage(
      name: MyRoutes.editNickNameView,
      page: () => const EditNicknameView(),
      binding: EditNicknameBinding(),
    ),

    // 教程页面
    GetPage(
      name: MyRoutes.tutorialView,
      page: () => const TutorialView(),
      binding: TutorialBinding(),
    ),

    // 钱包记录
    GetPage(
      name: MyRoutes.walletHistoryView,
      page: () => const WalletHistoryView(),
      binding: WalletHistoryBinding(),
    ),

    // 优惠活动列表
    GetPage(
      name: MyRoutes.promotionListView,
      page: () => const PromotionListView(),
      binding: PromotionListBinding(),
    ),

    // 优惠活动信息
    GetPage(
      name: MyRoutes.promotionInfoView,
      page: () => const PromotionInfoView(),
      binding: PromotionInfoBinding(),
    ),

    // 设置页面
    GetPage(
      name: MyRoutes.settingsView,
      page: () => const SettingsView(),
      binding: SettingsBinding(),
    ),

    // 账户管理
    GetPage(
      name: MyRoutes.walletManagerView,
      page: () => const WalletMangerView(),
      binding: WalletMangerBinding(),
    ),

    // 新增银行卡
    GetPage(
      name: MyRoutes.walletAddView,
      page: () => const WalletAddView(),
      binding: WalletAddBinding(),
    ),

    GetPage(
      name: MyRoutes.banksView,
      page: () => const BanksView(),
      binding: BanksBinding(),
    ),

    GetPage(
      name: MyRoutes.securityView,
      page: () => const SecurityView(),
      binding: SecurityBinding(),
    ),

    GetPage(
      name: MyRoutes.passwordSignView,
      page: () => const PasswordSignView(),
      binding: PasswordSignBinding(),
    ),

    GetPage(
      name: MyRoutes.passwordWalletView,
      page: () => const PasswordWalletView(),
      binding: PasswordWalletBinding(),
    ),

    GetPage(
      name: MyRoutes.faqView,
      page: () => const FAQView(),
      binding: FAQBinding(),
    ),

    GetPage(
      name: MyRoutes.versionView,
      page: () => const VersionView(),
      binding: VersionBinding(),
    ),

    GetPage(
      name: MyRoutes.notifyView,
      page: () => const NotifyView(),
      binding: NotifyBinding(),
    ),

    GetPage(
      name: MyRoutes.realNameVerifiedView,
      page: () => const RealNameVerifiedView(),
      binding: RealNameVerifiedBinding(),
    ),

    GetPage(
      name: MyRoutes.verifiedResultView,
      page: () => const VerifiedResultView(),
      binding: VerifiedResultBinding(),
    ),

    GetPage(
      name: MyRoutes.buyOrderView,
      page: () => const BuyOrderView(),
      binding: BuyOrderBinding(),
    ),

    GetPage(
      name: MyRoutes.buyOrderInfoView,
      page: () => const BuyOrderInfoView(),
      binding: BuyOrderInfoBinding(),
    ),

    GetPage(
      name: MyRoutes.buyOrderListView,
      page: () => const BuyOrderListView(),
      binding: BuyOrderListBinding(),
    ),

    GetPage(
      name: MyRoutes.sellOrderView,
      page: () => const SellOrderView(),
      binding: SellOrderBinding(),
    ),

    GetPage(
      name: MyRoutes.sellOrderInfoView,
      page: () => const SellOrderInfoView(),
      binding: SellOrderInfoBinding(),
    ),

    GetPage(
      name: MyRoutes.sellOrderListView,
      page: () => const SellOrderListView(),
      binding: SellOrderListBinding(),
    ),

    GetPage(
      name: MyRoutes.transferView,
      page: () => const TransferView(),
      binding: TransferBinding(),
    ),

    GetPage(
      name: MyRoutes.transferHistoryView,
      page: () => const TransferHistoryView(),
      binding: TransferHistoryBinding(),
    ),

    GetPage(
      name: MyRoutes.transferCoinView,
      page: () => const TransferCoinView(),
      binding: TransferCoinBinding(),
    ),

    GetPage(
      name: MyRoutes.buyCoinsQuicklyView,
      page: () => const BuyCoinsQuicklyView(),
      binding: BuyCoinsQuicklyBinding(),
    ),

    GetPage(
      name: MyRoutes.qrcodeView,
      page: () => const QrcodeView(),
      binding: QrcodeBinding(),
    ),

    GetPage(
      name: MyRoutes.payView,
      page: () => const PayView(),
      binding: PayBinding(),
    ),

    GetPage(
      name: MyRoutes.flashOrderHistoryView,
      page: () => const FlashOrderHistoryView(),
      binding: FlashOrderHistoryBinding(),
    ),

    GetPage(
      name: MyRoutes.activitySignInView,
      page: () => const ActivitySignInView(),
      binding: ActivitySignInBinding(),
    ),

    GetPage(
      name: MyRoutes.chatFaqInfoView,
      page: () => const ChatFaqInfoView(),
      binding: ChatFaqInfoBinding(),
    ),

    GetPage(
      name: MyRoutes.chatFaqListView,
      page: () => const ChatFaqListView(),
      binding: ChatFaqListBinding(),
    ),

    GetPage(
      name: MyRoutes.activityTradePrice,
      page: () => const ActivityTradePriceView(),
      binding: ActivityTradePriceBinding(),
    ),

    GetPage(
      name: MyRoutes.feedbackPriceView,
      page: () => const FeedbackPriceView(),
      binding: FeedbackPriceBinding(),
    ),

    GetPage(
      name: MyRoutes.passwordWalletFindView,
      page: () => const PasswordWalletFindView(),
      binding: PasswordWalletFindBinding(),
    ),

    GetPage(
      name: MyRoutes.customerHelpView,
      page: () => const CustomerHelpView(),
      binding: CustomerHelpBinding(),
    ),
  ];
}
