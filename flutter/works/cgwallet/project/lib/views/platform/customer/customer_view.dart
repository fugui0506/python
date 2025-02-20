import 'package:cgwallet/common/common.dart';
import 'package:cgwallet/views/views.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomerView extends GetView<CustomerController> {
  const CustomerView({super.key});

  @override
  Widget build(BuildContext context) {
    /// appbar
    var appBar = MyAppBar.normal(
      title: controller.state.title,
      // actions: [
      //   MyButton.icon(onPressed: () {
      //     MyConfig.channel.channelQicaht.invokeMethod('sendText', <String, dynamic> {
      //       'content': '12313',
      //     });
      //   }, icon: Theme.of(context).myIcons.customer)
      // ],
    );

    /// 页面构成
    return Scaffold(
      appBar: appBar,
      backgroundColor: Theme.of(context).myColors.background,
      body: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    return Obx(() => controller.state.isLoading ? loadingWidget : controller.state.isNodata ? noDataWidget : _buildContent(context));
  }

  Widget _buildContent(BuildContext context) {
    // final icon = SizedBox(width: 40, child: Theme.of(context).myIcons.customerItem);
    final chatBox = Padding(padding: const EdgeInsets.all(16), child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
      SizedBox(width: 40, child: Theme.of(context).myIcons.customerAvatar),
      const SizedBox(width: 10),
      Expanded(child: MyCard.normal(
        padding: const EdgeInsets.all(16),
        child: Column(children: UserController.to.userInfo.value.token.isNotEmpty
            ? UserController.to.customerData.value.customer.asMap().entries.map((e) => MyButton.widget(
                onPressed: () => controller.onLoginCustomer(UserController.to.customerData.value.urlApi, UserController.to.customerData.value.urlImg, e.value),
                child: MyCard(
                  margin: e.key == UserController.to.customerData.value.customer.length - 1 ? null : const EdgeInsets.only(bottom: 16),
                  child: Row(children: [
                    MyCard.avatar(radius: 18, border: Border.all(color: Theme.of(context).myColors.itemCardBackground), child: MyImage(imageUrl: e.value.customerServiceAvatar)),
                    const SizedBox(width: 10),
                    Text(e.value.remark, style: Theme.of(context).myStyles.label),
                    const Spacer(),
                    Obx(() => UserController.to.customerHistoryList.value.getHistory(e.value.cret).newLength > 0
                      ? MyCard.avatar(radius: 8, color: Theme.of(context).myColors.error, child: Center(child: FittedBox(child: Text('${UserController.to.customerHistoryList.value.getHistory(e.value.cret).newLength}', style: Theme.of(context).myStyles.labelLight))))
                      : const SizedBox(),
                    )
                  ]),
                ),
              ),
              ).toList()
            : UserController.to.guestCustomerData.value.customer.asMap().entries.map((e) => MyButton.widget(
                onPressed: () => controller.onTouristCustomer(UserController.to.guestCustomerData.value.urlApi, UserController.to.guestCustomerData.value.urlImg, e.value),
                child: MyCard(
                  margin: e.key == UserController.to.guestCustomerData.value.customer.length - 1 ? null : const EdgeInsets.only(bottom: 16),
                  child: Row(children: [
                    MyCard.avatar(radius: 18, border: Border.all(color: Theme.of(context).myColors.itemCardBackground), child: MyImage(imageUrl: e.value.customerServiceAvatar)),
                    const SizedBox(width: 10), Text(e.value.remark, style: Theme.of(context).myStyles.label)
                  ]),
          ),
        )).toList()),
      )),
    ]));

    final chatFaqBox = MyCard.normal(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      color: Theme.of(context).myColors.cardBackground,
      child: Column(children: [
        Text(Lang.faqTitle.tr, style: Theme.of(context).myStyles.labelPrimaryBig),
        const SizedBox(height: 16),
        Column(children: controller.state.chatFaqTypeList.value.list.asMap().entries.map((e) => MyButton.widget(
          onPressed: () {
            Get.toNamed(MyRoutes.chatFaqListView, arguments: e.value);
          },
          child: MyCard(
            width: double.infinity,
            padding: const EdgeInsets.only(top: 10, bottom: 10),
            margin: e.key == controller.state.chatFaqTypeList.value.list.length - 1 ? null : const EdgeInsets.only(bottom: 8),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: Theme.of(context).myColors.primary.withOpacity( 0.3),
              width: 1,
            ),
            color: Theme.of(context).myColors.primary.withOpacity( 0.1),
            child: Text('${e.value.sort}. ${e.value.categoryName}', style: Theme.of(context).myStyles.labelPrimary, textAlign: TextAlign.center),
          ),
        )).toList())
      ]),
    );

    return SingleChildScrollView(child: Column(children: [
      chatBox,
      Obx(() => controller.state.chatFaqTypeList.value.list.isEmpty || UserController.to.userInfo.value.token.isNotEmpty ? const SizedBox() : chatFaqBox)
    ]));
  }
}
