import 'package:cgwallet/common/common.dart';

class PublicNoteListModel {
  List<NotifyModel> list;

  PublicNoteListModel({
    required this.list,
  });

  factory PublicNoteListModel.fromJson(List? json) => PublicNoteListModel(
    list: json == null ? [] : json.map((x) => NotifyModel.fromJson(x)).toList(),
  );

  factory PublicNoteListModel.empty() => PublicNoteListModel(
    list: [],
  );

  Map<String, dynamic> toJson() => {
    "list": List<dynamic>.from(list.map((x) => x.toJson())),
  };

  Future<void> update({required String apiPath}) async {
    await UserController.to.dio?.post<PublicNoteListModel>(apiPath,
      onSuccess: (code, msg, data) {
        list = data.list;
      },
      onModel: (m) => PublicNoteListModel.fromJson(m),
    );
  }
}