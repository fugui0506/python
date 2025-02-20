import 'package:cgwallet/common/common.dart';

class PromotionListModel {
  List<PromotionModel> list;

  PromotionListModel({required this.list});

  factory PromotionListModel.fromJson(List<dynamic> json) => PromotionListModel(
    list: json.map((i) => PromotionModel.fromJson(i)).toList(),
  );

  factory PromotionListModel.empty() => PromotionListModel(
    list: [],
  );

  Map<String, dynamic> toJson() => {
    "list": list.map((i) => i.toJson()).toList(),
  };

  Future<void> update() async {
    await UserController.to.dio?.post<PromotionListModel>(ApiPath.me.getPromotions,
      onSuccess: (code, msg, results) async {
        list = results.list;
      },
      onModel: (m) => PromotionListModel.fromJson(m),
    );
  }
}

class PromotionModel {
  int id;
  String title;
  String banner;
  String detail;
  int status;
  int sort;
  int isDel;
  int isDisplay;

  PromotionModel({
    required this.id,
    required this.title,
    required this.banner,
    required this.detail,
    required this.status,
    required this.sort,
    required this.isDel,
    required this.isDisplay,
  });

  factory PromotionModel.fromJson(Map<String, dynamic> json) => PromotionModel(
    id: json["ID"] ?? -1,
    title: json["title"] ?? "",
    banner: json["banner"] ?? "",
    detail: json["detail"] ?? "",
    status: json["status"] ?? -1,
    sort: json["sort"] ?? -1,
    isDel: json["is_del"] ?? -1,
    isDisplay: json["is_display"] ?? -1,
  );

  Map<String, dynamic> toJson() => {
    "ID": id,
    "banner": banner,
    "title": title,
    "detail": detail,
    "status": status,
    "sort": sort,
    "is_del": isDel,
    "is_display": isDisplay,
  };

  factory PromotionModel.empty() => PromotionModel(
    id: -1,
    title: "",
    banner: "",
    detail: "",
    status: -1,
    sort: -1,
    isDel: -1,
    isDisplay: -1,
  );
}
