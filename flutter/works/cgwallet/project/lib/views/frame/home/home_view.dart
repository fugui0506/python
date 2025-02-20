import 'package:cgwallet/common/common.dart';
import 'package:cgwallet/views/views.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    /// 页面构成
    return GetBuilder<HomeController>(
      init: HomeController(),
      builder: (controller) => _buildScaffold(context, controller),
    );
  }

  Widget _buildScaffold(BuildContext context, HomeController controller) {
    return Scaffold(
      appBar: _buildAppBar(context, controller), 
      body: _buildBody(context, controller),
      backgroundColor: Theme.of(context).myColors.background,
    );
  }

  MyAppBar _buildAppBar(BuildContext context, HomeController controller) {
    return MyAppBar.spacer(
      title: _buildAppBarTitle(context, controller),
      bottom: _buildAppBarBottom(context, controller),
      flexibleSpace: _buildAppBarSpace(context),
    );
  }

  Widget _buildAppBarSpace(BuildContext context) {
    return Container(color: Theme.of(context).myColors.primary,
      // child: Theme.of(context).myIcons.homeAppBarBackground,
    );
  }

  Widget _buildBody(BuildContext context, HomeController controller) {
    return MyRefreshView(
      onRefresh: controller.onRefresh,
      padding: const EdgeInsets.all(16),
      controller: controller.refreshController, 
      children: [
        _buildMarquee(context, controller),
        const SizedBox(height: 4),
        _buildCarousel(context, controller),
        const SizedBox(height: 10),
        _buildCarouselBar(context, controller),
        const SizedBox(height: 10),
        _buildCoinButtons(context, controller),
        const SizedBox(height: 10),
        _buildQuickBuyCoinButton(context, controller),
        const SizedBox(height: 10),
        _buildFaq(context, controller),
        const SizedBox(height: 10),
        SizedBox(height: 58.0 + MediaQuery.of(context).padding.bottom)
      ]
    );
  }

  Widget _buildFaq(BuildContext context, HomeController controller) {
    return Obx(() => FaqListView(faqList: controller.state.faqList.value, isLoading: controller.state.isLoadingFAQ));
  }

  Widget _buildQuickBuyCoinButton(BuildContext context, HomeController controller) {
    final left = Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(Lang.homeViewQuickBuyTitle.tr, style: Theme.of(context).myStyles.homeQuickBuyTitle, overflow: TextOverflow.ellipsis),
        Text(Lang.homeViewQuickBuyContent.tr, style: Theme.of(context).myStyles.label, overflow: TextOverflow.ellipsis),
      ],
    );
    final right = MyCard(width: 100, child: Theme.of(context).myIcons.go);
    return MyButton.widget(onPressed: controller.goBuyCoinQuicklyView, child: MyCard.normal(
      padding: const EdgeInsets.all(16),
      child: Row(children: [
        Expanded(child: left), right
      ]),
    ));
  }

  Widget _buildCoinButtons(BuildContext context, HomeController controller) {
    final iconBuyCoin = Theme.of(context).myIcons.homeBuyCoin;
    final iconSellCoin = Theme.of(context).myIcons.homeSellCoin;
    final iconTransfer = Theme.of(context).myIcons.homeTransfer;
    final iconBuyOrders = Theme.of(context).myIcons.homeBuyOrders;
    final iconSellOrders = Theme.of(context).myIcons.homeSellOrders;

    final titleBuyCoin = Lang.homeViewBuyCoin.tr;
    final titleSellCoin = Lang.homeViewSellCoin.tr;
    final titleTransfer = Lang.homeViewTransfer.tr;
    final titleBuyOrders = Lang.homeViewBuyOrders.tr;
    final titleSellOrders = Lang.homeViewSellOrders.tr;

    return MyCard.normal(padding: const EdgeInsets.fromLTRB(0, 16, 0, 16), child: Row(children: [
      Expanded(child: _buildCoinButton(context: context, icon: iconBuyCoin, onPressed: controller.goBuyCoinView, title: titleBuyCoin)),
      Expanded(child: _buildCoinButton(context: context, icon: iconSellCoin, onPressed: controller.goSellCoinView, title: titleSellCoin)),
      Expanded(child: _buildCoinButton(context: context, icon: iconTransfer, onPressed: controller.goTransferView, title: titleTransfer)),
      Expanded(child: _buildCoinButton(context: context, icon: iconBuyOrders, onPressed: controller.goBuyOrdersView, title: titleBuyOrders)),
      Expanded(child: _buildCoinButton(context: context, icon: iconSellOrders, onPressed: controller.goSellOrdersView, title: titleSellOrders)),
    ]));
  }

  Widget _buildCoinButton({
    required BuildContext context,
    required MyAssets icon,
    required String title,
    required void Function() onPressed,
  }) {
    return MyButton.widget(
      onPressed: onPressed,
      child: Container(color: Theme.of(context).myColors.background.withOpacity( 0), child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(height: 32, child: Center(child: icon)),
          const SizedBox(height: 4),
          SizedBox(height: 22, child: Center(child: Padding(padding: const EdgeInsets.fromLTRB(8, 0, 8, 0), child: FittedBox(child: Text(title, style: Theme.of(context).myStyles.label, maxLines: 1))))),
        ],
      )),
    );
  }

  Widget _buildCarousel(BuildContext context, HomeController controller) {
    return MyCard.carousel(child: Obx(() => controller.state.carouselList.value.list.isEmpty
      ? const SizedBox()
      : MyCarousel(
          onChanged: controller.carouselOnChanged,
          children: controller.state.carouselList.value.list.map((e) => MyButton.widget(
            onPressed: e.link.isEmpty ? null : () {
              // 这里是图片里的链接
              final arguments = WebViewArgumentsModel(title: e.name, url: e.link);
              Get.toNamed(MyRoutes.webView, arguments: arguments);
            }, 
            child: MyImage(imageUrl: e.pictureUrl)
          )).toList()
        )
      )
    );
  }

  Widget _buildCarouselBar(BuildContext context, HomeController controller) {
    final select = MyCard.avatar(radius:4, color: Theme.of(context).myColors.primary);
    final unselect = MyCard.avatar(radius:4);

    final defaultButton = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        select,
        const SizedBox(width: 4),
        unselect,
        const SizedBox(width: 4),
        unselect,
      ],
    );

    final buttons = Obx(() => Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: controller.state.carouselList.value.list.asMap().entries.map((i) => i.key != controller.state.carouselList.value.list.length - 1
        ? Row(children: [
            Obx(() => i.key == controller.state.carouselIndex ? select : unselect),
            const SizedBox(width: 4)
          ])
        : Obx(() => i.key == controller.state.carouselIndex ? select : unselect)).toList(),
    ));

    return Obx(() => controller.state.carouselList.value.list.isEmpty ? defaultButton : buttons);
  }

  Widget _buildMarquee(BuildContext context, HomeController controller) {
    return Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Theme.of(context).myIcons.homeNewsIcon,
      const SizedBox(width: 8),
      Expanded(child:  Obx(() => controller.state.marqueeList.value.list.isEmpty
        ? const SizedBox()
        : MyMarquee(contentList: controller.state.marqueeList.value.list.map((e) => e.content).toList())
      )),
    ]);
  }

  Widget _buildAppBarTitle(BuildContext context, HomeController controller) {
    final avatarButton = MyButton.widget(onPressed: controller.goUserInfoView, child: Row(children: [
      const SizedBox(width: 16),
      MyCard.avatar(radius: 16, child: Obx(() => MyImage(imageUrl: UserController.to.userInfo.value.user.avatarUrl))),
      const SizedBox(width: 8),
      Obx(() => Text('${Lang.homeViewUid.tr} ${UserController.to.userInfo.value.user.id}', style: Theme.of(context).myStyles.onHomeAppBarUID)),
    ]));
    return Row(children: [
      avatarButton,
      MyButton.icon(onPressed: controller.copyUserId, icon: Theme.of(context).myIcons.homeCopy),
      const Spacer(),
      Obx(() => MyButton.icon(onPressed: controller.goNoticeView, icon: controller.state.noticeRead.value.countAll > 0 ? Theme.of(context).myIcons.homeNotice1 : Theme.of(context).myIcons.homeNotice0))
    ]);
  }

  PreferredSizeWidget _buildAppBarBottom(BuildContext context, HomeController controller) {
    const width = double.infinity;
    const height = 24.0 + 36.0 + 34.0 + 9.0;

    final title = Row(children: [
      Expanded(child: Column(children: [
        Container(padding: const EdgeInsets.fromLTRB(16, 0, 8, 0), height: 24, alignment: Alignment.centerLeft, child: FittedBox(
          child: Text(Lang.homeViewBalance.tr, style: Theme.of(context).myStyles.onHomeAppBarNormal)
        )),
        Container(padding: const EdgeInsets.fromLTRB(16, 0, 8, 0), height: 36, alignment: Alignment.centerLeft, child: FittedBox(
          child: Obx(() => Text(UserController.to.userInfo.value.balance, style: Theme.of(context).myStyles.onHomeAppBarBigger))
        )),
      ])),
      Expanded(child: MyButton.widget(onPressed: controller.goSellOrdersView, child: MyCard(child: Column(children: [
        Container(padding: const EdgeInsets.fromLTRB(8, 0, 8, 0), height: 24, alignment: Alignment.center, child: FittedBox(
          child: Text(Lang.homeViewSelling.tr, style: Theme.of(context).myStyles.onHomeAppBarNormal)
        )),
        Container(padding: const EdgeInsets.fromLTRB(8, 0, 8, 0), height: 36, alignment: Alignment.center, child: FittedBox(
          child: Obx(() => Text(UserController.to.userInfo.value.frozenBalance, style: Theme.of(context).myStyles.onHomeAppBarHeader))
        )),
      ])))),
      Expanded(child: Column(children: [
        Container(padding: const EdgeInsets.fromLTRB(8, 0, 16, 0), height: 24, alignment: Alignment.centerRight, child: FittedBox(
          child: Text(Lang.homeViewLock.tr, style: Theme.of(context).myStyles.onHomeAppBarNormal)
        )),
        Container(padding: const EdgeInsets.fromLTRB(8, 0, 16, 0), height: 36, alignment: Alignment.centerRight, child: FittedBox(
          child: Obx(() => Text(UserController.to.userInfo.value.lockBalance, style: Theme.of(context).myStyles.onHomeAppBarHeader))
        )),
      ])),
    ]);

    final walletAddressTitle = SizedBox(width: 80, height: 34, child: Stack(alignment: Alignment.center, children: [
      Theme.of(context).myIcons.homeWalletAddressBackground,
      Padding(padding: const EdgeInsets.fromLTRB(10, 0, 10, 0), child: FittedBox(child: Text(Lang.homeViewWalletAddress.tr, style: Theme.of(context).myStyles.onHomeAppBarNormal)),),
    ]));

    final walletAddress = Row(children: [
      const SizedBox(width: 16),
      walletAddressTitle,
      const SizedBox(width: 16),
      Flexible(child: FittedBox(child: Obx(() => Text(UserController.to.userInfo.value.walletAddress, style: Theme.of(context).myStyles.onHomeAppBarNormal)))),
      const SizedBox(width: 10),
      MyButton.widget(onPressed: controller.copyWalletAddress, child: Theme.of(context).myIcons.homeCopy),
      const SizedBox(width: 10),
      MyButton.widget(onPressed: controller.goQrcodeView, child: Theme.of(context).myIcons.qrcode),
      const SizedBox(width: 16),
    ]);

    return PreferredSize(
      preferredSize: const  Size(width, height),
      child: Container(
        width: width, 
        height: height,
        color: Theme.of(context).myColors.primary,
          child: Column(children: [
            title, walletAddress
          ]
        ),
      ),
    );
  }
}
