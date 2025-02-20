import 'models.dart';

class WebsocketMsgModel {
  int msgId;
  int type;
  String from;
  String to;
  int ope;
  String? content;
  int timeStamp;
  int markRead;
  int forcePushAll;
  Ext ext;
  int device;
  String extra;

  WebsocketMsgModel({
    required this.msgId,
    required this.type,
    required this.from,
    required this.to,
    required this.ope,
    required this.content,
    required this.timeStamp,
    required this.markRead,
    required this.forcePushAll,
    required this.ext,
    required this.device,
    required this.extra,
  });

  factory WebsocketMsgModel.empty() => WebsocketMsgModel(
    msgId: 0,
    type: 0,
    from: '',
    to: '',
    ope: 0,
    content: '',
    timeStamp: 0,
    markRead: 0,
    forcePushAll: 0,
    ext: Ext.empty(),
    device: 0,
    extra: '',
  );

  factory WebsocketMsgModel.fromJson(Map<String, dynamic> json) => WebsocketMsgModel(
    msgId: json["msgId"] ?? 0,
    type: json["type"] ?? 0, 
    from: json["from"] ?? '',
    to: json["to"] ?? '',
    ope: json["ope"] ?? 0, 
    content: json["content"],
    timeStamp: json["timeStamp"] ?? 0, 
    markRead: json["markRead"] ?? 0, 
    forcePushAll: json["forcePushAll"] ?? 0, 
    ext: json["ext"] == null ? Ext.empty() : Ext.fromJson(json["ext"]),
    device: json["device"] ?? 0, 
    extra: json["extra"] ?? '',
  );

  Map<String, dynamic> toJson() => {
    "msgId": msgId,
    "type": type,
    "from": from,
    "to": to,
    "ope": ope,
    "content": content,
    "timeStamp": timeStamp,
    "markRead": markRead,
    "forcePushAll": forcePushAll,
    "ext": ext.toJson(),
    "device": device,
    "extra": extra,
  };
}

class Ext {
  String title;
  int msgType;
  int? riskType;
  Broadcast? broadcast;
  OrderMarketInfoModel? single;
  MemberBroadcast? memberBroadcast;
  Map<String, dynamic>? changePayment;
  OrderFlashInfoModel? swapOrderMsg;
  List<NotifyModel>? sysAnnouncementMsg;

  Ext({
    required this.title,
    required this.msgType,
    this.broadcast,
    this.single,
    this.memberBroadcast,
    this.changePayment,
    this.swapOrderMsg,
    this.riskType,
    this.sysAnnouncementMsg,  
  });

  factory Ext.empty() => Ext(
    title: '',
    msgType: 0,
    broadcast: null,
    single: null,
    memberBroadcast: null,
    changePayment: null,
    swapOrderMsg: null,
    riskType: null,
    sysAnnouncementMsg: null,
  );

  factory Ext.fromJson(Map<String, dynamic> json) => Ext(
    title: json["title"] ?? '',
    msgType: json["msgType"] ?? 0,
    broadcast: json["broadcast"] == null ? null : Broadcast.fromJson(json["broadcast"]),
    single: json["single"] == null ? null : OrderMarketInfoModel.fromJson(json["single"]),
    memberBroadcast: json["memberBroadcast"] == null ? null : MemberBroadcast.fromJson(json["memberBroadcast"]),
    changePayment: json["changePayment"],
    swapOrderMsg: json["swapOrderMsg"] == null ? null : OrderFlashInfoModel.fromJson(json["swapOrderMsg"]),
    riskType: json["riskType"],
    sysAnnouncementMsg: json["sysAnnouncementMsg"] == null ? null : List<NotifyModel>.from(json["sysAnnouncementMsg"].map((x) => NotifyModel.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "title": title,
    "msgType": msgType,
    "broadcast": broadcast?.toJson(),
    "single": single?.toJson(),
    "memberBroadcast": memberBroadcast?.toJson(),
    "changePayment": changePayment,
    "swapOrderMsg": swapOrderMsg?.toJson(),
    "riskType": riskType,
    "sysAnnouncementMsg": List<dynamic>.from(sysAnnouncementMsg?.map((x) => x.toJson()) ?? []),
  };
}

class Broadcast {
  int id;
  String sysOrderId;
  String createdTime;
  int status;
  String quantity;
  String actualQuantity;
  String amount;
  String price;
  String minAmt;
  String maxAmt;
  int isDivide;
  int direction;
  bool isOnline;
  int memberId;
  List<Collect>? collects;

  Broadcast({
    required this.id,
    required this.sysOrderId,
    required this.createdTime,
    required this.status,
    required this.quantity,
    required this.actualQuantity,
    required this.amount,
    required this.price,
    required this.minAmt,
    required this.maxAmt,
    required this.isDivide,
    required this.direction,
    required this.isOnline,
    required this.memberId,
    this.collects,
  });

  factory Broadcast.fromJson(Map<String, dynamic> json) => Broadcast(
    id: json["id"] ?? 0,
    sysOrderId: json["sysOrderId"] ?? '',
    createdTime: json["createdTime"] ?? '',
    status: json["status"] ?? 0,
    quantity: json["quantity"] ?? '',
    actualQuantity: json["actualQuantity"] ?? '',
    amount: json["amount"] ?? '',
    price: json["price"] ?? '',
    minAmt: json["minAmt"] ?? '',
    maxAmt: json["maxAmt"] ?? '',
    isDivide: json["isDivide"] ?? 0,
    direction: json["direction"] ?? 0,
    isOnline: json["isOnline"] ?? true,
    memberId: json["memberId"] ?? 0,
    collects: json["Collects"] == null ? null : List<Collect>.from(json["Collects"].map((x) => Collect.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "sysOrderId": sysOrderId,
    "createdTime": createdTime,
    "status": status,
    "quantity": quantity,
    "actualQuantity": actualQuantity,
    "amount": amount,
    "price": price,
    "minAmt": minAmt,
    "maxAmt": maxAmt,
    "isDivide": isDivide,
    "direction": direction,
    "isOnline": isOnline,
    "memberId": memberId,
    "Collects": collects == null ? null : List<dynamic>.from(collects!.map((x) => x.toJson())),
  };
}

class MemberBroadcast {
  int memberId;
  bool isOnline;

  MemberBroadcast({
    required this.memberId,
    required this.isOnline,
  });

  factory MemberBroadcast.empty() => MemberBroadcast(
    memberId: 0,
    isOnline: false,
  );

  factory MemberBroadcast.fromJson(Map<String, dynamic> json) => MemberBroadcast(
    memberId: json["memberId"] ?? 0,
    isOnline: json["IsOnline"] ?? false,
  );

  Map<String, dynamic> toJson() => {
    "memberId": memberId,
    "IsOnline": isOnline,
  };
}



class Collect {
  int id;
  String account;
  String accountName;
  String bankName;
  int categoryId;
  String createdTime;
  int deletedAt;
  String icon;
  String payCategorySn;
  String qrCodeUrl;
  int sellOrderId;
  int updatedAt;
  String updatedTime;

  Collect({
    required this.id,
    required this.account,
    required this.accountName,
    required this.bankName,
    required this.categoryId,
    required this.createdTime,
    required this.deletedAt,
    required this.icon,
    required this.payCategorySn,
    required this.qrCodeUrl,
    required this.sellOrderId,
    required this.updatedAt,
    required this.updatedTime,
  });

  factory Collect.fromJson(Map<String, dynamic> json) => Collect(
    id: json["ID"] ?? 0,
    account: json["account"] ?? '',
    accountName: json["accountName"] ?? '',
    bankName: json["bankName"] ?? '',
    categoryId: json["categoryId"] ?? 0,
    createdTime: json["createdTime"] ?? '',
    deletedAt: json["deletedAt"] ?? 0,
    icon: json["icon"] ?? '',
    payCategorySn: json["payCategorySn"] ?? '',
    qrCodeUrl: json["qrCodeUrl"] ?? '',
    sellOrderId: json["sellOrderId"] ?? 0,
    updatedAt: json["updatedAt"] ?? 0,
    updatedTime: json["updatedTime"] ?? '',
  );

  Map<String, dynamic> toJson() => {
    "ID": id,
    "account": account,
    "accountName": accountName,
    "bankName": bankName,
    "categoryId": categoryId,
    "createdTime": createdTime,
    "deletedAt": deletedAt,
    "icon": icon,
    "payCategorySn": payCategorySn,
    "qrCodeUrl": qrCodeUrl,
    "sellOrderId": sellOrderId,
    "updatedAt": updatedAt,
    "updatedTime": updatedTime,
  };
}


class Member {
  int id;
  String username;
  String phone;
  String realName;
  String nickName;
  String avatarUrl;
  int enable;
  int isAuth;
  int lastTime;
  String lastAt;
  String lastIp;

  Member({
    required this.id,
    required this.username,
    required this.phone,
    required this.realName,
    required this.nickName,
    required this.avatarUrl,
    required this.enable,
    required this.isAuth,
    required this.lastTime,
    required this.lastAt,
    required this.lastIp,
  });

  factory Member.fromJson(Map<String, dynamic> json) => Member(
    id: json["ID"] ?? 0,
    username: json["username"] ?? '',
    phone: json["phone"] ?? '',
    realName: json["realName"] ?? '',
    nickName: json["nickName"] ?? '',
    avatarUrl: json["avatarUrl"] ?? '',
    enable: json["enable"] ?? 0,
    isAuth: json["isAuth"] ?? 0,
    lastTime: json["lastTime"] ?? 0,
    lastAt: json["lastAt"] ?? '',
    lastIp: json["lastIP"] ?? '',
  );

  factory Member.empty() => Member(
    id: -1,
    username: '',
    phone: '',
    realName: '',
    nickName: '',
    avatarUrl: '',
    enable: 0,
    isAuth: 0,
    lastTime: 0,
    lastAt: '',
    lastIp: '',
  );

  Map<String, dynamic> toJson() => {
    "ID": id,
    "username": username,
    "phone": phone,
    "realName": realName,
    "nickName": nickName,
    "avatarUrl": avatarUrl,
    "enable": enable,
    "isAuth": isAuth,
    "lastTime": lastTime,
    "lastAt": lastAt,
    "lastIP": lastIp,
  };
}

