import 'dart:typed_data';

import 'package:cgwallet/common/common.dart';
import 'package:cgwallet/views/views.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class BuyOrderInfoView extends GetView<BuyOrderInfoController> {
  const BuyOrderInfoView({super.key});

  @override
  Widget build(BuildContext context) {
    /// appbar
    var appBar = MyAppBar.normal(
      title: controller.state.title,
      actions: [
        Obx(() => controller.state.orderSubInfo.value.id == -1
          ? const SizedBox()
          : MyButton.widget(onPressed: controller.goCustomerView, child: Get.theme.myIcons.customer()),
        ),
        const SizedBox(width: 16),
      ],
    );

    /// 页面构成
    return Scaffold(
      appBar: appBar, 
      body: _buildBody(context),
      backgroundColor: Theme.of(context).myColors.background
    );
  }

  Widget _buildBody(BuildContext context) {
    const spacer = SizedBox(height: 10);
    final avatarBox = Obx(() => _buildAvatarBox(context, controller.state.orderSubInfo.value));
    final infoBox = Obx(() => getSubOrderInfoWidget(context, controller.state.orderSubInfo.value));
    final scheduler = Obx(() => getOrderSchedulerWidget(context, controller.state.orderSubInfo.value, Text(controller.state.countDown, style: Theme.of(context).myStyles.labelRedBigger)));
    final payAccount = Obx(() => _buildPayAccount(context, controller.state.orderSubInfo.value));
    final orderInfo = Obx(() => _buildOrderInfo(context, controller.state.orderSubInfo.value));
    final hintBox = Obx(() => _buildHintBox(context, controller.state.orderSubInfo.value));

    return Column(children: [
      Expanded(child: SingleChildScrollView(padding: const EdgeInsets.fromLTRB(16, 0, 16, 0), child: Column(children: [
        avatarBox, spacer, infoBox, spacer, scheduler, spacer, payAccount, spacer, orderInfo, spacer, hintBox,
      ]))),
      SafeArea(child: Obx(() => _buildButton(context, controller.state.orderSubInfo.value))),
    ]);
  }

  Widget _buildAvatarBox(BuildContext context, OrderSubInfoModel data) {
    return Row(children: [
      Obx(() => MyCard.avatar(radius: 14, child: MyImage(imageUrl: controller.state.orderSubInfo.value.memberAvatarUrl))),
      const SizedBox(width: 8),
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Obx(() => Text(controller.state.orderSubInfo.value.memberUsername, style: Theme.of(context).myStyles.labelBig)),
        Text(Lang.buyOrderInfoViewSeller.tr, style: Theme.of(context).myStyles.labelSmall),
      ]),
      const Spacer(),
      Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
        Obx(() => Text(controller.state.orderSubInfo.value.memberBuyRate, style: Theme.of(context).myStyles.labelBig)),
        Text(Lang.buyOrderInfoViewBuyRate.tr, style: Theme.of(context).myStyles.labelSmall),
      ]),
    ]);
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
    void Function()? onPressed;

    if (isIng3(data)) {
      icon = Text(Lang.buyOrderInfoViewChangeBankButtonText.tr, style: Theme.of(context).myStyles.labelPrimary);
      onPressed = () => showAllBanks(context, data);
    }

    return BankInfoCard(
      bankInfo: bankInfo, 
      title: Lang.buyOrderInfoViewPayAccount.tr, 
      icon: icon,
      onPressed: onPressed,
    );
  }

  void showAllBanks(BuildContext context, OrderSubInfoModel data) {
    final bankInfoList = getBankInfoList(data.payCategoryId);
    MyAlert.bottomSheet(
      child: Column(
        children: [
          Text(Lang.buyOrderInfoViewPayAccount.tr, style: Theme.of(context).myStyles.labelBigger),
          const SizedBox(height: 20),
          ...bankInfoList.list.asMap().entries.map((e) => BankInfoCard(
            icon: data.memberAccountCollectId == e.value.id ? Theme.of(context).myIcons.checkBoxPrimary : null,
            bankInfo: e.value, 
            color: data.memberAccountCollectId == e.value.id ? Theme.of(context).myColors.primary.withOpacity( 0.1) : Theme.of(context).myColors.itemCardBackground,
            onPressed: data.memberAccountCollectId == e.value.id ? null : () => controller.onChangeBankCard(e.value),
            margin: e.key == bankInfoList.list.length - 1 ? null : const EdgeInsets.only(bottom: 8),
          ),
        )],
      ),
    );
  }

  Widget _buildOrderInfo(BuildContext context, OrderSubInfoModel data) {
    final isIngStep2 = isIng2(data);

    final title = Text(isIngStep2 ? Lang.buyOrderInfoViewCollectAccount.tr : Lang.buyOrderInfoViewOrderInfo.tr, style: Theme.of(context).myStyles.labelBigger);

    final orderId = _buildOrderInfoItem(context, Lang.buyOrderInfoViewOrderId.tr, data.sysOrderId, data.sysOrderId.isNotEmpty, false);
    final collectName = _buildOrderInfoItem(context, Lang.buyOrderInfoViewCollectName.tr, data.name.isNotEmpty ? data.name : '***', data.name.isNotEmpty, false);
    final collectBankName = _buildOrderInfoItem(context, Lang.buyOrderInfoViewCollectBank.tr, data.bankName.isNotEmpty ? data.bankName : '***', data.bankName.isNotEmpty, false);
    var collectBankCard = _buildOrderInfoItem(context, Lang.buyOrderInfoViewCollectAccount.tr, data.account.isNotEmpty ? data.account : '***', data.account.isNotEmpty, false);

    final createTime = _buildOrderInfoItem(context, Lang.buyOrderInfoViewCreateTime.tr, data.createdTime, false, false);
    final cancelTime = _buildOrderInfoItem(context, Lang.buyOrderInfoViewCancelTime.tr, data.cancelTime, false, data.status == 4);
    
    final hideInfo = Text(Lang.buyOrderInfoViewStepHintText1.tr, style: Theme.of(context).myStyles.label);

    final qrcode = Column(children: [
      Row(children: [
        Expanded(child: Container(color: Theme.of(context).myColors.inputBorder.withOpacity( 0.3), height: 1)),
        const SizedBox(width: 20),
        Text(Lang.walletAddViewQrcode.tr, style: Theme.of(context).myStyles.labelSmall),
        const SizedBox(width: 20),
        Expanded(child: Container(color: Theme.of(context).myColors.inputBorder.withOpacity( 0.3), height: 1)),
      ]),
      const SizedBox(height: 20),
      MyButton.widget(onPressed: () => MyAlert.saveImage(imageUrl: data.collectCode), child: SizedBox(width: Get.width / 2.5, height: Get.width / 2.5, child: MyImage(imageUrl: data.collectCode))),
    ]);
    
    const spacerTitle = SizedBox(width: double.infinity, height: 16);
    const spacerItem = SizedBox(width: double.infinity, height: 8);

    final childrenHide = [title, spacerTitle, hideInfo];
    
    var childrenShow = [
      title, 
      spacerTitle, 
      orderId, 
      if (data.name.isNotEmpty) collectName,
      if (data.account.isNotEmpty) collectBankCard,
      createTime,
      if (data.collectCode.isNotEmpty) spacerItem,
      if (data.collectCode.isNotEmpty) qrcode,
      if(data.status == 4) cancelTime,
    ];

    if (data.categoryId == 1) {
      childrenShow = [
        title, 
        spacerTitle, 
        orderId, 
        collectName,
        collectBankCard,
        createTime,
        if(data.status == 4) cancelTime,
      ];
    } else if (data.categoryId == 3) {
      childrenShow = [
        title, 
        spacerTitle, 
        orderId, 
        collectName,
        collectBankName,
        collectBankCard,
        createTime,
        if(data.status == 4) cancelTime,
      ];
    } 

    return MyCard.normal(
      padding: const EdgeInsets.all(16),
      child: Column(children: isIngStep2 ? childrenHide : childrenShow),
    );
  }

  Widget _buildHintBox(BuildContext context, OrderSubInfoModel data) {
    if (data.precautions.isEmpty) {
      return const SizedBox();
    }
    return MyCard.normal(
      color: Theme.of(context).myColors.itemCardBackground,
      padding: const EdgeInsets.all(16),
      child: MyHtml(data: data.precautions),
    );
  }

  Widget _buildButton(BuildContext context, OrderSubInfoModel data) {
    final isIngStep2 = isIng2(data);
    final isIngStep3 = isIng3(data);

    final buttonCancelLong = MyButton.filedLong(onPressed: () => _onCancel(context, data), text: Lang.buyOrderInfoViewOrderCancel.tr);
    final buttonCancelShort = MyButton.filedLong(onPressed: () => _onCancel(context, data), text: Lang.buyOrderInfoViewOrderCancel.tr, color: Theme.of(context).myColors.error);
    final buttonUpload = MyButton.filedLong(onPressed: () => _onUpload(context, data), text: Lang.buyOrderInfoViewStepUpload3.tr);
    final buttons = Row(children: [
      Expanded(child: buttonCancelShort),
      const SizedBox(width: 10),
      Expanded(flex: 2, child: buttonUpload),
    ]);

    return MyCard(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 4),
      color: Theme.of(context).myColors.background, 
      child: isIngStep2 ? buttonCancelLong : isIngStep3 ? buttons : const SizedBox()
    );
  }

  void _onCancel(BuildContext context,  OrderSubInfoModel data) {
    final title = Text(Lang.buyOrderInfoViewOrderCancel.tr, style: Theme.of(context).myStyles.labelBigger);
    final secondTitle = Text(Lang.buyOrderInfoViewOrderCancelSecondTitle.tr, style: Theme.of(context).myStyles.labelRed);
    MyAlert.bottomSheet(child: Column(children: [
      title,
      const SizedBox(height: 4, width: double.infinity),
      secondTitle,
      const SizedBox(height: 20, width: double.infinity),
      ...controller.state.reasons.asMap().entries.map((e) => MyButton.widget(onPressed: () => controller.chooseReason(e.key), child: MyCard.normal(
        color: Theme.of(context).myColors.itemCardBackground,
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
        margin: e.key == controller.state.reasons.length - 1 ? null : const EdgeInsets.only(bottom: 8),
        child: Row(children: [
          Obx(() => controller.state.reasonIndex == e.key ? Theme.of(context).myIcons.checkBoxPrimary : Theme.of(context).myIcons.checkBox),
          const SizedBox(width: 8),
          Obx(() => Text(e.value, style: controller.state.reasonIndex == e.key ? Theme.of(context).myStyles.labelPrimary : Theme.of(context).myStyles.label)),
        ]),
      ))),
      const SizedBox(height: 20, width: double.infinity),
      MyButton.filedLong(onPressed: () => controller.cancelOrder(data), text: Lang.confirm.tr)
    ]));
  }

  void _onUpload(BuildContext context,  OrderSubInfoModel data) {
    final title = Text(Lang.buyOrderInfoViewStepUpload3.tr, style: Theme.of(context).myStyles.labelBigger);
    MyAlert.bottomSheet(child: Column(children: [
      title,
      const SizedBox(height: 20, width: double.infinity),
      Row(children: controller.state.upLoadPaths.asMap().entries.map((e) => MyCard(
        margin: e.key == 1 ? const EdgeInsets.fromLTRB(8, 0, 8, 0) : null,
        borderRadius: BorderRadius.circular(10),
        width: (Get.width - 32 - 32 - 8 - 8) / 3, 
        height: (Get.width - 32 - 32) / 3,
        color: Theme.of(context).myColors.itemCardBackground,
        child: Stack(alignment: Alignment.center, children: [
          Obx(() => e.value.isEmpty 
            ? MyButton.widget(onPressed: () => controller.onPickImage(e.key), child: MyCard(width: double.infinity, height: double.infinity, child: Theme.of(context).myIcons.add))
            : Image.memory(width: double.infinity, height: double.infinity, Uint8List.fromList(e.value), fit: BoxFit.cover)
          ),
          Obx(() => e.value.isEmpty 
            ? const SizedBox() 
            : MyButton.widget(onPressed: () => controller.onClearImage(e.key), child: MyCard.avatar(radius: 16, color: Theme.of(context).myColors.primary, child: Center(child: Theme.of(context).myIcons.clearLight))),
          ),
        ]),
      )).toList()),
      const SizedBox(height: 20, width: double.infinity),
      MyButton.filedLong(onPressed: () => controller.onUpload(data), text: Lang.confirm.tr)
    ]));
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
