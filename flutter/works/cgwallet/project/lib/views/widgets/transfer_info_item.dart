import 'package:cgwallet/common/common.dart';
import 'package:flutter/material.dart';

class TransferInfoItem extends StatelessWidget {
  const TransferInfoItem({
    super.key,
    required this.avatar,
    required this.name,
    required this.address,
    required this.amount,
    required this.time,
  });

  final String avatar;
  final String name;
  final String address;
  final String amount;
  final String time;

  static Widget emptyList(BuildContext context, int length, EdgeInsetsGeometry margin) {
    final card = MyCard(
      color: Theme.of(context).myColors.cardBackground,
      padding: const EdgeInsets.all(16),
      borderRadius: BorderRadius.circular(16),
      margin: margin,
      child: Column(children: [
        Row(children: [
          MyCard.avatar(radius: 16, child: Theme.of(context).myIcons.loading()),
          const SizedBox(width: 8),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Theme.of(context).myIcons.loading(height: 20, width: 120, radius: 4),
              const SizedBox(height: 4),
              Theme.of(context).myIcons.loading(height: 14, width: 100, radius: 4),
            ]),
          ),
          Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
            Theme.of(context).myIcons.loading(height: 20, width: 60, radius: 4),
            const SizedBox(height: 4),
            Theme.of(context).myIcons.loading(height: 14, width: 100, radius: 4),
          ]),
        ]),
      ]),
    );

    return SingleChildScrollView(child: Column(children: List.generate(length, (i)=> card)));
  }

  @override
  Widget build(BuildContext context) {
    if (address.isEmpty) {
      return const SizedBox();
    }
    final card = MyCard(
      margin: const EdgeInsets.only(bottom: 1),
      color: Theme.of(context).myColors.cardBackground,
      padding: const EdgeInsets.all(16),
      borderRadius: BorderRadius.circular(16),
      child: Column(children: [
        Row(children: [
          MyCard.avatar(radius: 20, child: MyImage(imageUrl: avatar, width: 40)),
          const SizedBox(width: 8),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(name, style: Theme.of(context).myStyles.labelBig),
              Text(address, style: Theme.of(context).myStyles.labelSmall),
            ]),
          ),
          const SizedBox(width: 8),
          Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
            Text(amount, style: amount.contains('+') ? Theme.of(context).myStyles.labelRedBig : Theme.of(context).myStyles.labelGreenBig),
            const SizedBox(width: 8),
            Text(time, style: Theme.of(context).myStyles.labelSmall),
          ]),
        ]),
      ]),
    );

    return card;
  }
}