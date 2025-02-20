import 'package:cgwallet/common/common.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class QichatReplyListView extends StatelessWidget {
  const QichatReplyListView({
    super.key,
    required this.data,
    this.itemPressed,
    required this.openIndex,
  });
    
  final AutoReplyItemModel data;
  final void Function(Qa, List<int>)? itemPressed;
  final List<int> openIndex;

  @override
  Widget build(BuildContext context) {

    // 第一位：FAQ 对应的下标
    // 第二位：是否展开 0:不展开 1:展开
    final itemIndex = openIndex.obs;
    
    return Column(
      children: data.qa.asMap().entries.map((e) => _buildItem(context, e.value, e.key, itemIndex)).toList(),
    );
  }

  Widget _buildItem(
    BuildContext context,
    Qa element,
    int index,
    RxList<int> itemIndex,
  ) {
    final title = MyButton.widget(
      onPressed: () {
        if (itemIndex[0] == index) {
          if (itemIndex[1] == 0) {
            itemIndex[1] = 1;
          } else {
            itemIndex[0] = -1;
            itemIndex[1] = 0;
          }
        } else {
          itemIndex[0] = index;
          itemIndex[1] = 1;
        }

        if (element.related.isEmpty) {
          itemPressed?.call(element, itemIndex);
        }
      },
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(child: Text('${index + 1}. ${element.question.content.data}',
            style: Theme.of(context).myStyles.labelPrimary,
          )),
          if (element.related.isNotEmpty)
            const SizedBox(width: 10),
          if (element.related.isNotEmpty)
            Obx(() => itemIndex[0] == index && itemIndex[1] == 1 
              ? Theme.of(context).myIcons.upPrimary
              : Theme.of(context).myIcons.downPrimary
            ),
        ],
      ),
    );

    final content = Obx(() => itemIndex[0] == index && itemIndex[1] == 1 && element.related.isNotEmpty
      ? MyCard.normal(
          color: Theme.of(context).myColors.cardBackground,
          padding: const EdgeInsets.all(10),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: element.related.asMap().entries.map(
            (e) => MyButton.widget(
              onPressed: () {
                itemPressed?.call(e.value, itemIndex);
              }, 
              child: Column(children: [
                Text('${e.key + 1}. ${e.value.question.content.data}', style: Theme.of(context).myStyles.content),
                const SizedBox(height: 4),
              ]),
            ),
          ).toList()),
        )
      : const SizedBox()
    );

    return MyCard(margin: const EdgeInsets.only(bottom: 2), child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [title, const SizedBox(height: 4), content],
    ));
  }
}