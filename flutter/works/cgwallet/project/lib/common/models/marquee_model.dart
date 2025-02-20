import 'package:cgwallet/common/common.dart';

class MarqueeListModel {
  List<MarqueeModel> list;

  MarqueeListModel({required this.list});

  factory MarqueeListModel.fromJson(List<dynamic> json) => MarqueeListModel(
    list: json.map((i) => MarqueeModel.fromJson(i)).toList(),
  );

  factory MarqueeListModel.empty() => MarqueeListModel(list: []);

  Map<String, dynamic> toJson() => {
    "list": list.map((i) => i.toJson()).toList(),
  };

  Future<void> update() async {
    await UserController.to.dio?.post<MarqueeListModel>(
      ApiPath.me.getMarquee,
      onSuccess: (code, msg, results) async {
        list = results.list;
      },
      onModel: (m) => MarqueeListModel.fromJson(m),
    );
  }

  Future<void> updateMarket() async {
    await UserController.to.dio?.post<MarqueeListModel>(
      ApiPath.market.getScrollNotice,
      onSuccess: (code, msg, results) async {
        list = results.list;
      },
      onModel: (m) => MarqueeListModel.fromJson(m),
    );
  }
}

class MarqueeModel {
  int id;
  String content;
  String contentMarket;
  int sort;
  int status;

  MarqueeModel({
    required this.id,
    required this.content,
    required this.sort,
    required this.status,
    required this.contentMarket,
  });

  factory MarqueeModel.fromJson(Map<String, dynamic> json) => MarqueeModel(
    id: json["ID"] ?? -1,
    content: json["Content"] ?? '',
    sort: json["sort"] ?? -1,
    status: json["status"] ?? -1,
    contentMarket: json["content"] ?? '',
  );

  factory MarqueeModel.empty() => MarqueeModel(
    id: -1,
    content: '',
    sort: -1,
    status: -1,
    contentMarket: '',
  );

  Map<String, dynamic> toJson() => {
    "ID": id,
    "Content": content,
    "sort": sort,
    "status": status,
    "content": contentMarket,
  };
}
