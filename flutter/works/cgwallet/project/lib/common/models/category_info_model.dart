import 'package:cgwallet/common/common.dart';

class CategoryInfoListModel {
  List<CategoryInfoModel> list;

  CategoryInfoListModel({
    required this.list,
  });

  factory CategoryInfoListModel.fromJson(List<dynamic> json) => CategoryInfoListModel(
    list: json.map((i) => CategoryInfoModel.fromJson(i)).toList(),
  );

  factory CategoryInfoListModel.empty() => CategoryInfoListModel(
    list: [],
  );

  Map<String, dynamic> toJson() => {
    "list": list.map((i) => i.toJson()).toList(),
  };

  Future<void> update() async {
    await UserController.to.dio?.get<CategoryInfoListModel>(ApiPath.category.getCategoryTypeList,
      onSuccess: (code, msg, results) async {
        list = results.list;
      },
      onModel: (m) => CategoryInfoListModel.fromJson(m),
    );
  }
}

class CategoryInfoModel {
  final int id;
  final String categoryName;
  final String payCategorySn;
  final String icon;
  final int status;
  final int sort;

  CategoryInfoModel({
    required this.id,
    required this.categoryName,
    required this.payCategorySn,
    required this.icon,
    required this.status,
    required this.sort,
  });

  factory CategoryInfoModel.empty() => CategoryInfoModel(
    id: -1,
    categoryName: '',
    payCategorySn: '',
    icon: '',
    status: -1,
    sort: -1,
  );

  factory CategoryInfoModel.fromJson(Map<String, dynamic> json) => CategoryInfoModel(
    id: json["ID"] ?? -1,
    categoryName: json["categoryName"] ?? '',
    payCategorySn: json["payCategorySn"] ?? '',
    icon: json["icon"] ?? '',
    status: json["status"] ?? -1,
    sort: json["sort"] ?? -1,
  );

  Map<String, dynamic> toJson() => {
    "ID": id,
    "categoryName": categoryName,
    "payCategorySn": payCategorySn,
    "icon": icon,
    "status": status,
    "sort": sort,
  };
}
