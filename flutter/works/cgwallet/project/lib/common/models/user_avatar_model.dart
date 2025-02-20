import 'package:cgwallet/common/common.dart';
import 'package:dio/dio.dart';

class UserAvatarListModel {
  List<UserAvatarModel> list;
  CancelToken cancelToken;

  UserAvatarListModel({
    required this.list,
    CancelToken? cancelToken,
  }) : cancelToken = cancelToken ?? CancelToken();

  factory UserAvatarListModel.fromJson(List<dynamic> json) => UserAvatarListModel(
    list: json.map((i) => UserAvatarModel.fromJson(i)).toList(),
  );

  factory UserAvatarListModel.empty() => UserAvatarListModel(
    list: [],
  );

  Map<String, dynamic> toJson() => {
    "list": list.map((i) => i.toJson()).toList(),
  };

  Future<void> update() async {
    await UserController.to.dio?.post<UserAvatarListModel>(
      ApiPath.me.getAvatarList,
      onSuccess: (code, msg, results) async {
        list = results.list;
      },
      onModel: (m) => UserAvatarListModel.fromJson(m),
      cancelToken: cancelToken,
    );
  }

  void stopUpdate() {
    cancelToken.cancel();
  }
}

class UserAvatarModel {
  int id;
  String avatarUrl;

  UserAvatarModel({
    required this.id,
    required this.avatarUrl,
  });

  factory UserAvatarModel.fromJson(Map<String, dynamic> json) => UserAvatarModel(
    id: json['id'] ?? -1,
    avatarUrl: json['avatar_url'] ?? '',
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "avatar_url": avatarUrl,
  };

  factory UserAvatarModel.empty() => UserAvatarModel(
    id: 0,
    avatarUrl: '',
  );
}
