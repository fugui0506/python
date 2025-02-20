import 'package:cgwallet/common/common.dart';
import 'package:cgwallet/views/views.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

Widget getSubOrderInfoWidget(BuildContext context, OrderSubInfoModel data) {
  return MyCard(
    borderRadius: BorderRadius.circular(16),
    color: data.status == 4 ? Theme.of(context).myColors.buttonDisable : Theme.of(context).myColors.primary,
    padding: const EdgeInsets.all(16),
    child: Row(children: [
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('${Lang.buyOrderInfoViewBuyAmount.tr} (${Lang.flashViewCgb.tr})', style: Theme.of(context).myStyles.labelLight),
        const SizedBox(height: 4),
        Text(data.amount, style: Theme.of(context).myStyles.labelLightBiggest),
      ]),
      const Spacer(),
      data.status == 4
        ? Theme.of(context).myIcons.orderCancel
        : data.status == 5
          ? Theme.of(context).myIcons.orderSuccess
          : data.status == -1 
            ? const SizedBox() 
            : Text(getOrderStatusName(data.status), style: Theme.of(context).myStyles.labelLight),
    ]),
  );
}

Widget getMarketOrderInfoWidget(BuildContext context, OrderMarketInfoModel data) {
  return MyCard(
    borderRadius: BorderRadius.circular(16),
    color: data.status == 4 ? Theme.of(context).myColors.buttonDisable : Theme.of(context).myColors.primary,
    padding: const EdgeInsets.all(16),
    child: Column(children: [
      Row(crossAxisAlignment: CrossAxisAlignment.center, mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Row(children: [
          Text('${Lang.sellOrderInfoViewSellAmount.tr} (${Lang.flashViewCgb.tr})', style: Theme.of(context).myStyles.labelLight),
          const SizedBox(width: 8),
          data.isDivide == 1 ? orderSplitOnprimary : const SizedBox(),
          const SizedBox(width: 8),
        ]),
        Flexible(child: FittedBox(child: Text(Lang.sellOrderInfoViewAlreadySell.tr, style: Theme.of(context).myStyles.labelLight))),
      ]),

      Row(crossAxisAlignment: CrossAxisAlignment.center, mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text(data.quantity, style: Theme.of(context).myStyles.labelLightBiggest),
        const SizedBox(width: 8),
        Flexible(child: FittedBox(child: Text('${data.actualQuantity}/${double.parse(data.quantity) - double.parse(data.actualQuantity)}', style: Theme.of(context).myStyles.labelLightBig)))
      ]),
    ]),
  );
}

Widget _buildSchedulerLine(BuildContext context, OrderSubInfoModel data, Color color) {
  return Container(
    margin: const EdgeInsets.only(bottom: 5),
    width: (Get.width - 32 - (Get.width - 32) / 4) / 3,
    height: 2,
    color: color,
  );
}

Widget _buildSchedulerContent(
  BuildContext context, 
  OrderSubInfoModel data, 
  String title,
  Widget timer,
  Widget status,
) {
  return Column(children: [
    Text(title, style: Theme.of(context).myStyles.label),
    const SizedBox(height: 4),
    SizedBox(height: 24, child: Center(child: timer)),
    const SizedBox(height: 8),
    status,
  ]);
}

bool isCancel2(OrderSubInfoModel data) {
  return data.status == 4 && data.orderTime2.isEmpty;
}

bool isCancel3(OrderSubInfoModel data) {
  return data.status == 4 && data.orderTime2.isNotEmpty && data.orderTime3.isEmpty;
}

bool isCancel4(OrderSubInfoModel data) {
  return data.status == 4 && data.orderTime3.isNotEmpty && data.orderTime4.isEmpty;
}

bool isIng2(OrderSubInfoModel data) {
  return data.orderTime2.isEmpty && data.status != 4;
}

bool isIng3(OrderSubInfoModel data) {
  return data.orderTime3.isEmpty && data.orderTime2.isNotEmpty && data.status != 4;
}

bool isIng4(OrderSubInfoModel data) {
  return data.orderTime3.isNotEmpty && data.orderTime4.isEmpty && data.status != 4;
}

bool isPassDelay(OrderSubInfoModel data) {
  return data.orderTime3.isNotEmpty && data.orderTime4.isEmpty && data.status == 7;
}

String getOrderStatusName(int status) {
  String statusName = '';
  final list = UserController.to.orderStatus.value.list.where((element) => element.status == status);
  if (list.isNotEmpty) {
    statusName = list.first.statusName;
  }
  return statusName;
}

OrderHistoryItemStyle getFlashOrderItemStyle(BuildContext context, int status) {
  Color color = Theme.of(context).myColors.primary;
  TextStyle style = Theme.of(context).myStyles.onButton;

  if (status == 1) {
    // 待付款
    color = Theme.of(context).myColors.error;
    style = Theme.of(context).myStyles.onButton;
  } else if (status == 2) {
    // 待确认
    color = Theme.of(context).myColors.onPending;
    style = Theme.of(context).myStyles.onButton;
  } else if (status == 3) {
    // 成功
    color = Theme.of(context).myColors.secondary;
    style = Theme.of(context).myStyles.onButton;
  } else if (status == 4) {
    // 取消
    color = Theme.of(context).myColors.iconGrey.withOpacity( 0.3);
    style = Theme.of(context).myStyles.label;
  }

  return OrderHistoryItemStyle(color, style);
}

OrderHistoryItemStyle getOrderItemStyle(BuildContext context, int status) {
  Color color = Theme.of(context).myColors.primary;
  TextStyle style = Theme.of(context).myStyles.onButton;

  if (status == 2) {
    // 待付款
    color = Theme.of(context).myColors.error;
    style = Theme.of(context).myStyles.onButton;
  } else if (status == 1) {
    // 待确认
    color = Theme.of(context).myColors.onPending;
    style = Theme.of(context).myStyles.onButton;
  } else if (status == 5) {
    // 成功
    color = Theme.of(context).myColors.secondary;
    style = Theme.of(context).myStyles.onButton;
  } else if (status == 4) {
    // 取消
    color = Theme.of(context).myColors.iconGrey.withOpacity( 0.3);
    style = Theme.of(context).myStyles.label;
  } else if (status == 7) {
    // 超时
    color = Theme.of(context).myColors.onTimeout;
    style = Theme.of(context).myStyles.onButton;
  } else if (status == 3) {
    // 代收款
    color = Theme.of(context).myColors.onReceiving;
    style = Theme.of(context).myStyles.onButton;
  } else if (status == 6) {
    color = const Color(0xFF7738C5);
    style = Theme.of(context).myStyles.onButton;
  }

  return OrderHistoryItemStyle(color, style);
}

Widget getOrderSchedulerWidget(BuildContext context, OrderSubInfoModel data, Widget timer) {
  final isCancelStep2 = isCancel2(data);
  final isCancelStep3 = isCancel3(data);
  final isCancelStep4 = isCancel4(data);

  final isIngStep2 = isIng2(data);
  final isIngStep3 = isIng3(data);
  final isIngStep4 = isIng4(data);

  final isPassDelay4 = isPassDelay(data);

  final errorColor = Theme.of(context).myColors.error;
  final primaryColor = Theme.of(context).myColors.primary;
  final buttonDisableColor = Theme.of(context).myColors.buttonDisable;

  final label = Theme.of(context).myStyles.label;
  final labelRed = Theme.of(context).myStyles.labelRed;
  
  final iconFailed = Theme.of(context).myIcons.failed;

  return Stack(
    alignment: AlignmentDirectional.bottomStart,
    children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildSchedulerLine(context, data, isCancelStep2 ? errorColor : primaryColor),
          _buildSchedulerLine(context, data, isCancelStep3 ? errorColor : isIngStep3 || isIngStep4 || data.status == 5 || isCancelStep4 ? primaryColor : buttonDisableColor),
          _buildSchedulerLine(context, data, isCancelStep4 ? errorColor : isIngStep4 || data.status == 5 ? primaryColor : buttonDisableColor),
        ],
      ),

      Row(
        children: [
          Expanded(child: _buildSchedulerContent(context, data, Lang.buyOrderInfoViewStep1.tr, 
            Text(data.orderTime1, style: label),
            MyCard.avatar(radius: 6, color: primaryColor)),
          ),
          Expanded(child: _buildSchedulerContent(context, data, Lang.buyOrderInfoViewStep2.tr,
            isCancelStep2 ? Text(Lang.buyOrderInfoViewOrderCancel.tr, style: labelRed) : isIngStep2 ? timer : Text(data.orderTime2, style: Theme.of(context).myStyles.label),
            isCancelStep2 ? SizedBox(height: 12, child: iconFailed) : MyCard.avatar(radius: 6, color: primaryColor)),
          ),
          Expanded(child: _buildSchedulerContent(context, data, Lang.buyOrderInfoViewStep3.tr,
            isCancelStep3 ? Text(Lang.buyOrderInfoViewOrderCancel.tr, style: Theme.of(context).myStyles.labelRed) : isIngStep3 ? timer : Text(data.orderTime3, style: Theme.of(context).myStyles.label),
            isCancelStep3 ? SizedBox(height: 12, child: iconFailed) : MyCard.avatar(radius: 6, color: isIngStep3 || isIngStep4 || data.status == 5 || isCancelStep4 ? primaryColor : buttonDisableColor)),
          ),
          Expanded(child: _buildSchedulerContent(context, data, Lang.buyOrderInfoViewStep4.tr,
            isCancelStep4 ? Text(Lang.buyOrderInfoViewOrderCancel.tr, style: Theme.of(context).myStyles.labelRed) : isPassDelay4 ? Text(getOrderStatusName(data.status), style: Theme.of(context).myStyles.labelRed) : isIngStep4 ? timer : Text(data.orderTime4, style: Theme.of(context).myStyles.label),
            isCancelStep4 ? SizedBox(height: 12, child: iconFailed) : MyCard.avatar(radius: 6, color: isIngStep4 || data.status == 5 ? primaryColor : buttonDisableColor)),
          ),
        ],
      ),
    ],
  );
}

class OrderHistoryItemStyle {
  final Color color;
  final TextStyle style;

  const OrderHistoryItemStyle(this.color, this.style);
}