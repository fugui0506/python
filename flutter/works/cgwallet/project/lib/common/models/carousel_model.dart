import 'package:cgwallet/common/common.dart';

class CarouselListModel {
  List<CarouselModel> list;

  CarouselListModel({
    required this.list,
  });

  factory CarouselListModel.fromJson(List<dynamic> json) => CarouselListModel(
    list: json.map((i) => CarouselModel.fromJson(i)).toList(),
  );

  factory CarouselListModel.empty() => CarouselListModel(
    list: [],
  );

  Map<String, dynamic> toJson() => {
    "list": list.map((i) => i.toJson()).toList(),
  };

  Future<void> update() async {
    await UserController.to.dio?.post<CarouselListModel>(ApiPath.me.getCarousel,
      onSuccess: (code, msg, results) async {
        list = results.list;
      },
      onModel: (m) => CarouselListModel.fromJson(m),
    );
  }
}

class CarouselModel {
  int id;
  String name;
  String pictureUrl;
  String link;
  int orderBy;
  int status;
  int isDel;

  CarouselModel({
    required this.id,
    required this.name,
    required this.pictureUrl,
    required this.link,
    required this.orderBy,
    required this.status,
    required this.isDel,
  });

  factory CarouselModel.fromJson(Map<String, dynamic> json) => CarouselModel(
    id: json["id"] ?? -1,
    name: json["name"] ?? '',
    pictureUrl: json["pictureUrl"] ?? '',
    link: json["link"] ?? '',
    orderBy: json["orderBy"] ?? -1,
    status: json["status"] ?? -1,
    isDel: json["isDel"] ?? -1,
  );

  factory CarouselModel.empty() => CarouselModel(
    id: -1,
    name: '',
    pictureUrl: '',
    link: '',
    orderBy: -1,
    status: -1,
    isDel: -1,
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "pictureUrl": pictureUrl,
    "link": link,
    "orderBy": orderBy,
    "status": status,
    "isDel": isDel,
  };
}
