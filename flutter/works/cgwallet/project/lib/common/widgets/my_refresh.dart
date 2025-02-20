import 'package:cgwallet/common/common.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

/// ## 通用下拉刷新组件
/// ### 参数一：controller 必传，方便控制刷新的一些控制
/// ### 参数二：onRefresh 是下拉刷新的方法，可选
/// - 传入了这个方法会自动打开允许下拉刷新，
/// 也会自动填充下拉刷新的样式
/// ### 参数三：onLoading 是上拉加载更多数据的方法，可选
/// - 传入了这个方法会自动打开允许上拉加载，
/// 也会自动填充上拉的样式
/// ### 参数四：child 需要传入各种滑动组件
/// - 不传的话没有效果
class MyRefreshView extends StatelessWidget {
  const MyRefreshView({
    super.key,
    required this.controller,
    this.onRefresh,
    this.onLoading,
    required this.children,
    this.scrollController,
    this.padding,
  });
  final RefreshController controller;
  final void Function()? onRefresh;
  final void Function()? onLoading;
  final List<Widget> children;
  final ScrollController? scrollController;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    final header = WaterDropHeader(
      refresh: Center(child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        Theme.of(context).myIcons.loadingIcon,
        const SizedBox(width: 8),
        Text(Lang.refreshOnLoading.tr, style: Theme.of(context).myStyles.labelSmall),
      ])),
      complete: Center(child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        MyCard.avatar(radius: 8, color: Theme.of(context).myColors.secondary, child: Theme.of(context).myIcons.done),
        const SizedBox(width: 8),
        Text(Lang.refreshDone.tr, style: Theme.of(context).myStyles.labelSmall),
      ])),
    );

    final footer = CustomFooter(
      height: 80,
      builder: (context, mode) {
        Widget body;
        if (mode == LoadStatus.idle) {
          body = Text(Lang.refreshLoading.tr, style: Theme.of(context).myStyles.labelSmall);
        } else if (mode == LoadStatus.loading) {
          body = Get.theme.myIcons.loadingIcon;
        } else if (mode == LoadStatus.failed) {
          body = Text(Lang.refreshLoadingFailed.tr, style: Theme.of(context).myStyles.labelSmall);
        } else if (mode == LoadStatus.canLoading) {
          body = Text(Lang.refreshLoadingDrop.tr, style: Theme.of(context).myStyles.labelSmall);
        } else {
          body = Text(Lang.refreshLoadingNoData.tr, style: Theme.of(context).myStyles.labelSmall);
        }
        return SizedBox(
          height: 55.0,
          child: Center(child: body),
        );
      },
    );

    return SmartRefresher(
      // 是否允许下拉刷新
      // 如果没有传入刷新的方法，这里就直接定义为 false
      enablePullDown: onRefresh == null ? false : true,
      // 是否允许上拉加载新数据
      // 如果没有传入相应的方法，这里就直接定义为 false
      enablePullUp: onLoading == null ? false : true,
      header: onRefresh == null ? null : header,
      footer: onLoading == null ? null : footer,
      controller: controller,
      onRefresh: onRefresh,
      onLoading: onLoading,
      child: ListView(
        controller: scrollController,
        padding: padding,
        children: children,
      ),
    );
  }
}
