import 'package:cgwallet/common/common.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MyCard extends StatelessWidget {
  const MyCard({
    super.key,
    this.color,
    this.borderRadius,
    this.width,
    this.height,
    this.child,
    this.padding,
    this.margin,
    this.boxShadow,
    this.border,
    this.gradient,
    this.constraints,
  });

  final Color? color;
  final BorderRadiusGeometry? borderRadius;
  final double? width;
  final double? height;
  final Widget? child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final List<BoxShadow>? boxShadow;
  final BoxBorder? border;
  final Gradient? gradient;
  final BoxConstraints? constraints;

  factory MyCard.login({Widget? child}) => MyCard(
    color: Get.theme.myColors.cardBackground,
    width: double.infinity,
    borderRadius: BorderRadius.circular(20),
    margin: const EdgeInsets.all(20),
    child: child,
  );

  factory MyCard.loading({Widget? child}) => MyCard(
    color: Get.theme.myColors.loadingBackground,
    width: 60,
    height: 60,
    borderRadius: BorderRadius.circular(10),
    child: child,
  );

  factory MyCard.snackbar(String message) => MyCard(
    color: Get.theme.myColors.dark.withOpacity( 0.72),
    padding: const EdgeInsets.all(16),
    borderRadius: BorderRadius.circular(8),
    child: Text(message, style: Get.theme.myStyles.contentLight, textAlign: TextAlign.center),
  );

  factory MyCard.avatar({required double radius, Widget? child, Color? color, BoxBorder? border, List<BoxShadow>? boxShadow}) => MyCard(
    color: color ?? Get.theme.myColors.buttonDisable,
    width: radius * 2,
    height: radius * 2,
    borderRadius: BorderRadius.circular(radius),
    border: border,
    boxShadow: boxShadow,
    child: ClipRRect(
      borderRadius: BorderRadius.circular(radius / 2.5),
      child: child,
    ),
  );

  factory MyCard.carousel({Widget? child}) => MyCard(
    color: Get.theme.myColors.cardBackground,
    width: double.infinity,
    height: (Get.width - 32) * 120 / 360,
    borderRadius: BorderRadius.circular(10),
    border: Border.all(width: 1, color: Get.theme.myColors.carouselBorder),
    boxShadow: [BoxShadow(blurRadius: 8,color: Colors.black.withOpacity( 0.08))], 
    child: ClipRRect(
      borderRadius: BorderRadius.circular(4),
      child: child,
    ),
  );

  factory MyCard.normal({Widget? child, EdgeInsetsGeometry? padding, EdgeInsetsGeometry? margin, Color? color}) => MyCard(
    color: color ?? Get.theme.myColors.cardBackground,
    borderRadius: BorderRadius.circular(10),
    padding: padding,
    margin: margin,
    child: ClipRRect(
      borderRadius: BorderRadius.circular(4),
      child: child,
    ),
  );

  factory MyCard.dialog({Widget? child}) => MyCard(
    color: Get.theme.myColors.cardBackground,
    borderRadius: BorderRadius.circular(10),
    padding: const EdgeInsets.all(16),
    gradient: LinearGradient(
      colors: [
        Get.theme.myColors.primary.withOpacity( 0),
        Get.theme.myColors.cardBackground.withOpacity( 0.25),
      ],
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      stops: const [0.0, 1],
    ),
    child: ClipRRect(
      borderRadius: BorderRadius.circular(4),
      child: child,
    ),
  );

  factory MyCard.big({Widget? child}) => MyCard(
    color: Get.theme.myColors.cardBackground,
    borderRadius: BorderRadius.circular(20),
    padding: const EdgeInsets.all(16),
    child: child,
  );

  factory MyCard.bottomSheet({required Widget child, EdgeInsetsGeometry? padding}) => MyCard(
    color: Get.theme.myColors.cardBackground,
    constraints: BoxConstraints(maxHeight: Get.height * 0.9),
    borderRadius: const BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
    padding: padding ?? const EdgeInsets.all(32),
    child: SafeArea(child: child),
  );

  factory MyCard.faq({Widget? child, EdgeInsetsGeometry? padding, EdgeInsetsGeometry? margin,}) => MyCard(
    color: Get.theme.myColors.cardBackground,
    borderRadius: BorderRadius.circular(10),
    padding: padding,
    margin: margin,
    child: child,
  );

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: constraints,
      width: width,
      height: height,
      padding: padding,
      margin: margin,
      decoration: BoxDecoration(
        color: color,
        borderRadius: borderRadius,
        shape: BoxShape.rectangle,
        boxShadow: boxShadow,
        border: border,
        gradient: gradient,
      ),
      clipBehavior: Clip.antiAlias,
      child: child,
    );
  }
}