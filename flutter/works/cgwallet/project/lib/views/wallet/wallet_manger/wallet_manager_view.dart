import 'package:cgwallet/common/common.dart';
import 'package:cgwallet/views/views.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';

class WalletMangerView extends GetView<WalletMangerController> {
  const WalletMangerView({super.key});

  @override
  Widget build(BuildContext context) {
    final buttonAdd = MyButton.widget(onPressed: controller.onAdd, child: Container(
      color: Theme.of(context).myColors.background.withOpacity( 0),
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
      height: double.infinity,
      child: Row(children: [
        Theme.of(context).myIcons.add,
        const SizedBox(height: 10),
        Text(Lang.walletManagerViewAdd.tr, style: Theme.of(context).myStyles.label)
      ])
    ));

    /// appbar
    var appBar = MyAppBar.normal(
      title: controller.state.title,
      actions: [Obx(() => UserController.to.categoryList.value.list.isEmpty ? const SizedBox() :  buttonAdd)]
    );

    /// 页面构成
    return Scaffold(
      appBar: appBar, 
      backgroundColor: Theme.of(context).myColors.background,
      body: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    return Column(children: [
      _buildHeader(context),
      Expanded(child: Obx(() => UserController.to.categoryList.value.list.isEmpty ? noDataWidget : SafeArea(child: Obx(() => _buildContent(context)))))
    ]);
  }

  Widget _buildHeader(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.only(left: 16, right: 16),
      scrollDirection: Axis.horizontal, 
      child: Obx(() => Row(children: UserController.to.categoryList.value.list.asMap().entries.map(
        (e) => _buildItemHeader(context, e.key, e.value.categoryName)).toList()
      ))
    );
  }

  Widget _buildItemHeader(BuildContext context, int index, String title) {
    final button = Obx(() => MyButton.filedShort(
      onPressed: () => controller.onIndex(index), 
      color: controller.state.index == index ? Theme.of(context).myColors.primary : Theme.of(context).myColors.cardBackground,
      textColor: controller.state.index == index ? Theme.of(context).myColors.onPrimary : Theme.of(context).myColors.textDefault,
      text: title,
    ));

    return controller.state.index == UserController.to.categoryList.value.list.length
      ? button
      : Row(children: [button, const SizedBox(width: 10)]);
  }

  Widget _buildContent(BuildContext context) {
    if (controller.state.isLoading) {
      return loadingWidget;
    }

    final data = UserController.to.bankList.value.list[controller.state.index].list;

    if(data.isEmpty) {
      final emptyBox = getBankInfoEmptyWidget(UserController.to.categoryList.value.list[controller.state.index].categoryName);
      return SingleChildScrollView(padding: const EdgeInsets.all(16), child: MyButton.widget(onPressed: controller.onAdd, child: emptyBox));
    }

    return Stack(children: [
      // GestureDetector(onTap: controller.close),
      SlidableAutoCloseBehavior(child: SingleChildScrollView(
        padding: const EdgeInsetsDirectional.all(16),
        child: Column(children: data.asMap().entries.map((e) => _buildCardItem(context, e.value, e.key)).toList()),
      )),
    ]);
  }

  Widget _buildCardItem(BuildContext context, BankInfoModel bankInfo, int index) {
    final data = UserController.to.bankList.value.list[controller.state.index].list;

    final setDefault = SlidableAction(
      onPressed: (context) => controller.onSetDefault(bankInfo),
      backgroundColor: Theme.of(context).myColors.primary,
      foregroundColor: Theme.of(context).myColors.light,
      icon: Icons.star,
      spacing: 8,
      label: Lang.walletManagerViewDefaultSet.tr,
      padding: const EdgeInsets.all(8),
    );

    final alreadyDefault = SlidableAction(
      onPressed: (context) => controller.onAllready(),
      backgroundColor: Theme.of(context).myColors.secondary,
      foregroundColor: Theme.of(context).myColors.light,
      icon: Icons.check,
      spacing: 8,
      label: Lang.walletManagerViewDefaultAlready.tr,
      padding: const EdgeInsets.all(8),
    );

    final delete = SlidableAction(
      onPressed: (context) => controller.onDeleteAccount(bankInfo),
      backgroundColor: Theme.of(context).myColors.error,
      foregroundColor: Theme.of(context).myColors.light,
      icon: Icons.delete_forever,
      spacing: 8,
      label: Lang.delete.tr,
      padding: const EdgeInsets.all(8),
    );
    
    return BankInfoCard(
      groupTag: controller.state.index,
      // slidableController: controller.slidableController,
      icon: bankInfo.isDefault == 1 ? Text(Lang.walletManagerViewDefault.tr, style: Theme.of(context).myStyles.labelPrimary) : null,
      margin: index == data.length - 1 ? null : const EdgeInsets.only(bottom: 10),
      bankInfo: bankInfo,
      actions: [bankInfo.isDefault == 1 ? alreadyDefault : setDefault, delete]
    );
  }
}
