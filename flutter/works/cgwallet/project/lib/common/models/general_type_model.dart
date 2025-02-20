import 'package:cgwallet/common/common.dart';

class GeneralTypeListModel {
  List<GeneralTypeTypeModel> list;

  GeneralTypeListModel({
    required this.list,
  });

  factory GeneralTypeListModel.fromJson(Map<String, dynamic> json) => GeneralTypeListModel(
    list: List<GeneralTypeTypeModel>.from(json["generalType"].map((x) => GeneralTypeTypeModel.fromJson(x)),
    ),
  );

  factory GeneralTypeListModel.empty() => GeneralTypeListModel(list: []);

  Map<String, dynamic> toJson() => {
    "generalType": List<dynamic>.from(list.map((x) => x.toJson())),
  };

  Future<void> update() async {
    await UserController.to.dio?.get<GeneralTypeListModel>(
      ApiPath.transfer.getGeneralType,
      onSuccess: (code, msg, results) async {
        list = results.list;
      },
      onModel: (m) => GeneralTypeListModel.fromJson(m),
    );
  }
}

class GeneralTypeTypeModel {
  String name;
  List<int> subType;

  GeneralTypeTypeModel({
    required this.name,
    required this.subType,
  });

  factory GeneralTypeTypeModel.fromJson(Map<String, dynamic> json) => GeneralTypeTypeModel(
    name: json["name"] ?? '',
    subType: List<int>.from(json["subType"].map((x) => x)),
  );

  factory GeneralTypeTypeModel.empty() => GeneralTypeTypeModel(
    name: '',
    subType: [],
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "subType": List<dynamic>.from(subType.map((x) => x)),
  };
}
