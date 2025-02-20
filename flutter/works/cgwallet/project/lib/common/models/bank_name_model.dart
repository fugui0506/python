import 'dart:convert';
import 'package:cgwallet/common/common.dart';

class BankNameMapListModel {
  List<BankNameMapModel> list;

  BankNameMapListModel({
    required this.list,
  });

  factory BankNameMapListModel.fromJson(Map<String, dynamic> json) {
    List<BankNameMapModel> bankNameMapList = [];
    json.entries.map((e) => bankNameMapList.add(BankNameMapModel.fromJson({
      "typeName": e.key,
      "bankNameList": e.value,
    }))).toList();
    return BankNameMapListModel(
      list: bankNameMapList,
    );
  }

  factory BankNameMapListModel.fromCache(Map<String, dynamic> json) => BankNameMapListModel(
    list: List<BankNameMapModel>.from(json["list"].map((x) => BankNameMapModel.fromJson(x)))
  );

  factory BankNameMapListModel.empty() => BankNameMapListModel(
    list: [],
  );

  Map<String, dynamic> toJson() => {
    "list": list.map((i) => i.toJson()).toList(),
  };

  Future<void> update() async {
    final path = ApiPath.category.getBankNameInfo;
    final file = await MyCache.to.getFile(UserController.to.baseUrl + path);
    if (file != null) {
      String jsonString = await file.readAsString();
      BankNameMapListModel model = BankNameMapListModel.fromCache(jsonDecode(jsonString));
      list = model.list;
    } else {
      await UserController.to.dio?.get<BankNameMapListModel>(path,
        onSuccess: (code, msg, results) async {
          list = results.list;
          String jsonString = jsonEncode(results.toJson());
          await MyCache.to.putFile(UserController.to.baseUrl + path, jsonString);
        },
        onModel: (m) => BankNameMapListModel.fromJson(m),
      );
    }
  }
}

class BankNameMapModel {
  String typeName;
  List<BankNameModel> bankNameList;

  BankNameMapModel({
    required this.typeName,
    required this.bankNameList,
  });

  factory BankNameMapModel.fromJson(Map<String, dynamic> json) => BankNameMapModel(
    typeName: json["typeName"] ?? '',
    bankNameList: List<BankNameModel>.from(json["bankNameList"].map((i) => BankNameModel.fromJson(i))),
  );

  factory BankNameMapModel.empty() => BankNameMapModel(
    typeName: '',
    bankNameList: [],
  );

  Map<String, dynamic> toJson() => {
    "typeName": typeName,
    "bankNameList": bankNameList.map((i) => i.toJson()).toList(),
  };
}

class BankNameModel {
  final int id;
  final String bankName;
  final String bankCode;
  final String bankAddress;
  final int bindNum;
  final int bindCount;
  final int grabCount;
  final double grabAmount;
  final int status;

  BankNameModel({
    required this.id,
    required this.bankName,
    required this.bankCode,
    required this.bankAddress,
    required this.bindNum,
    required this.bindCount,
    required this.grabCount,
    required this.grabAmount,
    required this.status,
  });

  factory BankNameModel.empty() => BankNameModel(
    id: -1,
    bankName: '',
    bankCode: '',
    bankAddress: '',
    bindNum: -1,
    bindCount: -1,
    grabCount: -1,
    grabAmount: -1,
    status: -1,
  );

  factory BankNameModel.fromJson(Map<String, dynamic> json) => BankNameModel(
    id: json["ID"] ?? -1,
    bankName: json["bankName"] ?? '',
    bankCode: json["bankCode"] ?? '',
    bankAddress: json["bankAddress"] ?? '',
    bindNum: json["bindNum"] ?? -1,
    bindCount: json["bindCount"] ?? -1,
    grabCount: json["grabCount"] ?? -1,
    grabAmount: json["grabAmount"]?.toDouble() ?? -1,
    status: json["status"] ?? -1,
  );

  Map<String, dynamic> toJson() => {
    "ID": id,
    "bankName": bankName,
    "bankCode": bankCode,
    "bankAddress": bankAddress,
    "bindNum": bindNum,
    "bindCount": bindCount,
    "grabCount": grabCount,
    "grabAmount": grabAmount,
    "status": status,
  };
}
