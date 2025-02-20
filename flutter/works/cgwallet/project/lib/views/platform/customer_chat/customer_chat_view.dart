import 'dart:typed_data';
import 'package:cgwallet/common/common.dart';
import 'package:cgwallet/views/views.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:get/get.dart';

class CustomerChatView extends GetView<CustomerChatController> {
  const CustomerChatView({super.key});

  @override
  Widget build(BuildContext context) {
    /// appbar
    var appBar = MyAppBar.normalWidget(
      title: Obx(() => Text(controller.state.title.value, maxLines: 1, style: Theme.of(context).myStyles.labelBigger)),
    );

    /// 页面构成
    return Stack(children: [
      KeyboardDismissOnTap(child: Scaffold(
        appBar: appBar,
        backgroundColor: Theme.of(context).myColors.background,
        body: _buildBody(context),
      )),

      Obx(() => controller.state.isDialog
        ? _buildPopupBox(context)
        : const SizedBox()
      ),
    ]);
  }

  Widget _buildPopupBox(BuildContext context) {
    final copyBox = MyButton.widget(onPressed: () {
      controller.state.isDialog = false;

      String content = '';

      if (controller.state.chooseMessage is Rx<QichatCustomerMessageModel>) {
        final QichatCustomerMessageModel model = controller.state.chooseMessage.value;
        content = model.content;
      } else if (controller.state.chooseMessage is Rx<QichatUserMessageModel>) {
        final QichatUserMessageModel model = controller.state.chooseMessage.value;
        content = model.content;
      } else {
        return;
      }

      if (content.isNotEmpty) {
        content.copyToClipBoard();
      }
    }, child: MyCard(padding: const EdgeInsets.only(left: 8, right: 8), child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      SizedBox(width: 20, height: 20, child: FittedBox(child: Theme.of(context).myIcons.qiCopy)),
      const SizedBox(height: 8),
      Text(Lang.copy.tr, style: Theme.of(context).myStyles.labelLight),
    ])));

    final replyBox = MyButton.widget(onPressed: () {
      controller.state.isDialog = false;

      QichatType qichatType = QichatType.text;
      String msgId = '';
      String content = '';

      if (controller.state.chooseMessage is Rx<QichatCustomerMessageModel>) {
        final QichatCustomerMessageModel model = controller.state.chooseMessage.value;
        qichatType = model.type;
        msgId = model.msgId;
        content = model.content;
      } else if (controller.state.chooseMessage is Rx<QichatUserMessageModel>) {
        final QichatUserMessageModel model = controller.state.chooseMessage.value;
        qichatType = model.type;
        msgId = model.msgId;
        content = model.content;
      } else {
        return;
      }

      if (qichatType == QichatType.text) {
        controller.state.replyMessage.value.content = content;
      } else if (qichatType == QichatType.image) {
        controller.state.replyMessage.value.content = '[image]';
      } else if (qichatType == QichatType.video) {
        controller.state.replyMessage.value.content = '[video]';
      }

      controller.state.replyMessage.value.type = qichatType;
      controller.state.replyMessage.value.msgId = msgId;
      controller.state.replyMessage.refresh();
    }, child: MyCard(padding: const EdgeInsets.only(left: 8, right: 8), child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      SizedBox(width: 20, height: 20, child: FittedBox(child: Theme.of(context).myIcons.qiReply)),
      const SizedBox(height: 8),
      Text(Lang.reply.tr, style: Theme.of(context).myStyles.labelLight),
    ])));

    // final editBox = MyButton.widget(onPressed: () {
    //
    // }, child: MyCard(padding: EdgeInsets.only(left: 8, right: 8), child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
    //   SizedBox(width: 20, height: 20, child: FittedBox(child: Theme.of(context).myIcons.qiCopy)),
    //   const SizedBox(height: 8),
    //   Text(Lang.copy.tr, style: Theme.of(context).myStyles.labelLight),
    // ])));

    // final backBox = MyButton.widget(onPressed: () {
    //
    // }, child: MyCard(padding: EdgeInsets.only(left: 8, right: 8), child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
    //   SizedBox(width: 20, height: 20, child: FittedBox(child: Theme.of(context).myIcons.copyNormal)),
    //   const SizedBox(height: 8),
    //   Text(Lang.copy.tr, style: Theme.of(context).myStyles.labelLight),
    // ])));

    final children = controller.state.chooseMessage is Rx<QichatCustomerMessageModel>
      ? [copyBox, replyBox]
      : [copyBox, replyBox];

    return Stack(children: [
      MyButton.widget(onPressed: () => controller.state.isDialog = false, child: const MyCard(
        width: double.infinity,
        height: double.infinity,
        // color: Theme.of(context).myColors.primary.withOpacity( 0.5),
      )),
      // Positioned(
      //     top: controller.state.dySecond,
      //     left: controller.state.dxSecond,
      //     child: SizedBox(height: 10, child: Theme.of(context).myIcons.downSolid)
      // ),
      Positioned(
        top: controller.state.dyMain,
        left: controller.state.dxMain,
        child: Material(
          color: Colors.transparent,
          child: MyCard(
            borderRadius: BorderRadius.circular(10),
            width: controller.state.chooseMessage is Rx<QichatCustomerMessageModel> ? controller.state.dialogWidth : controller.state.dialogWidth,
            height: controller.state.dialogHeight,
            color: Theme.of(context).myColors.dark,
            child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: children),
          ),
        ),
      ),
    ]);
  }

  Widget _buildBody(BuildContext context) {
    return Column(children: [
      Expanded(child: _buildChatBox(context)),
      _buildInputBox(context),
    ]);
  }

  Widget _buildChatBox(BuildContext context) {
    return MyCard(
      width: double.infinity,
      height: double.infinity,
      color: Theme.of(context).myColors.cardBackground,
      borderRadius: BorderRadius.zero,
      child: Obx(() => ListView.builder( 
        reverse: true,
        controller: controller.scrollController,
        padding: const EdgeInsets.all(16),
        itemBuilder: (context, index) {
          return _buildItem(context, controller.state.chatItems[index]);
        },
        itemCount: controller.state.chatItems.length,
      )),
    );
  }

  // Widget _copyButton(BuildContext context, void Function() onPressed) {
  //   return SlidableAction(
  //     onPressed: (context) => onPressed(),
  //     backgroundColor: Theme.of(context).myColors.secondary,
  //     foregroundColor: Theme.of(context).myColors.light,
  //     icon: Icons.content_copy,
  //     spacing: 8,
  //     label: Lang.copy.tr,
  //     padding: const EdgeInsets.all(4),
  //   );
  // }

  // Widget _replyButton(BuildContext context, void Function() onPressed) {
  //   return SlidableAction(
  //     onPressed: (context) => onPressed(),
  //     backgroundColor: Theme.of(context).myColors.error,
  //     foregroundColor: Theme.of(context).myColors.light,
  //     icon: Icons.reply,
  //     spacing: 8,
  //     label: Lang.reply.tr,
  //     padding: const EdgeInsets.all(4),
  //   );
  // }

  Widget _buildReplyChild(BuildContext context, String text, QichatType qichatType) {
    return IntrinsicWidth(child: MyCard.normal(
      color: Theme.of(context).myColors.buttonCancel,
      padding: const EdgeInsets.all(8),
      child: qichatType == QichatType.text 
        ? Text('${Lang.reply.tr} : $text', style: Theme.of(context).myStyles.onButton, softWrap: true)
        : qichatType == QichatType.image 
          ? Row(mainAxisSize: MainAxisSize.min, children: [
              const SizedBox(width: 8),
              Text('${Lang.reply.tr} : ', style: Theme.of(context).myStyles.onButton),
              SizedBox(height: 24, width: 24, child: MyImage(imageUrl: controller.argument.imageUrl + text)),
              const SizedBox(width: 8),
            ])
          : Text(' ${Lang.reply.tr} : [video] ', style: Theme.of(context).myStyles.onButton, softWrap: true),
    ));
  }

  Widget _buildReplyBox(BuildContext context, String replyMsgId) {
    Widget replyBox = const SizedBox();

    if (replyMsgId.isEmpty || replyMsgId == '0') {
      return replyBox;
    }
    
    controller.state.chatItems.map((v) {
      if (v is Rx<QichatUserMessageModel>) {
        if (v.value.msgId == replyMsgId) {
          replyBox = _buildReplyChild(context, v.value.content, v.value.type);
          return;
        }
      } else if (v is Rx<QichatCustomerMessageModel>) {
        if (v.value.msgId == replyMsgId) {
          replyBox = _buildReplyChild(context, v.value.content, v.value.type);
          return;
        }
      }
    }).toList();
    return replyBox;
  }

  Widget _buildItem(BuildContext context, dynamic e) {
    final customerAvatar = MyCard.avatar(radius: 20, child: MyImage(imageUrl: controller.argument.imageUrl + controller.state.assignWorker.avatar));
    final userAvatar = MyCard.avatar(radius: 20, child: MyImage(imageUrl: controller.argument.avatarUrl ?? ''));

    final GlobalKey key = GlobalKey();

    void setChooseData() {
      final dialogContext = key.currentContext;
      final bottomContext = controller.state.bottomGlobalKey.currentContext;

      if (dialogContext != null && bottomContext != null) {
        final RenderBox renderBox = dialogContext.findRenderObject() as RenderBox;
        final offset = renderBox.localToGlobal(Offset.zero);
        final textSize = renderBox.size;

        final renderBoxBottom = bottomContext.findRenderObject() as RenderBox;
        final bottomSize = renderBoxBottom.size;

        final screenHeight = MediaQuery.of(context).size.height;
        final keyboardHeight = MediaQueryData.fromView(View.of(context)).viewInsets.bottom;
        final topHeight = MediaQueryData.fromView(View.of(context)).padding.top;

        final bottomSpace = screenHeight - offset.dy - textSize.height - bottomSize.height - keyboardHeight;
        final topSpace = offset.dy - topHeight - kToolbarHeight;

        if (topSpace > controller.state.dialogHeight + 4) {
          controller.state.dyMain = offset.dy - controller.state.dialogHeight - 4;
          controller.state.dySecond = offset.dy - 10 - 4;
        } else if (bottomSpace > controller.state.dialogHeight + 4) {
          controller.state.dyMain = offset.dy + textSize.height + 4;
          controller.state.dySecond = offset.dy + textSize.height + 4 + controller.state.dialogHeight;
        } else {
          controller.state.dyMain = (Get.height - controller.state.dialogHeight) / 3;
          controller.state.dySecond = (Get.height - controller.state.dialogHeight) / 3;
        }

        if (e is Rx<QichatUserMessageModel>) {
          controller.state.dxMain = Get.width - controller.state.dialogWidth - 48 - 16;
          controller.state.dxSecond = (offset.dx + textSize.width) / 2;

        } else if (e is Rx<QichatCustomerMessageModel>) {
          controller.state.dxMain = 16 + 48;
          controller.state.dxSecond = (offset.dx + textSize.width) / 2;
        }

        controller.state.chooseMessage = e;
        controller.state.isDialog = true;

      }
    }

    if (e is AutoReplyModel) {
      if (e.autoReplyItem.qa.isEmpty) {
        return const SizedBox();
      }
      return Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        customerAvatar,
        const SizedBox(width: 8),
        Flexible(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(e.createTime, style: Theme.of(context).myStyles.labelSmall),
          const SizedBox(height: 4),
          MyCard.normal(
            padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
            margin: const EdgeInsets.only(bottom: 16),
            color: Theme.of(context).myColors.itemCardBackground,
            child: Column(children: [
              Text(e.autoReplyItem.title, style: Theme.of(context).myStyles.label),
              const SizedBox(height: 8),
              QichatReplyListView(data: e.autoReplyItem, itemPressed: (qa, openIndex) => controller.onReplyItem(qa, openIndex), openIndex: controller.state.replyOpenIndex),
            ]),
          ),
        ])),
        const SizedBox(width: 40 + 8),
      ]);
    } else if (e is Rx<QichatUserMessageModel>) {
      final msgBox = Column(children: [
        Row(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(width: 40 + 8),
          Flexible(child: Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
            Text(e.value.createdTime.replaceAll('T', ' '), style: Theme.of(context).myStyles.labelSmall),
            const SizedBox(height: 4),
            Row(mainAxisAlignment: MainAxisAlignment.end, crossAxisAlignment: CrossAxisAlignment.center, children: [
              Obx(() => Opacity(opacity: [QichatSendingType.isLoading, QichatSendingType.failed].contains(e.value.qichatSendingType) ? 1 : 0,
                child: e.value.qichatSendingType == QichatSendingType.failed ? Theme.of(context).myIcons.qiError : Theme.of(context).myIcons.loadingIcon,
              )),
              const SizedBox(width: 4),
              Flexible(child: GestureDetector(
                key: key,
                onLongPress: () => setChooseData(),
                child: MyCard.normal(
                  // margin: EdgeInsets.only(bottom: 16),
                  padding: e.value.type == QichatType.text ? const EdgeInsets.fromLTRB(16, 10, 16, 10) : EdgeInsets.zero,
                  color: Theme.of(context).myColors.primary,
                  child: e.value.type == QichatType.text
                    ? Text(e.value.content, style: Theme.of(context).myStyles.labelLight, softWrap: true)
                    : e.value.type == QichatType.image
                    ? Obx(() => MyButton.widget(
                    onPressed: () {
                      if (e.value.content.isNotEmpty) {
                        MyAlert.saveImage(imageUrl: controller.argument.imageUrl + e.value.content);
                      }
                    },
                    child: MyImage(
                        imageUrl: controller.argument.imageUrl + e.value.content,
                        synchWidget: e.value.bytes.isEmpty ? null : Image.memory(Uint8List.fromList(e.value.bytes))
                    )
                  ))
                    : Obx(() => MyVideoPlayer(
                  videoUrl: e.value.qichatSendingType == QichatSendingType.success ? controller.argument.imageUrl + e.value.content : null,
                  file: e.value.qichatSendingType == QichatSendingType.success ? null : e.value.file,
                  )),
                ),
              )),
            ]),
            const SizedBox(height: 4),
            Obx(() => e.value.replyMsgId == '0' ? const SizedBox() : _buildReplyBox(context, e.value.replyMsgId)),
          ])),
          const SizedBox(width: 8),
          userAvatar,
        ],
      ),
      const SizedBox(height: 16),
      ]);
      return msgBox;
    } else if (e is Rx<QichatCustomerMessageModel>) {
      return Column(children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            customerAvatar,
            const SizedBox(width: 8),
            Flexible(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(e.value.createdTime, style: Theme.of(context).myStyles.labelSmall),
              const SizedBox(height: 4),
              GestureDetector(
                key: key,
                onLongPress: () => setChooseData(),
                child: MyCard.normal(
                padding: e.value.type == QichatType.text ? const EdgeInsets.fromLTRB(16, 10, 16, 10) : EdgeInsets.zero,
                color: Theme.of(context).myColors.itemCardBackground,
                child: Obx(() => e.value.type == QichatType.text
                  ? Text(e.value.content, style: Theme.of(context).myStyles.label, softWrap: true)
                  : e.value.type == QichatType.image
                  ? MyButton.widget(
                  onPressed: () {
                    if (e.value.content.isNotEmpty) {
                      MyAlert.saveImage(imageUrl: controller.argument.imageUrl + e.value.content);
                    }
                  },
                  child: MyImage(imageUrl: controller.argument.imageUrl + e.value.content)
                )
                  : MyVideoPlayer(videoUrl: controller.argument.imageUrl + e.value.content)),
              )),
              const SizedBox(height: 4),
              Obx(() => e.value.replyMsgId == '0' ? const SizedBox() : _buildReplyBox(context, e.value.replyMsgId)),
              const SizedBox(height: 16),
              // _buildReplyBox(context, e.value.replyMsgId),
            ])),
            const SizedBox(width: 40 + 8),
        ]),
      ]);
    }
    return const SizedBox();
  }

  Widget _buildInputBox(BuildContext context) {
    final input = ConstrainedBox(constraints: const BoxConstraints(maxHeight: 200), child: MyInput(
      controller: controller.inputTextController,
      focusNode: controller.inputTextFocusNode,
      color: Theme.of(context).myColors.cardBackground,
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      maxLength: 500,
      buildCounter: (BuildContext context, {required int currentLength, required bool isFocused, required int? maxLength}) {
        return null;
      },
    ));

    final buttons = Row(children: [
      Obx(() => MyButton.widget(onPressed: controller.state.isLoading ? null : !controller.state.isOpenEmoticons ? _openEmoticons : _closeEmoticons, child: SizedBox(width: 24, height: 24, child: FittedBox(child: Obx(() => controller.state.isOpenEmoticons ? Theme.of(context).myIcons.qiKeyboard : Theme.of(context).myIcons.qiEmoticons))))),
      const SizedBox(width: 15),
      Obx(() => MyButton.widget(onPressed: controller.state.isLoading ? null : controller.pickMedia, child: SizedBox(width: 24, height: 24, child: FittedBox(child: Theme.of(context).myIcons.qiImage)))),
      const SizedBox(width: 15),
      Obx(() => MyButton.widget(onPressed: controller.state.isLoading ? null : controller.onPhotograph, child: SizedBox(width: 24, height: 24, child: FittedBox(child: Theme.of(context).myIcons.qiCameraIcon)))),
      const SizedBox(width: 15),
      Obx(() => MyButton.widget(onPressed: controller.state.isLoading ? null : controller.onVideoGraph, child: SizedBox(width: 24, height: 24, child: FittedBox(child: Theme.of(context).myIcons.qiVideo)))),
      const SizedBox(width: 15),
      const Spacer(),
      SizedBox(width: 100, height: 32, child: Obx(() => MyButton.filedLong(onPressed: controller.state.isButtonDisable ? null : () => controller.checkSendText(controller.inputTextController.text), text: Lang.send.tr)))
    ]);

    final emoticons = Obx(() => controller.state.isOpenEmoticons ? ConstrainedBox(
      constraints: const BoxConstraints(maxHeight: 200),
      child: SingleChildScrollView(child: Wrap(children: controller.state.emojiList.asMap().entries.map((e) => MyButton.widget(
        onPressed: () {
          controller.inputTextController.text += e.value;
        }, 
          child: MyCard(
          width: (Get.width - 16 - 16) / 10,
          height: (Get.width - 16 - 16) / 10,
          child: Padding(padding: const EdgeInsets.all(2), child: FittedBox(child: Text(e.value))),
        )
      )).toList())),
    ) : const SizedBox());

    final replyBox = Obx(() => controller.state.replyMessage.value.content.isEmpty ? const SizedBox() : Column(children: [
      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Flexible(child: Text('${Lang.reply.tr} : ${controller.state.replyMessage.value.content}', style: Theme.of(context).myStyles.label, overflow: TextOverflow.clip, maxLines: 1)),
        const SizedBox(width: 10),
        MyButton.widget(onPressed: controller.clearReply, child: SizedBox(width: 12, height: 12, child: Theme.of(context).myIcons.close)),
      ]),
      const SizedBox(height: 8),
    ]));

    final card = MyCard(
      key: controller.state.bottomGlobalKey,
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
      color: Theme.of(context).myColors.itemCardBackground,
      child: SafeArea(child: Column(children: [
        replyBox,
        input, 
        const SizedBox(height: 8), 
        buttons,
        const SizedBox(height: 8), 
        emoticons,
      ])),
    );

    
    return card;
  }

  void _openEmoticons() async {
    Get.focusScope?.unfocus();
    if (controller.inputTextFocusNode.hasFocus) {
      await Future.delayed(MyConfig.app.timePageTransition * 0.5);
    }
    controller.state.isOpenEmoticons = true;
  }

  void _closeEmoticons() {
    controller.state.isOpenEmoticons = false;
    controller.inputTextFocusNode.requestFocus();
  }
}
