import 'package:cgwallet/common/common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';

Widget getBankInfoEmptyWidget(String categoryName, {Color? color}) => MyCard.normal(
  padding: const EdgeInsets.all(16),
  color: color ?? Get.theme.myColors.cardBackground,
  child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
    Opacity(opacity: 0.4, child: Get.theme.myIcons.add),
    const SizedBox(width: 4),
    Text(Lang.walletManagerViewAdd.tr, style: Get.theme.myStyles.labelSmall),
    const SizedBox(width: 4),
    Text(categoryName, style: Get.theme.myStyles.labelPrimary),
    const SizedBox(width: 4),
    Text(Lang.walletManagerViewAddAccount.tr, style: Get.theme.myStyles.labelSmall),
  ]),
);


BankInfoListModel getBankInfoList(int categoryId) {
  final bankInfoList = UserController.to.bankList.value.list.where((element) => element.list.isNotEmpty && element.list.first.payCategoryId == categoryId);
  return bankInfoList.isEmpty ? BankInfoListModel.empty() : bankInfoList.first;
}

CategoryInfoModel getCategoryInfo(int categoryId) {
  final value = UserController.to.categoryList.value.list.where((element) => element.id == categoryId);
  return value.isEmpty ? CategoryInfoModel.empty() : value.first;
}

class BankInfoCard extends StatefulWidget {
  const BankInfoCard({
    super.key,
    required this.bankInfo,
    this.title,
    this.color,
    this.icon,
    this.margin,
    this.onPressed,
    this.actions,
    this.slidableController,
    this.groupTag,
  });

  final BankInfoModel bankInfo;
  final Color? color;
  final String? title;
  final Widget? icon;
  final EdgeInsetsGeometry? margin;
  final void Function()? onPressed;
  final List<Widget>? actions;
  final SlidableController? slidableController;
  final Object? groupTag;

  @override
  State<BankInfoCard> createState() => _BankInfoCardState();
}

class _BankInfoCardState extends State<BankInfoCard> with TickerProviderStateMixin {
 

  void saveImage() {
    MyAlert.saveImage(imageUrl: widget.bankInfo.qrcodeUrl);
  }

  @override
  Widget build(BuildContext context) {
    final content = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(children: [
          MyImage(width: 20, height: 20, imageUrl: widget.bankInfo.icon),
          const SizedBox(width: 8),
          Text(widget.bankInfo.payCategoryId == 3 ? widget.bankInfo.bank : widget.bankInfo.categoryName, style: Theme.of(context).myStyles.labelPrimaryBig)
        ]),
        if (widget.bankInfo.qrcodeUrl.isNotEmpty)
          const SizedBox(height: 2),
        if (widget.bankInfo.qrcodeUrl.isNotEmpty)
          Row(children: [
            MyButton.widget(onPressed: saveImage, child: MyImage(imageUrl: widget.bankInfo.qrcodeUrl, width: 20, height: 20, borderRadius: BorderRadius.circular(10))),
            const SizedBox(width: 10),
            Text(widget.bankInfo.accountName, style: Theme.of(context).myStyles.labelSmall),
          ])
        else
          FittedBox(child: Text('${widget.bankInfo.account}   ${widget.bankInfo.accountName}',style: Theme.of(context).myStyles.labelSmall))
      ],
    );
    
    final left = Row(children: [
      if(widget.title != null) Text(widget.title!, style: Theme.of(context).myStyles.label),
      if(widget.title != null) const SizedBox(width: 16),
      Flexible(child: content),
    ]);

    final card = MyCard.normal(
      padding: const EdgeInsets.all(16),
      margin: widget.margin,
      color: widget.color,
      child: Row(children: [
        Flexible(child: left),
        const SizedBox(width: 10),
        if(widget.icon != null) widget.icon!,
      ]),
    );
    
    return widget.actions == null
      ? MyButton.widget(
          onPressed: widget.onPressed,
          child: card
        )
      : MyCard.normal(
          margin: widget.margin,
          child: MySlidable(
            onPressed: widget.onPressed,
            groupTag: widget.groupTag,
            slidableController: widget.slidableController,
            actions: widget.actions!,
            child: card,
          ),
        );
  }
}
