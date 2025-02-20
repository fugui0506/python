import 'package:flutter/material.dart';
import 'package:cgwallet/common/common.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

Widget get _flexibleSpace => Container(
  decoration: BoxDecoration(
    gradient: LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        Get.theme.myColors.appBarGradientStart,
        Get.theme.myColors.appBarGradientEnd,
      ],
      stops: const [0.0, 1],
    ),
  ),
);

class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Widget? title;
  final List<Widget>? actions;
  final Widget? leading;
  final bool automaticallyImplyLeading;
  final double elevation;
  final ShapeBorder? shape;
  final TextTheme? textTheme;
  final bool centerTitle;
  final double? titleSpacing;
  final Color? backgroundColor;
  final Widget? flexibleSpace;
  final TextStyle? titleTextStyle;
  final IconThemeData? iconTheme;
  final PreferredSizeWidget? bottom;
  final SystemUiOverlayStyle? systemOverlayStyle;


  const MyAppBar({
    super.key,
    this.title,
    this.actions,
    this.leading,
    this.automaticallyImplyLeading = true,
    this.elevation = 0.0,
    this.shape,
    this.textTheme,
    this.centerTitle = true,
    this.titleSpacing,
    this.backgroundColor,
    this.flexibleSpace,
    this.iconTheme,
    this.titleTextStyle,
    this.bottom,
    this.systemOverlayStyle,
  });

  // 普通的 appbar
  factory MyAppBar.normal({String? title, List<Widget>? actions}) => MyAppBar(
    backgroundColor: Get.theme.myColors.background,
    title: title == null ? null : Text(title, maxLines: 1),
    titleTextStyle: Get.theme.myStyles.appBarTitle,
    iconTheme: Get.theme.myStyles.appBarIconThemeData,
    actions: actions,
    flexibleSpace: _flexibleSpace,
  );

  factory MyAppBar.normalWidget({Widget? title, List<Widget>? actions}) => MyAppBar(
    backgroundColor: Get.theme.myColors.background,
    title: title,
    titleTextStyle: Get.theme.myStyles.appBarTitle,
    iconTheme: Get.theme.myStyles.appBarIconThemeData,
    actions: actions,
    titleSpacing: 0,
    flexibleSpace: _flexibleSpace,
  );

  // 透明的
  factory MyAppBar.transparent({String? title, List<Widget>? actions}) => MyAppBar(
    backgroundColor: Get.theme.myColors.background.withOpacity( 0),
    title: title == null ? null : Text(title, maxLines: 1),
    actions: actions,
    titleTextStyle: Get.theme.myStyles.appBarTitle,
    iconTheme: Get.theme.myStyles.appBarIconThemeData,
    elevation: 0,
  );

  // 首页的banner
  factory MyAppBar.spacer({Widget? title, Widget? flexibleSpace, PreferredSizeWidget? bottom}) => MyAppBar(
    backgroundColor: Colors.transparent,
    title: title,
    titleSpacing: 0,
    flexibleSpace: flexibleSpace,
    bottom: bottom,
    iconTheme: Get.theme.myStyles.appBarIconThemeData,
  );

  // scan 专用（白色）
  factory MyAppBar.white({required String title}) {
    final whiteAppbarTitleTextStyle = TextStyle(
      color: Get.theme.myColors.onPrimary,
      fontSize: 18,
    );
    final whiteAppBarIconThemeData = IconThemeData(
      size: 18,
      color: Get.theme.myColors.onPrimary,
    );
    return MyAppBar(
      backgroundColor: Colors.transparent,
      title: Text(title, maxLines: 1),
      titleTextStyle: whiteAppbarTitleTextStyle,
      iconTheme: whiteAppBarIconThemeData,
    );
  }

  factory MyAppBar.color({String? title, Color? color, List<Widget>? actions}) {
    final whiteAppbarTitleTextStyle = TextStyle(
      color: Get.theme.myColors.onPrimary,
      fontSize: 18,
    );
    final whiteAppBarIconThemeData = IconThemeData(
      size: 18,
      color: Get.theme.myColors.onPrimary,
    );
    return MyAppBar(
      backgroundColor: color,
      title: title == null ? null : Text(title, maxLines: 1),
      titleTextStyle: whiteAppbarTitleTextStyle,
      iconTheme: whiteAppBarIconThemeData,
      actions: actions,
      elevation: 0.0,
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      titleTextStyle: titleTextStyle,
      automaticallyImplyLeading: automaticallyImplyLeading,
      backgroundColor: backgroundColor,
      elevation: elevation,
      shape: shape,
      iconTheme: iconTheme,
      centerTitle: centerTitle,
      titleSpacing: titleSpacing,
      flexibleSpace: flexibleSpace,
      leading: leading,
      title: title,
      actions: actions,
      bottom: bottom,
      systemOverlayStyle: systemOverlayStyle,
      // leadingWidth: 40,
      scrolledUnderElevation: 0
    );
  }

  @override
  Size get preferredSize {
    final bottomHeight = bottom?.preferredSize.height ?? 0.0;
    return Size.fromHeight(kToolbarHeight + bottomHeight);
  }
}