import 'package:cgwallet/common/common.dart';

class TutorialListModel {
  List<TutorialModel> list;

  TutorialListModel({
    required this.list,
  });

  factory TutorialListModel.fromJson(List<dynamic> json) => TutorialListModel(
    list: json.map((i) => TutorialModel.fromJson(i)).toList(),
  );

  factory TutorialListModel.empty() => TutorialListModel(
    list: [],
  );

  Map<String, dynamic> toJson() => {
    "list": list.map((i) => i.toJson()).toList(),
  };

  Future<void> update() async {
    await UserController.to.dio?.post<TutorialListModel>(ApiPath.me.getTutorial,
      onSuccess: (code, msg, results) async {
        list = results.list;
      },
      onModel: (m) => TutorialListModel.fromJson(m),
    );
  }
}

class TutorialModel {
  String address;
  String tutorialTitle;

  TutorialModel({
    required this.address,
    required this.tutorialTitle,
  });

  factory TutorialModel.fromJson(Map<String, dynamic> json) => TutorialModel(
    address: json["address"] ?? '',
    tutorialTitle: json["tutorialTitle"] ?? '',
  );

  Map<String, dynamic> toJson() => {
    "address": address,
    "tutorialTitle": tutorialTitle,
  };
}
