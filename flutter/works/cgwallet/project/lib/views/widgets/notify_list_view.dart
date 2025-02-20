
import 'package:cgwallet/common/common.dart';
import 'package:cgwallet/views/views.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NotifyListView extends StatelessWidget {
  const NotifyListView({
    super.key,
    required this.data,
    this.isLoading = true,
    this.itemPressed,
    });
    
  final NotifyListModel data;
  final bool isLoading;
  final void Function(int)? itemPressed;

  @override
  Widget build(BuildContext context) {
    
    return Column(
      children: [
        if (isLoading)
          ...List.generate(20, (index) => _buildEmpty(context))
        else if (data.list.isEmpty)
          noDataWidget
        else
          ...data.list.asMap().entries.map((e) => _buildNotifyBox(context, e.value, e.key))
      ],
    );
  }

  Widget _buildEmpty(BuildContext context){
    return  MyCard.faq(margin: const EdgeInsets.only(bottom: 6), child: Get.theme.myIcons.loading(height: 40, width: double.infinity));
  }

  Widget _buildNotifyBox(
    BuildContext context,
    NotifyModel element,
    int index,
  ) {
    final title = Text(element.title.removeHtmlTags(),
      style: element.isRead == 0 ? Theme.of(context).myStyles.labelPrimaryBigger : Theme.of(context).myStyles.labelBigger,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );

    final titleButton =  Row(children: [
      if(element.isRead == 0)
        MyCard.avatar(radius: 4, color: Theme.of(context).myColors.error),
      if(element.isRead == 0)
        const SizedBox(width: 8),
      Flexible(child: title),
    ]);

    final createTime = Text(element.createdTime, style: Theme.of(context).myStyles.labelSmall);

    final content = Text(element.content.removeHtmlTags(), style: Theme.of(context).myStyles.labelSmall, maxLines: 2, overflow: TextOverflow.ellipsis);

    // final readMore = Row(children: [
    //   const Spacer(),
    //   Text(Lang.notifyViewMore.tr, style: Theme.of(context).myStyles.labelSmall)
    // ]);
    
    return MyButton.widget(
      onPressed: () async {
        UserController.to.dio?.post(ApiPath.me.readNotify, data: {"id": element.id});
        final card = Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            MyHtml(data: element.title),
            const SizedBox(width: double.infinity), 
            createTime, 
            const SizedBox(height: 16), 
            Flexible(child: SingleChildScrollView(child: MyHtml(data: element.content),)),
            const SizedBox(height: 16), 
            MyButton.filedLong(
              onPressed: () => Get.back(), 
              text: Lang.close.tr, 
              color: Get.theme.myColors.itemCardBackground, 
              textColor: Get.theme.myColors.onCardBackground,
            ),
          ],
        );
        await MyAlert.show(
          margin: 32,
          child: card,
        );
        itemPressed?.call(index);
      }, 
      child: MyCard.normal(
        color: Theme.of(context).myColors.cardBackground,
        padding: const EdgeInsets.all(16),
        margin: const EdgeInsets.only(bottom: 10), 
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            titleButton, 
            const SizedBox(height: 6), 
            createTime, 
            const SizedBox(height: 6), 
            content,
            // const SizedBox(height: 6),
            // readMore,
          ],
        ),
      ),
    );
  }
}