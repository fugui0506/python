import 'package:cgwallet/common/common.dart';
import 'package:cgwallet/views/views.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';


void getNoticeBox({required PublicNoteListModel data}) async {
  final index = 0.obs;
  const padding = EdgeInsets.fromLTRB(16, 0, 16, 0);

  final carousel = SizedBox(height: 320, child: PageView(
      onPageChanged: (i) => index.value = i,
      children: data.list.map((e) => Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Container(
          decoration: BoxDecoration(
            image: Get.theme.myIcons.noticeBackground,
          ),
          child: MyHtml(
            data: e.title,
            padding: HtmlPaddings.all(16),
            alignment: Alignment.center,
            textAlign: TextAlign.center,
            // maxLines: 1,
            // textOverflow: TextOverflow.ellipsis,
          ),
        ),
        Expanded(child: SingleChildScrollView(padding: padding, child: MyHtml(data: e.content))),
        Padding(padding: padding, child: Text(e.createdTime, style: Get.theme.myStyles.labelSmall),),
      ])).toList()
  ));

  final content = IntrinsicHeight(
    child: Material(
      color: Get.theme.myColors.cardBackground.withOpacity( 0),
      child: Column(
        children: [
          carousel,
          const SizedBox(height: 16),
        ],
      ),
    ),
  );

  final card = MyCard.normal(
    color: Get.theme.myColors.cardBackground,
    // padding: const EdgeInsets.all(20),
    margin: const EdgeInsets.fromLTRB(32, 0, 32, 0),
    child: content,
  );

  Get.dialog(Column(mainAxisAlignment: MainAxisAlignment.center, children: [
    Flexible(child: card),
    const SizedBox(height: 16),
    closeWidget,
  ]));
}

void getNoticesBox({required PublicNoteListModel data, required bool isPublicNotice, int index = 0}) async {
  final pageIndex = index.obs;
  const padding = EdgeInsets.fromLTRB(16, 0, 16, 0);
  final isHide = false.obs;
  final controller = PageController(initialPage: pageIndex.value);

  String shardKey = isPublicNotice
    ? MyConfig.shard.isHidePublicNoticeKey
    : MyConfig.shard.isHideMarketNoticeKey;

  shardKey = '${shardKey}_${UserController.to.userInfo.value.user.id}';

  final noticeHide = await MyShared.to.get(shardKey);
  // print('shardKey -> $shardKey');
  // print('noticeHide -> $noticeHide');
  
  if (noticeHide.isNotEmpty) {
    isHide.value = true;
  }

  final carousel = SizedBox(height: 320, child: PageView(
    controller: controller,
    onPageChanged: (i) => pageIndex.value = i,
    children: data.list.map((e) => Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Container(
        decoration: BoxDecoration(
          image: Get.theme.myIcons.noticeBackground,
        ),
        child: MyHtml(
          data: e.title,
          padding: HtmlPaddings.all(16),
          alignment: Alignment.center,
          textAlign: TextAlign.center,
          // maxLines: 1,
          // textOverflow: TextOverflow.ellipsis,
        ),
      ),
      Expanded(child: SingleChildScrollView(padding: padding, child: MyHtml(data: e.content))),
      const SizedBox(height: 16),
      Padding(padding: padding, child: Text(e.createdTime, style: Get.theme.myStyles.labelSmall),),
    ])).toList()
  ));

  // final select = MyCard.avatar(radius:4, color: Get.theme.myColors.primary);
  // final unselect = MyCard.avatar(radius:4);
  //
  // final points = Padding(padding: padding, child: Row(
  //   mainAxisAlignment: MainAxisAlignment.center,
  //   crossAxisAlignment: CrossAxisAlignment.center,
  //   children: data.list.asMap().entries.map((i) => i.key != data.list.length - 1
  //     ? Row(children: [
  //       Obx(() => i.key == pageIndex.value ? select : unselect),
  //       const SizedBox(width: 4)
  //     ])
  //     : Obx(() => i.key == pageIndex.value ? select : unselect)).toList(),
  // ));

  final buttonNext = MyButton.filedLong(onPressed: () {
    controller.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.linear);
  }, text: Lang.next.tr);
  // final buttonPrev = MyButton.filedLong(color: Get.theme.myColors.buttonUnselect, textColor: Get.theme.myColors.onButtonUnselect, onPressed: () {
  //   controller.previousPage(duration: const Duration(milliseconds: 300), curve: Curves.linear);
  // }, text: Lang.previous.tr);
  final buttonClose = MyButton.filedLong(onPressed: () {
    Get.back(result: true);
  }, text: Lang.iKnown.tr);

  final buttons = Padding(padding: padding, child: Obx(() {
    return pageIndex.value == data.list.length - 1
        ? buttonClose
        : buttonNext;
  }));

  final checkBox = Padding(padding: padding, child: MyButton.widget(
      onPressed: () => isHide.value = !isHide.value,
      child: Row(children: [
        Obx(() => isHide.value ? Get.theme.myIcons.noticeHide1 : Get.theme.myIcons.noticeHide0),
        const SizedBox(width: 6),
        Text(Lang.hideNoticeToday.tr, style: Get.theme.myStyles.label),
      ]
      )));

  final content = IntrinsicHeight(
    child: Material(
      color: Get.theme.myColors.cardBackground.withOpacity( 0), 
      child: Column(
        // crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          carousel, 
          Obx(() => pageIndex.value == data.list.length - 1 ? Column(children: [
            const SizedBox(height: 16),
            checkBox,
          ]) : const SizedBox()),
          const SizedBox(height: 16),
          // points,
          // const SizedBox(height: 16),
          buttons,
          const SizedBox(height: 16),
        ],
      ),
    ),
  );

  final card = MyCard.normal(
    color: Get.theme.myColors.cardBackground,
    // padding: const EdgeInsets.all(20),
    margin: const EdgeInsets.fromLTRB(32, 0, 32, 0),
    child: content,
  );

  final result = await Get.dialog(Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Flexible(child: card),
      const SizedBox(height: 16),
    ]),
    barrierDismissible: false,
  );

  if (result == null) {
    getNoticesBox(data: data, isPublicNotice: isPublicNotice, index: pageIndex.value);
  } else {
    if (isHide.value) {
      final time = DateTime.now().millisecondsSinceEpoch.toString();
      MyShared.to.set(shardKey, time);
    }
  }
}