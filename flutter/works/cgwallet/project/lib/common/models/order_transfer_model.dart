import 'package:cgwallet/common/common.dart';

class OrderTransferListModel {
  List<OrderTransferModel> list;
  int total;
  int page;
  int pageSize;

  OrderTransferListModel({
    required this.list,
    required this.total,
    required this.page,
    required this.pageSize,
  });

  Future<void> onRefresh(Map<String, dynamic> data) async {
    await UserController.to.dio?.post<OrderTransferListModel>(ApiPath.transfer.getTransferHistory,
      onSuccess: (code, msg, results) async {
        list = results.list;
        total = results.total;
        page = results.page;
        pageSize = results.pageSize;
      },
      data: data,
      onModel: (m) => OrderTransferListModel.fromJson(m),
    );
  }

  Future<bool> onLoading(Map<String, dynamic> data) async {
    bool isNoData = false;
    await UserController.to.dio?.post<OrderTransferListModel>(ApiPath.transfer.getTransferHistory,
      onSuccess: (code, msg, results) async {
        if (results.list.isNotEmpty) {
          list.addAll(results.list);
          total = results.total;
          page = results.page;
          pageSize = results.pageSize;
        } else {
          isNoData = true;
        }
      },
      data: data,
      onModel: (m) => OrderTransferListModel.fromJson(m),
    );
    return isNoData;
  }

  factory OrderTransferListModel.fromJson(Map<String, dynamic> json) => OrderTransferListModel(
    list: List<OrderTransferModel>.from(json["list"].map((x) => OrderTransferModel.fromJson(x))),
    total: json["total"],
    page: json["page"],
    pageSize: json["pageSize"],
  );

  factory OrderTransferListModel.empty() {
    return OrderTransferListModel(list: [], total: -1, page: 1, pageSize: 1-1);
  }

  Map<String, dynamic> toJson() => {
    "list": List<dynamic>.from(list.map((x) => x)),
    "total": total,
    "page": page,
    "pageSize": pageSize,
  };
}

class OrderTransferModel {
  int? id;
  String createTime;
  int transferTime;
  String amount;
  int uid;
  String username;
  String nickName;
  String avatarUrl;
  int fromMemberId;
  int toMemberId;
  String toAddress;
  String fromAddress;

  OrderTransferModel({
    required this.id,
    required this.createTime,
    required this.transferTime,
    required this.amount,
    required this.uid,
    required this.username,
    required this.nickName,
    required this.avatarUrl,
    required this.fromMemberId,
    required this.toMemberId,
    required this.toAddress,
    required this.fromAddress,
  });

  factory OrderTransferModel.empty() => OrderTransferModel(
    id: -1,
    createTime: '',
    transferTime: -1,
    amount: '',
    uid: -1,
    username: '',
    nickName: '',
    avatarUrl: '',
    fromMemberId: -1,
    toMemberId: -1,
    toAddress: '',
    fromAddress:'',
  );

  factory OrderTransferModel.fromJson(Map<String, dynamic> json) => OrderTransferModel(
    id: json["ID"] ?? -1,
    createTime: json["createTime"] ?? '',
    transferTime: json["transferTime"] ?? -1,
    amount: json["amount"] ?? '',
    uid: json["uid"] ?? -1,
    username: json["username"] ?? '',
    nickName: json["nickName"] ?? '',
    avatarUrl: json["avatarUrl"] ?? '',
    fromMemberId: json["fromMemberId"] ?? -1,
    toMemberId: json["toMemberId"] ?? -1,
    toAddress: json["toAddress"] ?? '',
    fromAddress: json["fromAddress"] ?? '',
  );

  Map<String, dynamic> toJson() => {
    "ID": id,
    "createTime": createTime,
    "transferTime": transferTime,
    "amount": amount,
    "uid": uid,
    "username": username,
    "nickName": nickName,
    "avatarUrl": avatarUrl,
    "fromMemberId": fromMemberId,
    "toMemberId": toMemberId,
    "toAddress": toAddress,
    "fromAddress": fromAddress,
  };
}
