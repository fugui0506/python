import 'package:cgwallet/common/common.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

enum MyButtonStyle {
  // 无限长度的按钮
  filledButtonLong,

  // 无限长度的按钮
  filledButtonShort,

  // 有限长度的按钮
  textButton,

  // 图片按钮
  iconButton,

  // widegt
  widegt,
}

class MyButton extends StatelessWidget {
  const MyButton({
    super.key,
    required this.myButtonStyle,
    required this.onPressed,
    this.textColor,
    this.buttonColor,
    this.radius,
    this.fontSize,
    required this.child,
  });

  final MyButtonStyle myButtonStyle;
  final void Function()? onPressed;
  final Color? textColor;
  final Color? buttonColor;
  final double? radius;
  final double? fontSize;
  final Widget child;


  // 填充颜色的长按钮
  factory MyButton.filedLong({
    required void Function()? onPressed, 
    required String text,
    Color? textColor,
    Color? color,
    double? radius,
  }) => MyButton(
    myButtonStyle: MyButtonStyle.filledButtonLong,
    onPressed: onPressed,
    textColor: textColor,
    buttonColor: color,
    radius: radius,
    child: FittedBox(child: Text(text)),
  );

  // 填充颜色的长按钮
  factory MyButton.floatLeft({
    required void Function()? onPressed, 
    required String text,
    Color? textColor,
    Color? color,
    double? radius,
  }) => MyButton(
    myButtonStyle: MyButtonStyle.filledButtonLong,
    onPressed: onPressed,
    textColor: textColor,
    buttonColor: color,
    radius: radius,
    child: Container(alignment: Alignment.centerLeft, child: FittedBox(child: Text(text))),
  );

  // 填充颜色的长按钮
  factory MyButton.loading() => MyButton(
    myButtonStyle: MyButtonStyle.filledButtonLong,
    onPressed: null,
    child: Get.theme.myIcons.loadingIcon,
  );

  // 填充颜色的短按钮
  factory MyButton.filedShort({
    required void Function()? onPressed, 
    required String text,
    Color? textColor,
    Color? color,
    double? radius,
  }) => MyButton(
    myButtonStyle: MyButtonStyle.filledButtonShort,
    onPressed: onPressed,
    textColor: textColor,
    buttonColor: color,
    radius: radius,
    child: FittedBox(child: Text(text)),
  );

  // 填充颜色的短按钮
  factory MyButton.filedWidget({
    required void Function()? onPressed, 
    required Widget child,
    Color? color,
    double? radius,
  }) => MyButton(
    myButtonStyle: MyButtonStyle.filledButtonShort,
    onPressed: onPressed,
    buttonColor: color,
    radius: radius,
    child: child
  );

  // 文字按钮
  factory MyButton.text({
    required void Function()? onPressed, 
    required String text,
    Color? textColor,
    double? fontSize,
    double? radius
  }) => MyButton(
    myButtonStyle: MyButtonStyle.textButton,
    onPressed: onPressed,
    textColor: textColor,
    fontSize: fontSize,
    radius: radius,
    child: FittedBox(child: Text(text)),
  );

  factory MyButton.icon({required void Function()? onPressed, required Widget icon}) => MyButton(
    myButtonStyle: MyButtonStyle.iconButton,  
    onPressed: onPressed, 
    child: icon
  );

  // 文字按钮
  factory MyButton.widget({
    required void Function()? onPressed,
    required Widget child
  }) => MyButton(
    myButtonStyle: MyButtonStyle.widegt,
    onPressed: onPressed,
    child: child,
  );

  @override
  Widget build(BuildContext context) {
    switch (myButtonStyle) {
      case MyButtonStyle.filledButtonLong:
        return FilledButton(
          onPressed: onPressed, 
          style: Theme.of(context).myStyles.getButtonFilledLong(
            textColor: textColor,
            buttonColor: buttonColor,
            radius: radius,
          ),
          child: child,
        );

      case MyButtonStyle.filledButtonShort:
        return FilledButton(
          onPressed: onPressed, 
          style: Theme.of(context).myStyles.getButtonFilledShort(
            textColor: textColor,
            buttonColor: buttonColor,
            radius: radius,
          ),
          child: child,
        );

      case MyButtonStyle.textButton:
        return TextButton(
          onPressed: onPressed, 
          style: Theme.of(context).myStyles.getButtonText(
            textColor: textColor,
            fontSize: fontSize,
            radius: radius,
          ),
          child: child,
        );

      case MyButtonStyle.iconButton:
        return IconButton(
          onPressed: onPressed, 
          icon: child,
        );

      default:
        final opacity = 1.0.obs;

        if (onPressed == null) return child;

        return GestureDetector(
          onTap: onPressed,
          onTapDown: (_) => opacity.value = 0.5,
          onTapUp: (_) => opacity.value = 1,
          onTapCancel: () => opacity.value = 1,
          child: Obx(() => Opacity(
            opacity: opacity.value, // 根据状态调整透明度
            child: child,
          )),
        );
    }
  }
}
