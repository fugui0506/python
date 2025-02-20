import 'package:cgwallet/common/common.dart';
import 'package:flutter/material.dart';

class MyCheckBox extends StatelessWidget {
  const MyCheckBox({
    this.onPressed, 
    required this.value, 
    required this.title,
    super.key
  });

  final void Function()? onPressed;
  final bool value;
  final String title;

  @override
  Widget build(BuildContext context) {
    return MyButton.widget(onPressed: onPressed, child: MyCard.normal(child: Row(children: [
      value ? Theme.of(context).myIcons.checkBoxPrimary : Theme.of(context).myIcons.checkBox,
      Text(title, style: Theme.of(context).myStyles.label, overflow: TextOverflow.ellipsis),
    ])));
  }
}