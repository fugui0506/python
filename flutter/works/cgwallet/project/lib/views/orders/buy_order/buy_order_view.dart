import 'package:cgwallet/common/common.dart';
import 'package:cgwallet/views/views.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BuyOrderView extends GetView<BuyOrderController> {
  const BuyOrderView({super.key});

  @override
  Widget build(BuildContext context) {
    /// appbar
    var appBar = MyAppBar.normal(
      title: controller.state.title,
      // actions: [
      //   MyButton.icon(
      //     onPressed: () {}, 
      //     icon: Row(children: [
      //       Text(Lang.buyOrderViewFilter.tr, style: Theme.of(context).myStyles.label), 
      //       Theme.of(context).myIcons.filter,
      //       const SizedBox(width: 10),
      //     ]),
      //   ),
      // ],
    );

    /// 页面构成
    return Scaffold(
      appBar: appBar, 
      backgroundColor: Theme.of(context).myColors.background,
      body: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    return Column(children: [_buildHeader(context), _buildContent(context)]);
  }

  Widget _buildMarquee(BuildContext context, MarqueeListModel marqueeList) {
    return marqueeList.list.isEmpty
      ? const SizedBox()
      : Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Theme.of(context).myIcons.homeNewsIcon,
          const SizedBox(width: 8),
          Expanded(child: MyMarquee(contentList: marqueeList.list.map((e) => e.contentMarket.removeHtmlTags()).toList())),
        ],
      );
  }

  Widget _buildHeader(BuildContext context) {
    final marquee = Padding(padding: const EdgeInsets.fromLTRB(16, 0, 16, 0), child: Obx(() => _buildMarquee(context, controller.state.marqueeList.value)));
    final header = Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Row(children: [
        const SizedBox(width: 16),
        Row(children: [
          MyButton.widget(onPressed: () => onAmount(context), child: Row(children: [
            Obx(() => Text(controller.state.amountTitle, style: Theme.of(context).myStyles.label)),
            Theme.of(context).myIcons.downSolid,
          ])),
          const SizedBox(width: 10),
          MyButton.widget(onPressed: controller.onBanks, child: Row(children: [
            Obx(() => Text(controller.state.categoryTitle, style: Theme.of(context).myStyles.label)),
            Theme.of(context).myIcons.downSolid,
          ])),
        ]),
      ]),
      const SizedBox(width: 10),
      Flexible(child: FittedBox(child: Row(children: [
        MyButton.widget(onPressed: controller.onIsRelease, child: Obx(() => MyCard.normal(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
          color: controller.state.isReleaseIndex == 0 ? Colors.transparent : Theme.of(context).myColors.primary,
          child: Row(children: [
            SizedBox(width: 14, child: Theme.of(context).myIcons.hotFire),
            const SizedBox(width: 4),
            Text('优惠', style: controller.state.isReleaseIndex == 0 ? Theme.of(context).myStyles.label : Theme.of(context).myStyles.labelLight),
          ]),
        ))),
        const SizedBox(width: 10),
        MyButton.widget(onPressed: controller.onLine, child: Row(children: [
          SizedBox(width: 14, height: 14, child: Obx(() => controller.state.onlineIndex == 0
              ? Opacity(opacity: 0.5, child: Theme.of(context).myIcons.successDisable)
              : Theme.of(context).myIcons.success)),
          const SizedBox(width: 4),
          Text(Lang.online.tr, style: Theme.of(context).myStyles.label),
          const SizedBox(width: 16),
        ])),
      ],))),
    ]);
    return Column(children: [
      marquee, header,
    ]);
  }

  Widget _buildContent(BuildContext context) {
    return Expanded(
      child: Obx(() => controller.state.isLoading ? _buildLoadingBox(context) : controller.state.orderMarketList.value.list.isEmpty ? noDataWidget : MyRefreshView(
        onRefresh: controller.onRefresh,
        onLoading: controller.onLoading,
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
        controller: controller.refreshController, 
        children: controller.state.orderMarketList.value.list.asMap().entries.map((e) => _buildItem(context,e)).toList()
      )),
    );
  }

  Widget _buildItem(BuildContext context, MapEntry<int, OrderMarketInfoModel> data) {
    return MyCard.normal(
      padding: const EdgeInsets.fromLTRB(12, 4, 12, 4),
      margin: data.key == controller.state.orderMarketList.value.list.length ? null : const EdgeInsets.only(bottom: 4),
      child: Column(children: [
        Row(children: [
          MyCard.avatar(radius: 14, child: MyImage(imageUrl: data.value.member.avatarUrl)),
          const SizedBox(width: 4),
          Text(data.value.username, style: Theme.of(context).myStyles.label),
          const SizedBox(width: 8),
          data.value.isOnline ? online : offline,
          if(data.value.isRelease == 1)
            const SizedBox(width: 4),
          if(data.value.isRelease == 1)
            Stack(alignment: AlignmentDirectional.center, children: [
              SizedBox(width: 28, child: Theme.of(context).myIcons.hotFire),
              Positioned(top: 8, child: Column(children: [
                Text(Lang.free.tr, textAlign: TextAlign.center, style: TextStyle(
                  color: Theme.of(context).myColors.light,
                  fontSize: 9,
                  height: 0,
                  fontWeight: FontWeight.bold,
                )),
              ],)),
              Positioned(top: 20, child: Column(children: [
                Text('${data.value.activityInfo}%', textAlign: TextAlign.center, style: TextStyle(
                  color: Theme.of(context).myColors.light,
                  fontSize: 6,
                  height: 0,
                  fontWeight: FontWeight.bold,
                )),
              ]))
            ]),
          const SizedBox(width: 16),
          const Spacer(),
          ...data.value.collects.asMap().entries.map((e) => MyCard(margin: e.key == data.value.collects.length - 1 ? null : const EdgeInsets.only(right: 4) , child: MyCard.avatar(radius: 9, child: MyImage(imageUrl: e.value.icon))))
        ]),
        Row(children: [
          Text(Lang.buyOrderViewSellAmount.tr, style: Theme.of(context).myStyles.label),
          const SizedBox(width: 8),
          Text(data.value.forSaleQuantity, style: Theme.of(context).myStyles.labelBigger),
          const SizedBox(width: 8),
          if(data.value.isDivide == 1) orderSplit,
        ]),
        Row(children: [
          Row(children: [
            Text(Lang.buyOrderViewLimit.tr, style: Theme.of(context).myStyles.label),
            const SizedBox(width: 8),
            Text('${data.value.minAmt} - ${data.value.maxAmt}', style: Theme.of(context).myStyles.label),
          ]),
          const SizedBox(width: 16),
          const Spacer(),
          MyButton.widget(
              onPressed: () => onBuy(context, data.value),
              child: MyCard(
                borderRadius: BorderRadius.circular(100),
                padding: const EdgeInsets.fromLTRB(12, 4, 12, 4),
                color: Theme.of(context).myColors.primary,
                child: Text(Lang.buyOrderViewWantToBuy.tr, style: Theme.of(context).myStyles.labelLight),
              ),
          ),
        ]),
      ]),
    );
  }

  void onAmount(BuildContext context) {
    MyAlert.bottomSheet(child: _buildBottomAmount(context));
  }

  void onBuy(BuildContext context, OrderMarketInfoModel data) {
    controller.resetBuyData();
    MyAlert.show(child: _buildBuyView(context, data));
  }

  Widget _buildBottomAmount(BuildContext context) {
    // final minInput = MyInput.amount(controller.minTextController, controller.minFocusNode, Lang.buyOrderViewMinHintText.tr);
    // final maxInput = MyInput.amount(controller.maxTextController, controller.maxFocusNode, Lang.buyOrderViewMaxHintText.tr);

    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(children: [
        Text(Lang.buyOrderViewAmount.tr, style: Theme.of(context).myStyles.labelBigger),
        const Spacer(),
        MyButton.widget(onPressed: controller.onResetAmount, child: Text(Lang.reset.tr, style: Theme.of(context).myStyles.labelPrimaryBig))
      ],),
      const SizedBox(width: double.infinity, height: 32),
      Row(children: [
        Obx(() => MyCheckBox(value: controller.state.amountIndex == 1, title: Lang.buyOrderViewSmall.tr, onPressed: () => controller.onAmount(1))),
        const SizedBox(width: 16),
        Obx(() => MyCheckBox(value: controller.state.amountIndex == 2, title: Lang.buyOrderViewMax.tr, onPressed: () => controller.onAmount(2))),
        // const SizedBox(width: 16),
        // Flexible(child: Obx(() => MyCheckBox(value: controller.state.amountIndex == 3, title: Lang.buyOrderViewAmountCustomize.tr, onPressed: () => controller.onAmount(3)))),
      ]),
      // Obx(() => controller.state.amountIndex != 3 ? const SizedBox() : Column(children: [
      //   const SizedBox(width: double.infinity, height: 16),
      //   MyCard.normal(
      //     color: Theme.of(context).myColors.itemCardBackground,
      //     child: Row(children: [
      //       Expanded(child: minInput),
      //       Container(width: 10, height: 1, color: Theme.of(context).myColors.inputBorder, margin: const EdgeInsets.fromLTRB(10, 0, 10, 0),),
      //       Expanded(child: maxInput),
      //     ]),
      //   ),
      // ])),
      const SizedBox(width: double.infinity, height: 32),
      MyButton.filedLong(onPressed: controller.onConfirmAmount, text: Lang.confirm.tr),
    ]);
  }

  Widget _buildLoadingBox(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.only(
        left: 16,
        right: 16,
      ),
      child: Column(
        children: [
          // Row(children: [
          //   Theme.of(context).myIcons.loading(width: 48, height: 24, radius: 8),
          //   Theme.of(context).myIcons.loading(width: 100, height: 24, radius: 8),
          //   const Spacer(),
          //   Theme.of(context).myIcons.loading(width: 48, height: 24, radius: 8),
          // ]),
          const SizedBox(height: 16),
          _buildLoadingBoxItem(context),
          const SizedBox(height: 10),
          _buildLoadingBoxItem(context),
          const SizedBox(height: 10),
          _buildLoadingBoxItem(context),
          const SizedBox(height: 10),
          _buildLoadingBoxItem(context),
          const SizedBox(height: 10),
          _buildLoadingBoxItem(context),
          const SizedBox(height: 10),
          _buildLoadingBoxItem(context),
          const SizedBox(height: 10),
          _buildLoadingBoxItem(context),
        ],
      ),
    );
  }

  Widget _buildLoadingBoxItem(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).myColors.cardBackground,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Theme.of(context).myIcons.loading(width: 32, height: 32, radius: 16),
              const SizedBox(width: 10),
              Theme.of(context).myIcons.loading(width: 120, height: 14, radius: 16),
              const Spacer(),
              Theme.of(context).myIcons.loading(width: 24, height: 24, radius: 12),
              const SizedBox(width: 4),
              Theme.of(context).myIcons.loading(width: 24, height: 24, radius: 12),
              const SizedBox(width: 4),
              Theme.of(context).myIcons.loading(width: 24, height: 24, radius: 12),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Theme.of(context).myIcons.loading(width: 200, height: 14, radius: 4),
            ],
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Theme.of(context).myIcons.loading(width: 120, height: 20, radius: 4),
              const Spacer(),
              Theme.of(context).myIcons.loading(width: 80, height: 24, radius: 12),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBuyView(BuildContext context, OrderMarketInfoModel data) {
    if (data.isDivide == 0) {
      final value = '${double.parse(data.quantity)}';
      controller.amountController.text = value;
    }
    return SingleChildScrollView(child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Text(Lang.buyOrderViewBuy.tr, style: Theme.of(context).myStyles.labelBigger),
          const Spacer(),
          MyButton.widget(onPressed: () => Get.back(), child: Theme.of(context).myIcons.inputClear),
        ]),
        const SizedBox(height: 16, width: double.infinity),
        Row(children: [
          Text(Lang.buyOrderViewBuyAmount.tr, style: Theme.of(context).myStyles.label),
          const Spacer(),
          Text(data.forSaleQuantity, style: Theme.of(context).myStyles.label),
          const SizedBox(width: 8),
          if(data.isDivide == 1) orderSplit,
        ]),
        const SizedBox(height: 8),
        MyInput.amountAll(
          enabled: data.isDivide == 1,
          controller.amountController, 
          controller.amountFocusNode, 
          hintText: '${Lang.buyOrderViewLimit.tr} ${data.minAmt} - ${data.maxAmt}', 
          onPressed: () => controller.onAmountAll(data)
        ),
        if(data.isRelease == 1)
          const SizedBox(height: 8),
        if(data.isRelease == 1)
          Text('${Lang.free2.tr}: ${data.activityInfo}%', style: Theme.of(context).myStyles.labelRed),
        const SizedBox(height: 16),
        Text(Lang.buyOrderInfoViewPayAccount.tr, style: Theme.of(context).myStyles.label),
        const SizedBox(width: double.infinity, height: 8),
        SingleChildScrollView(scrollDirection: Axis.horizontal, child: Row(
          children: data.collects.asMap().entries.map((e) {
            return Obx(() {
              if (UserController.to.categoryList.value.list.indexWhere((value) => value.id == e.value.categoryId) == -1) return const SizedBox();

              final isButtonDisabled = false.obs;

              var categoryInfo = UserController.to.categoryList.value.list.firstWhere((item) => item.id == e.value.categoryId);

              double minSetting = double.parse(UserController.to.orderSetting.value.sellAmountRange[categoryInfo.payCategorySn]?['min']);
              double maxSetting = double.parse(UserController.to.orderSetting.value.sellAmountRange[categoryInfo.payCategorySn]?['max']);

              bool isAmountNotInRange = false;

              if (controller.state.amountText.isNotEmpty) {
                double amount = double.parse(controller.state.amountText);
                isAmountNotInRange = amount < minSetting || amount > maxSetting;
              }

              if (isAmountNotInRange) {
                isButtonDisabled.value = true;


                Future.microtask(() {
                  if (controller.state.collectIndex == e.key) {
                    controller.state.collectIndex = -1;
                  }
                });

              }

              final button = MyButton.filedShort(
                color: isButtonDisabled.value ? Theme.of(context).myColors.buttonDisable : controller.state.collectIndex == e.key ? Theme.of(context).myColors.primary : Theme.of(context).myColors.itemCardBackground,
                textColor: isButtonDisabled.value ? Theme.of(context).myColors.onButtonDisable : controller.state.collectIndex == e.key ? Theme.of(context).myColors.onPrimary : Theme.of(context).myColors.textDefault,
                onPressed: () => isButtonDisabled.value ? null : controller.onChooseCollect(data, e),
                text: getCategoryInfo(e.value.categoryId).categoryName
              );

              return e.key == data.collects.length - 1 ? button : Padding(padding: const EdgeInsets.only(right: 8), child: button);
            });
          }).toList(),
        )),
        const SizedBox(width: double.infinity, height: 8),
        Obx(() => controller.state.collectIndex == -1 
          ? const SizedBox() 
          : getBankInfoList(data.collects[controller.state.collectIndex].categoryId).list.isEmpty 
            ? MyButton.widget(onPressed: () => controller.onAdd(getCategoryInfo(data.collects[controller.state.collectIndex].categoryId)), child: getBankInfoEmptyWidget(getCategoryInfo(data.collects[controller.state.collectIndex].categoryId).categoryName, color: Theme.of(context).myColors.itemCardBackground))
            : BankInfoCard(bankInfo: controller.state.bankInfo.value, icon: Theme.of(context).myIcons.downSolid, onPressed: () => showAllBanks(context, data), color: Theme.of(context).myColors.itemCardBackground)),
        Obx(() => controller.state.errorText.isEmpty ? const SizedBox() : Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
          const SizedBox(height: 16, width: double.infinity),
          Text(controller.state.errorText, style: Theme.of(context).myStyles.inputError),
        ])),
        const SizedBox(height: 16),
        Obx(() => MyButton.filedLong(onPressed: controller.state.isButtonDisable ? null : () => controller.onBuyCoin(data), text: Lang.buyOrderViewGoAndPay.tr))
      ],
    ));
  }

  void showAllBanks(BuildContext context, OrderMarketInfoModel data) {
    final bankInfoList = getBankInfoList(data.collects[controller.state.collectIndex].categoryId);
    MyAlert.bottomSheet(
      child: Column(
        children: [
          Text(Lang.buyOrderInfoViewPayAccount.tr, style: Theme.of(context).myStyles.labelBigger),
          const SizedBox(height: 20),
          ...bankInfoList.list.asMap().entries.map((e) => Obx(() => BankInfoCard(
            icon: e.key == controller.state.cardIndex ? Theme.of(context).myIcons.checkBoxPrimary : null,
            bankInfo: e.value, 
            color: e.key == controller.state.cardIndex ? Theme.of(context).myColors.primary.withOpacity( 0.1) : Theme.of(context).myColors.itemCardBackground,
            onPressed: () => controller.onChooseCard(e),
            margin: e.key == bankInfoList.list.length - 1 ? null : const EdgeInsets.only(bottom: 8),
          ),
        ))],
      ),
    );
  }
}
