import 'package:cgwallet/common/common.dart';

class NotifyListModel {
  List<NotifyModel> list;
  int publicIsRead;
  int memberIsRead;

  NotifyListModel({
    required this.list,
    required this.publicIsRead,
    required this.memberIsRead,
  });

  factory NotifyListModel.fromJson(Map<String, dynamic> json) => NotifyListModel(
    list: List<NotifyModel>.from(json["Announcements"].map((x) => NotifyModel.fromJson(x))),
    publicIsRead: json["publicIsRead"] ?? 0,
    memberIsRead: json["memberIsRead"] ?? 0,
  );
  
  factory NotifyListModel.empty() => NotifyListModel(
    list: [],
    publicIsRead: 0,
    memberIsRead: 0,
  );

  Map<String, dynamic> toJson() => {
    "Announcements": List<dynamic>.from(list.map((x) => x.toJson())),
    "publicIsRead": publicIsRead,
    "memberIsRead": memberIsRead,
  };

  Future<void> update({int typeId = 1}) async {
    await UserController.to.dio?.post<NotifyListModel>(
      ApiPath.me.getNotify,
      onSuccess: (code, msg, results) async {
        list = results.list;
        publicIsRead = results.publicIsRead;
        memberIsRead = results.memberIsRead;
      },
      data: {'size': 1000, 'typeId': typeId},
      onModel: (m) => NotifyListModel.fromJson(m),
    );
  }
}

class NotifyModel {
  int id;
  String title;
  String content;
  String createdTime;
  String memberId;
  int popupType;
  int isRead;

  NotifyModel({
    required this.id,
    required this.title,
    required this.content,
    required this.createdTime,
    required this.memberId,
    required this.popupType,
    required this.isRead,
  });

  factory NotifyModel.fromJson(Map<String, dynamic> json) => NotifyModel(
    id: json["id"] ?? -1,
    title: json["title"] ?? '',
    content: json["content"] ?? '',
    createdTime: json["createdTime"] ?? '',
    memberId: json["memberId"] ?? '',
    popupType: json["popupType"] ?? 0,
    isRead: json["isRead"] ?? 0,
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "content": content,
    "createdTime": createdTime,
    "memberId": memberId,
    "popupType": popupType,
    "isRead": isRead,
  };
}

class NoticeReadModel {
  int countAll;
  int systemCount;
  String systemContent;
  int singleCount;
  String singleContent;

  NoticeReadModel({
    required this.countAll,
    required this.systemCount,
    required this.systemContent,
    required this.singleCount,
    required this.singleContent,
  });

  factory NoticeReadModel.fromJson(Map<String, dynamic> json) => NoticeReadModel(
    countAll: json["countAll"] ?? 0,
    systemCount: json["systemCount"] ?? 0,
    systemContent: json["systemContent"] ?? '',
    singleCount: json["singleCount"] ?? 0,
    singleContent: json["singleContent"] ?? '',
  );

  factory NoticeReadModel.empty() => NoticeReadModel(
    countAll: 0,
    systemCount: 0,
    systemContent: '',
    singleCount: 0,
    singleContent: '',
  );

  Future<void> update() async {
    await UserController.to.dio?.post<NoticeReadModel>(
      ApiPath.me.getUnreadCount,
      onSuccess: (code, msg, results) async {
        countAll = results.countAll;
        systemCount = results.systemCount;
        systemContent = results.systemContent;
        singleCount = results.singleCount;
        singleContent = results.singleContent;
      },
      onModel: (m) => NoticeReadModel.fromJson(m),
    );
  }

  Map<String, dynamic> toJson() => {
    "countAll": countAll,
    "systemCount": systemCount,
    "systemContent": systemContent,
    "singleCount": singleCount,
    "singleContent": singleContent,
  };
}
