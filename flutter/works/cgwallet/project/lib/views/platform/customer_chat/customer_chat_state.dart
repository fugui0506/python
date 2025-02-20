import 'package:cgwallet/common/common.dart';
import 'package:flutter/cupertino.dart';
// import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class CustomerChatState {
  final title = Lang.connecting.tr.obs;
  final chatItems = [].obs;
  final QueryEntranceModel queryEntrance = QueryEntranceModel.empty();
  final assignWorker = AssignWorkerModel.empty();
  final autoReply = AutoReplyModel.empty();
  final messages = QichatHistory.empty();

  final _isDialog = false.obs;
  bool get isDialog => _isDialog.value;
  set isDialog(bool value) => _isDialog.value = value;

  final bottomGlobalKey = GlobalKey();

  double dyMain = 0.0;
  double dxMain = 0.0;

  double dySecond = 0.0;
  double dxSecond = 0.0;

  final double dialogHeight = 80.0;
  final double dialogWidth = 120.0;

  String qichatApiUrl = '';

  dynamic chooseMessage;

  final msgId = ''.obs;

  final replyOpenIndex = [-1, 0].obs;

  final _isLoading = true.obs;
  bool get isLoading => _isLoading.value;
  set isLoading(bool value) {
    _isLoading.value = value;
    _isLoading.refresh();
  }

  final replyMessage = ReplyMessageModel.empty().obs;

  final _isButtonDisable = true.obs;
  bool get isButtonDisable => _isButtonDisable.value;
  set isButtonDisable(bool value) => _isButtonDisable.value = value;

  final _isOpenEmoticons = false.obs;
  bool get isOpenEmoticons => _isOpenEmoticons.value;
  set isOpenEmoticons(bool value) => _isOpenEmoticons.value = value;

  List<String> emojiList = [
    "😀", "😃", "😄", "😁", "😆", "😅", "😂", "🤣", "☺️", "😊",
    "😇", "🙂", "🙃", "😉", "😌", "😍", "🥰", "😘", "😗", "😙",
    "😚", "😋", "😛", "😝", "😜", "🤪", "🤨", "🧐", "🤓", "😎",
    "🤩", "🥳", "😏", "😒", "😞", "😔", "😟", "😕", "🙁", "😾",
    "😣", "😖", "😫", "😩", "🥺", "😢", "😭", "😤", "😠", "😡",
    "🤬", "🤯", "😳", "🥵", "🥶", "😱", "😨", "😰", "😥", "😓",
    "🤗", "🤔", "🤭", "🤫", "🤥", "😶", "😐", "😑", "😬", "🙄",
    "😯", "😦", "😧", "😮", "😲", "😴", "🤤", "😪", "😵", "🤐",
    "🥴", "🤢", "🤮", "🤧", "😷", "🤒", "🤕", "🤑", "🤠", "😈",
    "👿", "👹", "👺", "🤡", "💩", "👻", "💀", "☠️", "👽", "👾",
    "🤖", "🎃", "😺", "😸", "😹", "😻", "😼", "😽", "🙀", "😿",
    "👋", "🤚", "🖐", "✋", "🖖", "👌", "✌️", "🤞", "🤟", "🧀",
    "🤘", "🤙", "👈", "👉", "👆", "🖕", "👇", "☝️", "👍", "👎",
    "✊", "👊", "🤛", "🤜", "👏", "🙌", "👐", "🤲", "🙏", "✍️",
    "💅", "🤳", "💪","🐶", "🐱", "🐭", "🐹", "🐰", "🦊", "🐻", 
    "🐼", "🐨", "🐯","🦁", "🐮", "🐷", "🐽", "🐸", "🐵", "🙈", 
    "🙉", "🙊", "🐒","🐔", "🐧", "🐦", "🐤", "🐣", "🐥", "🦆", 
    "🦅", "🦉", "🦇","🥓", "🍔", "🍟", "🍕", "🌭", "🥪", "🌮",
    "🍏", "🍎", "🍐", "🍊", "🍋", "🍌", "🍉", "🍇", "🍓", "🥞",
    "🥝", "🍒", "🍑", "🥭", "🍍", "🥥", "🥑", "🍆", "🥔", "🥕",
    "🌽", "🌶️", "🥒", "🥬", "🥦", "🍄", "🥜", "🥖", "🥨", "🥯",
  ];
}
