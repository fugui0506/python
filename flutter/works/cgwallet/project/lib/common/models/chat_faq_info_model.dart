import 'package:cgwallet/common/common.dart';

class ChatFaqTypeListModel {
  List<ChatFaqTypeModel> list;

  ChatFaqTypeListModel({
    required this.list
  });

  factory ChatFaqTypeListModel.fromJson(List<dynamic> json) => ChatFaqTypeListModel(
    list: json.map((i) => ChatFaqTypeModel.fromJson(i)).toList(),
  );

  factory ChatFaqTypeListModel.empty() => ChatFaqTypeListModel(list: []);


  Future<void> update() async {
    await UserController.to.dio?.get<ChatFaqTypeListModel>(ApiPath.me.getChatFaqType,
      onSuccess: (code, msg, results) async {
        list = results.list;
      },
      onModel: (m) => ChatFaqTypeListModel.fromJson(m),
    );
  }
}

class ChatFaqTypeModel {
  int id;
  int sort;
  String categoryName;

  ChatFaqTypeModel({
    required this.id,
    required this.categoryName,
    required this.sort,
  });

  factory ChatFaqTypeModel.fromJson(Map<String, dynamic> json) => ChatFaqTypeModel(
    id: json['id'] ?? -1,
    sort: json['sort'] ?? -1,
    categoryName: json['categoryName'] ?? '',
  );

  factory ChatFaqTypeModel.empty() => ChatFaqTypeModel(
      id: -1,
      sort: -1,
      categoryName: ''
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "categoryName": categoryName,
    "sort": sort,
  };
}

class ChatFaqListModel {
  List<ChatFaqInfoModel> list;

  ChatFaqListModel({required this.list});

  factory ChatFaqListModel.fromJson(List<dynamic> json) => ChatFaqListModel(
    list: json.map((i) => ChatFaqInfoModel.fromJson(i)).toList(),
  );

  factory ChatFaqListModel.empty() => ChatFaqListModel(list: []);

  Map<String, dynamic> toJson() => {
    "list": list.map((i) => i.toJson()).toList(),
  };

  Future<void> update({required int typeId}) async {
    await UserController.to.dio?.post<ChatFaqListModel>(ApiPath.me.getChatFaqList,
      onSuccess: (code, msg, results) async {
        list = results.list;
      },
      onModel: (m) => ChatFaqListModel.fromJson(m),
      data: {
        "typeId": typeId,
      },
    );
  }
}

class ChatFaqInfoModel {
  int id;
  String title;
  int symbol;
  String answer;
  String picUrl;
  int sort;

  ChatFaqInfoModel({
    required this.id,
    required this.title,
    required this.symbol,
    required this.answer,
    required this.picUrl,
    required this.sort,
  });

  factory ChatFaqInfoModel.fromJson(Map<String, dynamic> json) => ChatFaqInfoModel(
    id: json["id"] ?? -1,
    title: json["title"] ?? "",
    symbol: json["symbol"] ?? -1,
    answer: json["answer"] ?? "",
    picUrl: json["picUrl"] ?? "",
    sort: json["sort"]?? -1,
  );

  factory ChatFaqInfoModel.empty() => ChatFaqInfoModel(
    id: -1,
    title: "",
    symbol: -1,
    answer: "",
    picUrl: "",
    sort: -1,
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "symbol": symbol,
    "answer": answer,
    "picUrl": picUrl,
    "sort": sort,
  };
}
