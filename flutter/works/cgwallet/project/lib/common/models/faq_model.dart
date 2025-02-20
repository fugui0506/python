import 'package:cgwallet/common/common.dart';

class FaqListModel {
  List<FaqModel> list;

  FaqListModel({required this.list});

  factory FaqListModel.fromJson(List<dynamic> json) => FaqListModel(
    list: json.map((i) => FaqModel.fromJson(i)).toList(),
  );

  factory FaqListModel.empty() => FaqListModel(list: []);

  Map<String, dynamic> toJson() => {
    "list": list.map((i) => i.toJson()).toList(),
  };

  Future<void> update({int isShow = 1}) async {
    await UserController.to.dio?.post<FaqListModel>(ApiPath.me.getFaq,
      onSuccess: (code, msg, results) async {
        list = results.list;
      },
      data: {"isShow": isShow, "type": 99},
      onModel: (m) => FaqListModel.fromJson(m),
    );
  }
}

class FaqModel {
  int id;
  String name;
  int? type;
  String describe;
  int? mark;
  int? isShow;
  int? sort;
  bool isExpanded;

  FaqModel({
    required this.id,
    required this.name,
    required this.type,
    required this.describe,
    required this.mark,
    required this.isShow,
    required this.sort,
    required this.isExpanded,
  });

  factory FaqModel.fromJson(Map<String, dynamic> json) => FaqModel(
    id: json["id"] ?? -1,
    name: json["name"] ?? '',
    type: json["type"],
    describe: json["describe"] ?? '',
    mark: json["mark"],
    isShow: json["is_show"],
    sort: json["sort"],
    isExpanded: false,
  );

  factory FaqModel.empty() => FaqModel(
    id: -1,
    name: '',
    type: -1,
    describe: '',
    mark: -1,
    isShow: -1,
    sort: -1,
    isExpanded: false,
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "type": type,
    "describe": describe,
    "mark": mark,
    "is_show": isShow,
    "sort": sort,
  };
}
