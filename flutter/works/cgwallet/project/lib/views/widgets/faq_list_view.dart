
import 'package:cgwallet/common/common.dart';
import 'package:cgwallet/views/views.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FaqListView extends StatelessWidget {
  const FaqListView({
    super.key,
    required this.faqList,
    this.isShowTitle = true,
    this.isLoading = true,
    });
    
  final FaqListModel faqList;
  final bool isShowTitle;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {

    // 第一位：FAQ 对应的下标
    // 第二位：是否展开 0:不展开 1:展开
    final faqIndex = [-1, 0].obs;

    final title = Row(children: [
      Theme.of(context).myIcons.helpTitleIcon,
      const SizedBox(width: 8),
      Text(Lang.faqTitle.tr, style: Theme.of(context).myStyles.faqViewTitle)
    ]);
    
    return Column(
      children: [
        if (isShowTitle) title,
        if (isShowTitle) const SizedBox(height: 8),
        if (isLoading)
          ...List.generate(20, (index) => _buildEmpty(context))
        else if (faqList.list.isEmpty)
          noDataWidget
        else
          ...faqList.list.asMap().entries.map((e) => _buildFaqBox(context, e.value, e.key, faqIndex))
      ],
    );
  }

  Widget _buildEmpty(BuildContext context){
    return  MyCard.faq(margin: const EdgeInsets.only(bottom: 6), child: Get.theme.myIcons.loading(height: 40, width: double.infinity));
  }

  Widget _buildFaqBox(
    BuildContext context,
    FaqModel element,
    int index,
    RxList<int> faqIndex,
  ) {
    final hot = Stack(
      alignment: Alignment.center,
      children: [
        SizedBox(width: 50, height: 18, child: Theme.of(context).myIcons.helpHot),
        SizedBox(width: 50, height: 18, child: Center(child: Padding(padding: const EdgeInsets.fromLTRB(8, 0, 8, 0), child: FittedBox(child: Text(Lang.faqHot.tr, style: Theme.of(context).myStyles.onButton))))),
      ],
    );

    final normal = Stack(
      alignment: Alignment.center,
      children: [
        SizedBox(width: 50, height: 18, child: Theme.of(context).myIcons.helpNormal),
        SizedBox(width: 50, height: 18, child: Center(child: Padding(padding: const EdgeInsets.fromLTRB(8, 0, 8, 0), child: FittedBox(child: Text(Lang.faqNormal.tr, style: Theme.of(context).myStyles.onButton))))),
      ],
    );

    final titleButton = MyButton.widget(
      onPressed: () {
        if (faqIndex[0] == index) {
          if (faqIndex[1] == 0) {
            faqIndex[1] = 1;
          } else {
            faqIndex[0] = -1;
            faqIndex[1] = 0;
          }
        } else {
          faqIndex[0] = index;
          faqIndex[1] = 1;
        }
      },
      child: MyCard.faq(padding: const EdgeInsets.fromLTRB(16, 10, 16, 10), child: Row(
        children: [
          Expanded(child: Row(children: [
            Flexible(child: Text('${index + 1}.  ${element.name}',
              style: Theme.of(context).myStyles.faqTitle,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            )),
            // const SizedBox(width: 10),
            if (element.mark != 0)
              element.mark == 2 ? hot : normal,
          ])),
          const SizedBox(width: 10),
          Obx(() => faqIndex[0] == index && faqIndex[1] == 1 
            ? Theme.of(context).myIcons.up
            : Theme.of(context).myIcons.down
          ),
        ],
      )),
    );

    final content = Obx(() => faqIndex[0] == index && faqIndex[1] == 1
      ? MyCard.faq(padding: const EdgeInsets.fromLTRB(16, 6, 16 , 16), child: element.type == 0
        ? MyHtml(data: element.describe)
        : MyImage(
            imageUrl: element.describe,
            fit: BoxFit.fitWidth,
          ))
      : const SizedBox()
    );

    return MyCard.faq(margin: const EdgeInsets.only(bottom: 6), child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [titleButton, content],
    ));
  }
}