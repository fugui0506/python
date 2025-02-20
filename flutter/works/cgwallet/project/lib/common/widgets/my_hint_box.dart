import 'package:cgwallet/common/common.dart';
import 'package:flutter/material.dart';

class MyHintBoxDown extends StatelessWidget {
  const MyHintBoxDown({
    super.key, 
    required this.content,
    this.color
  });

  final String content;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center, 
      children: [
        MyCard(
          padding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
          borderRadius: BorderRadius.circular(6),
          color: color ?? Theme.of(context).myColors.error,
          child: FittedBox(child: Text(content, style: Theme.of(context).myStyles.onButton)),
        ),
        Theme.of(context).myIcons.downSolidHint,
      ],
    );
  }
}

class MyHintBoxUp extends StatelessWidget {
  const MyHintBoxUp({
    super.key, 
    required this.content,
    this.color
  });

  final String content;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center, 
      children: [
        Theme.of(context).myIcons.upSolidHint,
        MyCard(
          padding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
          borderRadius: BorderRadius.circular(6),
          color: color ?? Theme.of(context).myColors.error,
          child: FittedBox(child: Text(content, style: Theme.of(context).myStyles.onButton)),
        ),
      ],
    );
  }
}