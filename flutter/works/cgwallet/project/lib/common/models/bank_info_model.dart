import 'package:cgwallet/common/common.dart';

class BankAllListModel {
  List<BankInfoListModel> list;

  BankAllListModel({
    required this.list,
  });

  factory BankAllListModel.fromJson(List<dynamic> json) => BankAllListModel(
    list: json.map((i) => BankInfoListModel.fromJson(i)).toList(),
  );

  factory BankAllListModel.empty() => BankAllListModel(
    list: [],
  );

  Map<String, dynamic> toJson() => {
    "list": list.map((i) => i.toJson()).toList(),
  };

  Future<void> update() async {
    await UserController.to.dio?.post<BankInfoListModel>(ApiPath.category.getBankAllList,
      onSuccess: (code, msg, results) async {
        var categoryInfoList = UserController.to.categoryList.value.list;
        var length = categoryInfoList.length;
        var data = List.generate(length, (index) => BankInfoListModel.empty());
        for (var i = 0; i < length; i++) {
          for (var element in results.list) {
            if (categoryInfoList[i].id == element.payCategoryId) {
              element.isDefault == 1 ? data[i].list.insert(0, element) : data[i].list.add(element);
            }
          }
        }
        list = data;
      },
      data:  {
        "payCategoryId": 0,
        "isEnable": 1,
      },
      onModel: (m) => BankInfoListModel.fromJson(m),
    );
  }
}

class BankInfoListModel {
  List<BankInfoModel> list;

  BankInfoListModel({
    required this.list,
  });

  factory BankInfoListModel.fromJson(List<dynamic> json) => BankInfoListModel(
    list: json.map((i) => BankInfoModel.fromJson(i)).toList(),
  );

  factory BankInfoListModel.empty() => BankInfoListModel(
    list: [],
  );

  Map<String, dynamic> toJson() => {
    "list": list.map((i) => i.toJson()).toList(),
  };
}

class BankInfoModel {
  int id;
  int memberId;
  int payCategoryId;
  int payChannelId;
  int bankId;
  String bank;
  String account;
  String accountName;
  String qrcode;
  String bankAddress;
  int isDefault;
  int status;
  int isEnable;
  String dailyAmount;
  String dailyAmountUsed;
  String qrcodeUrl;
  int verifiedAt;
  String categoryName;
  String payCategorySn;
  String icon;

  BankInfoModel({
    required this.id,
    required this.memberId,
    required this.payCategoryId,
    required this.payChannelId,
    required this.bankId,
    required this.bank,
    required this.account,
    required this.accountName,
    required this.qrcode,
    required this.bankAddress,
    required this.isDefault,
    required this.status,
    required this.isEnable,
    required this.dailyAmount,
    required this.dailyAmountUsed,
    required this.qrcodeUrl,
    required this.verifiedAt,
    required this.categoryName,
    required this.payCategorySn,
    required this.icon,
  });

  factory BankInfoModel.empty() => BankInfoModel(
    id: -1,
    memberId: -1,
    payCategoryId: -1,
    payChannelId: -1,
    bankId: -1,
    bank: '',
    account: '',
    accountName: '',
    qrcode: '',
    bankAddress: '',
    isDefault: -1,
    status: -1,
    isEnable: -1,
    dailyAmount: '',
    dailyAmountUsed: '',
    qrcodeUrl: '',
    verifiedAt: -1,
    categoryName: '',
    payCategorySn: '',
    icon: '',
  );

  factory BankInfoModel.fromJson(Map<String, dynamic> json) => BankInfoModel(
    id: json["ID"] ?? -1,
    memberId: json["MemberId"] ?? -1,
    payCategoryId: json["PayCategoryId"] ?? -1,
    payChannelId: json["PayChannelId"] ?? -1,
    bankId: json["BankId"] ?? -1,
    bank: json["Bank"] ?? '',
    account: json["Account"] ?? '',
    accountName: json["AccountName"] ?? '',
    qrcode: json["Qrcode"] ?? '',
    bankAddress: json["BankAddress"] ?? '',
    isDefault: json["IsDefault"] ?? -1,
    status: json["Status"] ?? -1,
    isEnable: json["IsEnable"] ?? -1,
    dailyAmount: json["DailyAmount"] ?? '',
    dailyAmountUsed: json["DailyAmountUsed"] ?? '',
    qrcodeUrl: json["QrcodeUrl"] ?? '',
    verifiedAt: json["VerifiedAt"] ?? -1,
    categoryName: json["categoryName"] ?? '',
    payCategorySn: json["payCategorySn"] ?? '',
    icon: json["icon"] ?? '',
  );

  Map<String, dynamic> toJson() => {
    "ID": id,
    "MemberId": memberId,
    "PayCategoryId": payCategoryId,
    "PayChannelId": payChannelId,
    "BankId": bankId,
    "Bank": bank,
    "Account": account,
    "AccountName": accountName,
    "Qrcode": qrcode,
    "BankAddress": bankAddress,
    "IsDefault": isDefault,
    "Status": status,
    "IsEnable": isEnable,
    "DailyAmount": dailyAmount,
    "DailyAmountUsed": dailyAmountUsed,
    "QrcodeUrl": qrcodeUrl,
    "VerifiedAt": verifiedAt,
    "categoryName": categoryName,
    "payCategorySn": payCategorySn,
    "icon": icon,
  };
}
