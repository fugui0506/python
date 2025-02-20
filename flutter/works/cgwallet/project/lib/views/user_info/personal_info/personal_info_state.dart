import 'package:cgwallet/common/common.dart';
import 'package:get/get.dart';

class PersonalInfoState {
  final avatarList = UserAvatarListModel.empty().obs;
  final title = Lang.personalInfoViewTitle.tr;

  final _avatarIndex = (-1).obs;
  int get avatarIndex => _avatarIndex.value;
  set avatarIndex(int value) => _avatarIndex.value = value;
}
