
import 'package:cgwallet/common/common.dart';
import 'package:cgwallet/views/views.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:get/get.dart';
import 'package:alphabet_list_view/alphabet_list_view.dart';

class BanksView extends GetView<BanksController> {
  const BanksView({super.key});

  @override
  Widget build(BuildContext context) {
    /// appbar
    final appBar = MyAppBar.normal(title: Lang.bankViewTitle.tr);

    /// 页面构成
    return KeyboardDismissOnTap(child: Scaffold(
      appBar: appBar,
      body: Obx(() => _buildBody(context)),
      backgroundColor: Theme.of(context).myColors.background,
    ));
  }

  Widget _buildBody(BuildContext context) {
    return controller.state.isLoading 
      ? loadingWidget 
      : controller.state.bankNameMapList.value.list.isEmpty 
        ? noDataWidget 
        : Column(children: [_buildSearch(context), Expanded(child: _buildAlphabetListView(context))]);
  }

  Widget _buildSearch(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 10),
      child: MyInput.search(controller.searchController, controller.serachNode, Lang.bankViewHintText.tr, 
        MyButton.filedShort(
          onPressed: controller.onSearch, 
          text: Lang.search.tr,
        ),
      ),
    );
  }

  Widget _buildAlphabetListView(BuildContext context) {
    final List<AlphabetListViewItemGroup> tech = controller.state.bankNameMapList.value.list.map((e) => AlphabetListViewItemGroup(
      tag: e.typeName,
      children: e.bankNameList.map((e) => MyButton.widget(onPressed: () => controller.onChoice(e), child: MyCard(
        padding: const EdgeInsets.all(16),
        child: Text(e.bankName, style: Theme.of(context).myStyles.label),
      ))).toList(),
    )).toList();

    final AlphabetListViewOptions options = AlphabetListViewOptions(
      listOptions: ListOptions(
        listHeaderBuilder: (context, symbol) {
          return Container(
            height: 40,
            padding: const EdgeInsets.only(left: 16, top: 10),
            color: Theme.of(context).myColors.banksTag,
            child: Text(symbol),
          );
        },
      ),
      scrollbarOptions: ScrollbarOptions(
         symbolBuilder: (context, symbol, state) {
            switch (state) {
              case AlphabetScrollbarItemState.active:
                return Center(child: Text(symbol, style: Theme.of(context).myStyles.labelPrimary));
              case AlphabetScrollbarItemState.inactive:
                return Center(child: Text(symbol, style:Theme.of(context).myStyles.label));
              default:
                return Center(child: Text(symbol, style:Theme.of(context).myStyles.labelSmall));
            }
          },
      ),
      overlayOptions: OverlayOptions(
        overlayBuilder: (context, symbol) {
            return MyCard.normal(
              padding: const EdgeInsets.all(16),
              color: Theme.of(context).myColors.primary,
              child: Text(symbol, style: Theme.of(context).myStyles.contentLight),
            );
          },
      ),
    );


    var searchBox = ListView.separated(
      controller: controller.scrollController,
      padding: const EdgeInsets.only(left: 16, right: 16),
      separatorBuilder: (context, index) => const Divider(height: 10, color: Colors.transparent),
      itemCount: controller.state.currtent.length,
      itemBuilder: (context, int index) {
        final model = controller.state.currtent[index];
        return MyButton.widget(
          onPressed: () => controller.onChoice(model),
          child: MyCard.normal(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                const SizedBox(width: 20),
                Text(model.bankName)
              ],
            ),
          ),
        );
      },
    );

    return controller.state.isSearch 
      ? controller.state.currtent.isEmpty ? noDataWidget : searchBox 
      : AlphabetListView(scrollController: controller.scrollController, items: tech, options: options);
  }
}
