
import 'package:cgwallet/common/common.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TutorialListView extends StatelessWidget {
  const TutorialListView({
    super.key,
    required this.tutorialList,
    });
  final TutorialListModel tutorialList;

  @override
  Widget build(BuildContext context) {

    // 第一位：FAQ 对应的下标
    // 第二位：是否展开 0:不展开 1:展开
    final tutorialIndex = [-1, 0].obs;
    
    return MyCard.normal(
      color: Theme.of(context).myColors.cardBackground.withOpacity( 0),
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 0),
      child: Column(children: tutorialList.list.asMap().entries.map((e) => _buildFaqBox(context, e.value, e.key, tutorialIndex)).toList()),
    );
  }

  Widget _buildFaqBox(
    BuildContext context,
    TutorialModel element,
    int index,
    RxList<int> tutorialIndex,
  ) {
    final titleButton = MyButton.widget(
      onPressed: () {
        if (tutorialIndex[0] == index) {
          if (tutorialIndex[1] == 0) {
            tutorialIndex[1] = 1;
          } else {
            tutorialIndex[0] = -1;
            tutorialIndex[1] = 0;
          }
        } else {
          tutorialIndex[0] = index;
          tutorialIndex[1] = 1;
        }
      },
      child: MyCard.faq(padding: const EdgeInsets.fromLTRB(16, 10, 16, 10), child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(child: Obx(() => Text('${index + 1}.  ${element.tutorialTitle}',
            style: tutorialIndex[0] == index && tutorialIndex[1] == 1 
              ? Theme.of(context).myStyles.labelPrimaryBig 
              : Theme.of(context).myStyles.labelBig,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ))),
          const SizedBox(width: 10),
          Obx(() => tutorialIndex[0] == index && tutorialIndex[1] == 1 
            ? Theme.of(context).myIcons.upSolidPrimary
            : Theme.of(context).myIcons.downSolid
          ),
        ],
      )),
    );

    final content = Obx(() => tutorialIndex[0] == index && tutorialIndex[1] == 1
      ? MyCard.faq(child: MyImage(imageUrl: element.address, fit: BoxFit.fitWidth))
      : const SizedBox()
    );

    return MyCard.faq(margin: const EdgeInsets.only(bottom: 6), child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [titleButton, content],
    ));
  }
}