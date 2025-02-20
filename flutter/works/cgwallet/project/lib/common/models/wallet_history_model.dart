import 'package:cgwallet/common/common.dart';

class WalletHistoryListModel {
  List<WalletHistoryModel> list;

  WalletHistoryListModel({
    this.list = const [],
  });

  factory WalletHistoryListModel.fromJson(List<dynamic> json) => WalletHistoryListModel(
    list: json.map((i) => WalletHistoryModel.fromJson(i)).toList()
  );

  factory WalletHistoryListModel.empty() => WalletHistoryListModel(
    list: [],
  );

  Map<String, dynamic> toJson() => {
    "list": list.map((x) => x.toJson()).toList(),
  };

  Future<void> update(Map<String, dynamic> data) async {
    await UserController.to.dio?.post<WalletHistoryListModel>(ApiPath.transfer.getWalletHistory,
      onSuccess: (code, msg, results) async {
        list = results.list;
      },
      onModel: (m) => WalletHistoryListModel.fromJson(m),
      data: data,
    );
  } 
}

class WalletHistoryModel {
  int id;
  String typeName;
  String amount;
  String createdTime;
  int typeId;
  String balance;
  String preBalance;
  String preLockBalance;
  String lockBalance;
  String sysOrderId;

  WalletHistoryModel({
    this.id = -1,
    this.typeName = "",
    this.typeId = -1,
    this.amount = "0.00",
    this.createdTime = "",
    this.balance = "0.00",
    this.preBalance = "0.00",
    this.preLockBalance = "0.00",
    this.lockBalance = "0.00",
    this.sysOrderId = "",
  });

  factory WalletHistoryModel.fromJson(Map<String, dynamic> json) => WalletHistoryModel(
    id: json["id"] ?? -1,
    typeName: json["typeName"] ?? "",
    typeId: json["typeId"] ?? -1,
    amount: json["amount"] ?? "0.00",
    createdTime: json["createdTime"] ?? "",
    balance: json["balance"] ?? "0.00",
    preBalance: json["preBalance"] ?? "0.00",
    preLockBalance: json["preLockBalance"] ?? "0.00",
    lockBalance: json["lockBalance"] ?? "0.00",
    sysOrderId: json["sysOrderId"] ?? "",
  );

  factory WalletHistoryModel.empty() => WalletHistoryModel(
    id: -1,
    createdTime: "",
    typeId: -1,
    typeName: "",
    amount: "0.00",
    balance: "0.00",
    preBalance: "0.00",
    preLockBalance: "0.00",
    lockBalance: "0.00",
    sysOrderId: "",
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "typeName": typeName,
    "typeId": typeId,
    "amount": amount,
    "createdTime": createdTime,
    "balance": balance,
    "preBalance": preBalance,
    "preLockBalance": preLockBalance,
    "lockBalance": lockBalance,
    "sysOrderId": sysOrderId,
  };
}
