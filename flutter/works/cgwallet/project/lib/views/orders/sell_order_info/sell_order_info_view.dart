import 'dart:async';

import 'package:cgwallet/common/common.dart';
import 'package:cgwallet/views/views.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SellOrderInfoView extends GetView<SellOrderInfoController> {
  const SellOrderInfoView({super.key});

  @override
  Widget build(BuildContext context) {
    final buttonCancel = MyButton.text(onPressed: controller.onCancelOrder, text: Lang.sellOrderInfoViewCancelAll.tr);
    /// appbar
    var appBar = MyAppBar.normal(
      title: controller.state.title,
      actions: [
        Obx(() => controller.state.orderMarketInfo.value.id == -1
          ? const SizedBox()
          : MyButton.widget(
            onPressed: controller.goCustomerView,
            child: Get.theme.myIcons.customer()),
        ),
        Obx(() => controller.state.orderMarketInfo.value.status == 4 
          ? const SizedBox(width: 16)
          : buttonCancel
        )
      ],
    );

    /// 页面构成
    return Scaffold(
      appBar: appBar,
      backgroundColor: Theme.of(context).myColors.background,
      body: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    const spacer = SizedBox(height: 10, width: double.infinity,);
    final avatarBox = Obx(() => _buildAvatarBox(context, controller.state.orderSubInfo.value));
    final infoBox = Obx(() => getMarketOrderInfoWidget(context, controller.state.orderMarketInfo.value));
    final subOrderListBox = Obx(() => _buildSubOrderListBox(context, controller.state.orderMarketInfo.value));
    final scheduler = Obx(() => getOrderSchedulerWidget(context, controller.state.orderSubInfo.value, Text(controller.state.countDown, style: Theme.of(context).myStyles.labelRedBigger)));
    final payAccount = Obx(() => _buildPayAccount(context, controller.state.orderSubInfo.value));
    final collectAccount = Obx(() => _buildCollectAccount(context, controller.state.orderSubInfo.value));
    final orderInfo = Obx(() => _buildOrderInfo(context, controller.state.orderSubInfo.value));
    final hintBox = Obx(() => _buildHintBox(context, controller.state.orderMarketInfo.value));
    final payPicture = Obx(() => controller.state.orderSubInfo.value.payPicture != null && controller.state.orderSubInfo.value.payPicture!.isNotEmpty 
      ? Column(children: [
        spacer,
        _buildPayPicture(context, controller.state.orderSubInfo.value.payPicture!),
      ]) 
      : const SizedBox()
    );
    final dataContent = Column(children: [
      MyCard(
        padding: const EdgeInsets.only(left: 16, right: 16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          infoBox, 
          Obx(() => controller.state.orderMarketInfo.value.isDivide == 1 ? spacer : const SizedBox()),
          Obx(() => controller.state.orderMarketInfo.value.isDivide == 1 ? subOrderListBox : const SizedBox()),
        ]),
      ),
      spacer, 
      Expanded(child: SingleChildScrollView(padding: const EdgeInsets.fromLTRB(16, 0, 16, 0), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        avatarBox, 
        spacer, 
        scheduler, 
        spacer, 
        payAccount, 
        spacer, 
        collectAccount,
        spacer,
        orderInfo,
        payPicture,
        spacer,
        hintBox,
      ]))),
      SafeArea(child: Obx(() => _buildButton(context, controller.state.orderSubInfo.value))),
    ]);

    final emptyInfo = MyCard.normal(
      color: Theme.of(context).myColors.cardBackground,
      padding: const EdgeInsets.all(16),
      child: Column(children: [
        Text(Lang.sellOrderInfoViewEmptyTitle.tr, style: Theme.of(context).myStyles.labelBigger),
        const SizedBox(width: double.infinity, height: 8),
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text(Lang.sellOrderInfoViewEmptyTitle.tr, style: Theme.of(context).myStyles.labelSmall),
          const SizedBox(width: 8),
          Obx(() => Text(controller.state.orderMarketInfo.value.isDivide == 1 ? Lang.orderSplit.tr : Lang.orderNoSplit.tr, style: Theme.of(context).myStyles.label)),
        ]),
        const SizedBox(width: double.infinity, height: 8),
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text(Lang.sellOrderInfoViewEmptyRange.tr, style: Theme.of(context).myStyles.labelSmall),
          const SizedBox(width: 8),
          Obx(() => Text('${controller.state.orderMarketInfo.value.minAmt} - ${controller.state.orderMarketInfo.value.maxAmt}', style: Theme.of(context).myStyles.label)),
        ]),
        const SizedBox(width: double.infinity, height: 8),
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text(Lang.sellOrderInfoViewEmptyRange.tr, style: Theme.of(context).myStyles.labelSmall),
          const SizedBox(width: 8),
          Obx(() => Row(children: controller.state.orderMarketInfo.value.collects.asMap().entries.map((e) => MyCard(margin: e.key != controller.state.orderMarketInfo.value.collects.length - 1 ? const EdgeInsets.only(right: 4) : null, child: MyImage(imageUrl: e.value.icon, height: 20))).toList())),
        ]),
        const SizedBox(width: double.infinity, height: 8),
        Obx(() => Column(children: controller.state.orderMarketInfo.value.collects.asMap().entries.map((e) {
          final bankInfo = BankInfoModel.empty();
          bankInfo.account = e.value.account;
          bankInfo.accountName = e.value.accountName;
          bankInfo.payCategoryId = e.value.categoryId;
          bankInfo.icon = e.value.icon;
          bankInfo.categoryName = getCategoryInfo(e.value.categoryId).categoryName;
          bankInfo.qrcodeUrl = e.value.qrCodeUrl;
          bankInfo.bank = e.value.bankName;
          return BankInfoCard(
            bankInfo: bankInfo, 
            margin: e.key == controller.state.orderMarketInfo.value.collects.length - 1 ? null : const EdgeInsets.only(bottom: 8), 
            title: Lang.sellOrderInfoViewCollectAccount.tr, 
            color: Theme.of(context).myColors.itemCardBackground,
          );
        }).toList()))
      ]),
    );

    final initContent = SingleChildScrollView(
      padding: const EdgeInsets.only(left: 16, right: 16), 
      child: Column(children: [
        infoBox,
        spacer,
        emptyInfo,
        spacer,
        hintBox,
      ],
    ));

    return Obx(() => controller.state.orderMarketInfo.value.subOrders.isNotEmpty
      ? dataContent
      : initContent
    );
  }

  Widget _buildPayPicture(BuildContext context, List<PayPicture> pictures) {
    return MyCard.normal(
      padding: const EdgeInsets.all(16),
      child: Column(children: [
        Text(Lang.sellOrderInfoViewPayerPicture.tr, style: Theme.of(context).myStyles.labelBigger),
        Row(children: pictures.asMap().entries.map((e) => MyButton.widget(
          onPressed: () => MyAlert.saveImage(imageUrl: e.value.picUrl), 
          child: MyCard(
            margin: e.key == 1 ? const EdgeInsets.fromLTRB(8, 0, 8, 0) : null,
            borderRadius: BorderRadius.circular(10),
            width: (Get.width - 32 - 32 - 8 - 8) / 3, 
            height: (Get.width - 32 - 32) / 3,
            color: Theme.of(context).myColors.itemCardBackground,
            child: MyImage(imageUrl: e.value.picUrl),
          ),
        )).toList())
      ]),
    );
  }

  Widget _buildHintBox(BuildContext context, OrderMarketInfoModel data) {
    if (data.sellPrecautions.isEmpty) {
      return const SizedBox();
    }
    return MyCard.normal(
      color: Theme.of(context).myColors.itemCardBackground,
      padding: const EdgeInsets.all(16),
      child: MyHtml(data: data.sellPrecautions),
    );
  }

  Widget _buildButton(BuildContext context, OrderSubInfoModel data) {
    final isIngStep2 = isIng2(data);
    final isIngStep4 = isIng4(data);

    final buttonConfirmLong = MyButton.filedLong(onPressed: () => controller.onConfirmOrder(data), text: Lang.sellOrderInfoViewConfirmButtonText.tr);
    final buttonCancelShort = MyButton.filedLong(onPressed: () => controller.onCancelConfirmOrder(data), text: Lang.buyOrderInfoViewOrderCancel.tr, color: Theme.of(context).myColors.error);
    final buttonStep2 = Row(children: [
      Expanded(child: buttonCancelShort),
      const SizedBox(width: 10),
      Expanded(flex: 2, child: buttonConfirmLong),
    ]);

    final buttonPassLong = MyButton.filedLong(onPressed: () => _onPass(context, data), text: Lang.sellOrderInfoViewPassButtonText.tr);
    final buttonPassShort = MyButton.filedLong(onPressed: controller.goCustomerView, text: Lang.sellOrderInfoViewCustomerButton.tr, color: Theme.of(context).myColors.error);
    final buttonStep4 = Row(children: [
      Expanded(child: buttonPassShort),
      const SizedBox(width: 10),
      Expanded(flex: 2, child: buttonPassLong),
    ]);

    return MyCard(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 4),
      color: Theme.of(context).myColors.background, 
      child: isIngStep2 ? buttonStep2 : isIngStep4 ? buttonStep4 : const SizedBox()
    );
  }

  void _onPass(BuildContext context, OrderSubInfoModel data) {
    final timeDelay = data.delayedSettlementTime.toString();
    final delayPassHintText = Lang.sellOrderInfoViewPassDelayAlertContent1.trArgs([timeDelay]);

    int startIndex = delayPassHintText.indexOf(timeDelay);
    int endIndex = startIndex + timeDelay.length;

    List<TextSpan> textSpans = [];

    if (startIndex > 0) {
      textSpans.add(
        TextSpan(text: delayPassHintText.substring(0, startIndex)),
      );
    }

    textSpans.add(
      TextSpan(
        text: timeDelay,
        style: Theme.of(context).myStyles.labelRedBig,
      ),
    );

    if (endIndex < delayPassHintText.length) {
      textSpans.add(
        TextSpan(text: delayPassHintText.substring(endIndex)),
      );
    }

    final isRead = false.obs;
    final timeRead = 0.obs;
    const timeMax = 3;

    Timer? timer;

    timer = Timer.periodic(MyConfig.app.timeDebounce, (t) {
      if (timeRead < timeMax) {
        timeRead.value ++;
        timeRead.refresh();
      } else {
        timer?.cancel();
        timer = null;
      }
    });


    final checkBox = MyButton.widget(
      onPressed: () => isRead.value = !isRead.value, 
      child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        Obx(() => isRead.value ? Get.theme.myIcons.noticeHide1 : Get.theme.myIcons.noticeHide0),
        const SizedBox(width: 6),
        Text('${Lang.sellOrderInfoViewHaveRead.tr} (${Lang.sellOrderInfoViewPassHintText.tr})', style: Get.theme.myStyles.label),
      ]
    ));

    MyAlert.show(
      child: MyCard(child: Column(mainAxisSize: MainAxisSize.min, children: [
        Text(Lang.sellOrderInfoViewPassAlertTitle.tr, style: Theme.of(context).myStyles.labelBigger),
        const SizedBox(height: 8),
        // Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        //   Text(Lang.sellOrderInfoViewPassAlertContent1.tr, style: Theme.of(context).myStyles.label),
        //   RichText(text: TextSpan(style: Theme.of(context).myStyles.label, children: textSpans)),
        // ]),
        Flexible(child: SingleChildScrollView(child: MyHtml(data: controller.state.orderMarketInfo.value.meReadContent))),
        // const SizedBox(height: 8),
        // MyHintBoxDown(content: Lang.sellOrderInfoViewPassHintText.tr),
        // Text(Lang.sellOrderInfoViewPassHintText.tr, style: Theme.of(context).myStyles.labelRed),
        const SizedBox(height: 16),
        checkBox,
        const SizedBox(height: 20),
        Obx(() => MyButton.filedLong(onPressed: timeRead < timeMax || !isRead.value ? null : () => controller.pass(data), text: timeRead < timeMax ? '${Lang.sellOrderInfoViewPassAlertConfirmText.tr} (${timeMax - timeRead.value})' : Lang.sellOrderInfoViewPassAlertConfirmText.tr))
      ]))
    );
  }

  Widget _buildOrderInfo(BuildContext context, OrderSubInfoModel data) {
    final title = Text(Lang.buyOrderInfoViewOrderInfo.tr, style: Theme.of(context).myStyles.labelBigger);

    final orderId = _buildOrderInfoItem(context, Lang.buyOrderInfoViewOrderId.tr, data.sysOrderId, data.sysOrderId.isNotEmpty, false);
    // final collectName = _buildOrderInfoItem(context, Lang.buyOrderInfoViewCollectName.tr, data.name.isNotEmpty ? data.name : '***', data.name.isNotEmpty, false);
    // var collectBankCard = _buildOrderInfoItem(context, Lang.buyOrderInfoViewCollectAccount.tr, data.account.isNotEmpty ? data.account : '***', data.account.isNotEmpty, false);

    final orderTime1 = _buildOrderInfoItem(context, Lang.sellOrderInfoViewInfoCreateTime.tr, data.createdTime, false, false);
    final orderTime2 = _buildOrderInfoItem(context, Lang.sellOrderInfoViewInfoConfirmTime.tr, data.confirmTime, false, false);
    final orderTime3 = _buildOrderInfoItem(context, Lang.sellOrderInfoViewInfoPayTime.tr, data.payTime, false, false);
    final orderTime4 = _buildOrderInfoItem(context, Lang.sellOrderInfoViewInfoPassTime.tr, data.successTime, false, false);

    final cancelTime = _buildOrderInfoItem(context, Lang.buyOrderInfoViewCancelTime.tr, data.cancelTime, false, data.status == 4);
    

    // final qrcode = Column(children: [
    //   Row(children: [
    //     Expanded(child: Container(color: Theme.of(context).myColors.inputBorder.withOpacity( 0.3), height: 1)),
    //     const SizedBox(width: 20),
    //     Text(Lang.walletAddViewQrcode.tr, style: Theme.of(context).myStyles.labelSmall),
    //     const SizedBox(width: 20),
    //     Expanded(child: Container(color: Theme.of(context).myColors.inputBorder.withOpacity( 0.3), height: 1)),
    //   ]),
    //   const SizedBox(height: 20),
    //   MyButton.widget(onPressed: () => MyAlert.saveImage(imageUrl: data.payCollectCode), child: SizedBox(width: Get.width / 2.5, height: Get.width / 2.5, child: MyImage(imageUrl: data.payCollectCode))),
    // ]);
    
    const spacerTitle = SizedBox(width: double.infinity, height: 16);
    const spacerItem = SizedBox(width: double.infinity, height: 8);

    var childrenShow = [
      title, 
      spacerTitle, 
      orderId, 
      // if (data.name.isNotEmpty) collectName,
      // if (data.account.isNotEmpty) collectBankCard,

      if (data.orderTime1.isNotEmpty) orderTime1,
      if (data.orderTime2.isNotEmpty) orderTime2,
      if (data.orderTime3.isNotEmpty) orderTime3,
      if (data.orderTime4.isNotEmpty) orderTime4,

      if (data.payCollectCode.isNotEmpty) spacerItem,
      // if (data.payCollectCode.isNotEmpty) qrcode,
      if(data.status == 4) cancelTime,
    ];

    return MyCard.normal(
      padding: const EdgeInsets.all(16),
      child: Column(children: childrenShow),
    );
  }

  Widget _buildSubOrderListBox(BuildContext context, OrderMarketInfoModel data) {
    return SingleChildScrollView(
      controller: controller.scrollController,
      scrollDirection: Axis.horizontal, 
      child: Row(
        children: data.subOrders.asMap().entries.map((e) => _buildSubOrderItem(context, e)).toList(),
      ),
    );
  }

  Widget _buildSubOrderItem(BuildContext context, MapEntry<int, OrderSubInfoModel> data) {
    final orderMarketInfo = controller.state.orderMarketInfo.value;
    final statusName = getOrderStatusName(data.value.status);
    final orderItemStyle = getOrderItemStyle(context, data.value.status);
    final isChoose = controller.state.orderMarketIndex == data.key;
    final card = MyCard(
      width: 120,
      borderRadius: BorderRadius.circular(8),
      border: isChoose ? Border.all(color: Theme.of(context).myColors.primary, width: 1) : Border.all(color: Theme.of(context).myColors.inputBorder.withOpacity( 0.5), width: 1),
      color: isChoose ? Theme.of(context).myColors.primary.withOpacity( 0.1) : Theme.of(context).myColors.cardBackground,
      margin: data.key == orderMarketInfo.subOrders.length - 1 ? null : const EdgeInsets.only(right: 8),
      padding: const EdgeInsets.all(8),
      child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
        FittedBox(child: Text(data.value.actualQuantity, style: isChoose ? Theme.of(context).myStyles.labelPrimaryBiggest : Theme.of(context).myStyles.labelBiggest)),
         MyCard(
            borderRadius: BorderRadius.circular(6),
            padding: const EdgeInsets.only(left: 12, right: 12, top: 4, bottom: 4),
            color: orderItemStyle.color,
            child: FittedBox(child: Text(statusName, style: orderItemStyle.style)),
          ),
      ]),
    );
    final indexBox = MyCard(
      width: 20,
      height: 16,
      padding: const EdgeInsets.fromLTRB(4, 2, 4, 2),
      color: isChoose ? Theme.of(context).myColors.primary : Theme.of(context).myColors.iconGrey,
      borderRadius: const BorderRadius.only(topLeft: Radius.circular(8), bottomRight: Radius.circular(8)),
      child: FittedBox(child: Text((data.key + 1).toString(), style: Theme.of(context).myStyles.labelLight)),
    );
    Widget statusBox = data.value.status == 5 && !isChoose ? Theme.of(context).myIcons.orderSuccess : const SizedBox();
    return MyButton.widget(onPressed: () => controller.onChooseSubOrder(data), child: Stack(children: [
      card, indexBox, Positioned(right: 16, bottom: 8, child: statusBox),
    ]));
  }

  Widget _buildPayAccount(BuildContext context, OrderSubInfoModel data) {
    final bankInfo = BankInfoModel.empty();
    bankInfo.accountName = data.payName.isNotEmpty ? data.payName : '***';
    bankInfo.account = data.payAccount.isNotEmpty ? data.payAccount : '**** **** **** ****';
    bankInfo.payCategoryId = data.payCategoryId;
    bankInfo.bank = data.payBankName.isNotEmpty ? data.payBankName : '******';
    bankInfo.qrcodeUrl = data.payCollectCode;
    bankInfo.icon = data.payIcon;
    bankInfo.categoryName = data.bankName;

    Widget? icon;

    final card = BankInfoCard(
      bankInfo: bankInfo, 
      title: Lang.buyOrderInfoViewPayAccount.tr, 
      icon: icon,
    );

    final changePayBox = MyHintBoxDown(content: Lang.sellOrderInfoViewChangePayTitle.tr);
    const padding = EdgeInsets.fromLTRB(16, 8, 16, 8);
    final radius = BorderRadius.circular(6);

    final changeButtons = Row(children: [
      MyButton.widget(onPressed: () => controller.changePay(data, 1), child: MyCard(
        borderRadius: radius,
        color: Theme.of(context).myColors.error,
        padding: padding,
        child: Text(Lang.no.tr, style: Theme.of(context).myStyles.onButton),
      )),
      const SizedBox(width: 4),
      MyButton.widget(onPressed: () => controller.changePay(data, 2), child: MyCard(
        borderRadius: radius,
        color: Theme.of(context).myColors.primary,
        padding: padding,
        child: Text(Lang.yes.tr, style: Theme.of(context).myStyles.onButton),
      ))
    ]);

    final alreadyPay = SizedBox(height: 48, child: Theme.of(context).myIcons.payAlready);

    final cardChangePay = Column(children: [
      changePayBox,
      Stack(alignment: Alignment.center, children: [
        card,
        Positioned(right: 8, child: changeButtons),
      ]),
    ]);

    final cardAlreadyPay = Stack(alignment: Alignment.center, children: [
      card,
      Positioned(right: 8, child: alreadyPay),
    ]);

    return data.tempCollectId > 2 ? cardChangePay : data.orderTime3.isNotEmpty ? cardAlreadyPay : card;
  }

  Widget _buildCollectAccount(BuildContext context, OrderSubInfoModel data) {
    final bankInfo = BankInfoModel.empty();
    bankInfo.accountName = data.name.isNotEmpty ? data.name : '***';
    bankInfo.account = data.account.isNotEmpty ? data.account : '**** **** **** ****';
    bankInfo.payCategoryId = data.categoryId;
    bankInfo.bank = data.bankName.isNotEmpty ? data.bankName : '******';
    bankInfo.qrcodeUrl = data.collectCode;
    bankInfo.icon = data.icon;
    bankInfo.categoryName = data.bankName;

    Widget? icon;

    if (data.collectCode.isNotEmpty) {
      icon = MyButton.widget(onPressed: () => MyAlert.saveImage(
        imageUrl: data.collectCode), 
        child: MyCard.avatar(
          radius: 16, child: MyImage(imageUrl: data.collectCode, height: 32, width: 32),
        ),
      );
    }

    final card = BankInfoCard(
      bankInfo: bankInfo, 
      title: Lang.sellOrderInfoViewCollectAccount.tr,
      icon: icon,
    );

    return card;
  }

  Widget _buildAvatarBox(BuildContext context, OrderSubInfoModel data) {
    return Row(children: [
      MyCard.avatar(radius: 14, child: MyImage(imageUrl: data.tradeAvatarUrl)),
      const SizedBox(width: 8),
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(data.tradeUsername, style: Theme.of(context).myStyles.labelBig),
        Text(Lang.sellOrderInfoViewBuyer.tr, style: Theme.of(context).myStyles.labelSmall),
      ]),
      const Spacer(),
      Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
        Text(data.tradeBuyRate, style: Theme.of(context).myStyles.labelBig),
        Text(Lang.buyOrderInfoViewBuyRate.tr, style: Theme.of(context).myStyles.labelSmall),
      ]),
    ]);
  }

  Widget _buildOrderInfoItem(BuildContext context, String title, String value, bool isCopy, bool isCancel) {
    return Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
      Text(title, style: Theme.of(context).myStyles.labelSmall),
      const SizedBox(width: 10),
      Expanded(child: Text(value, style: isCancel ? Theme.of(context).myStyles.labelRed : Theme.of(context).myStyles.label)),
      if (isCopy)
        const SizedBox(width: 10),
      if (isCopy)
        SizedBox(height: 36, child: MyButton.text(onPressed: () => controller.copy(value), text: Lang.copy.tr, radius: 100))
    ]);
  }
}
