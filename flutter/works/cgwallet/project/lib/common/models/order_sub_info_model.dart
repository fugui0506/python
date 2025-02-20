
import 'package:cgwallet/common/common.dart';

class OrderSubInfoModel {
  int id;
  String createdTime;
  String orderTime1;
  String orderTime2;
  String orderTime3;
  String orderTime4;
  int sellOrderId;
  String sysOrderId;
  int memberId;
  int tradeId;
  String quantity;
  String actualQuantity;
  String amount;
  String price;
  String name;
  String account;
  int categoryId;
  String icon;
  String bankName;
  String collectCode;
  int direction;
  int status;
  String cancelTime;
  String confirmTime;
  String payTime;
  String successTime;
  String confirmExpireTime;
  String payExpireTime;
  String collectionExpireTime;
  String minAmt;
  String maxAmt;
  int isDivide;
  String payName;
  String payAccount;
  int payCategoryId;
  String payIcon;
  String payBankName;
  String payCollectCode;
  int memberAccountCollectId;
  int confirmCountdown;
  int payCountdown;
  int collectCountdown;
  String memberAvatarUrl;
  String memberBuyRate;
  String tradeAvatarUrl;
  String tradeBuyRate;
  List<PayPicture>? payPicture;
  String memberUsername;
  String tradeUsername;
  int delayFlag;
  int serverCurrentTime;
  int tempCollectId;
  int delayedSettlementTime;
  String precautions;
  List<String> arbitrationCustomerService;
  List<ArbitrationCategory> arbitrationCategory;

  OrderSubInfoModel({
    required this.id,
    required this.createdTime,
    required this.orderTime1,
    this.orderTime2 = '',
    this.orderTime3 = '',
    this.orderTime4 = '',
    required this.sellOrderId,
    this.sysOrderId = '',
    required this.memberId,
    required this.tradeId,
    this.quantity = '',
    this.actualQuantity = '',
    this.amount = '0.00',
    this.price = '',
    this.name = '',
    this.account = '',
    required this.categoryId,
    this.icon = '',
    this.bankName = '',
    this.collectCode = '',
    required this.direction,
    required this.status,
    this.cancelTime = '',
    this.confirmTime = '',
    this.payTime = '',
    this.successTime = '',
    required this.confirmExpireTime,
    this.payExpireTime = '',
    this.collectionExpireTime = '',
    this.minAmt = '',
    this.maxAmt = '',
    required this.isDivide,
    this.payName = '',
    this.payAccount = '',
    required this.payCategoryId,
    this.payIcon = '',
    this.payBankName = '',
    this.payCollectCode = '',
    required this.memberAccountCollectId,
    required this.confirmCountdown,
    required this.payCountdown,
    required this.collectCountdown,
    this.memberAvatarUrl = '',
    this.memberBuyRate = '0.00%',
    this.tradeAvatarUrl = '',
    this.tradeBuyRate = '0.00%',
    this.payPicture,
    this.memberUsername = 'User Name',
    this.tradeUsername = 'User Name',
    required this.delayFlag,
    required this.serverCurrentTime,
    required this.tempCollectId,
    required this.delayedSettlementTime,
    this.precautions = '',
    required this.arbitrationCustomerService,
    required this.arbitrationCategory,
  });

  factory OrderSubInfoModel.empty() => OrderSubInfoModel(
    id: -1,
    createdTime: '13:06:57',
    orderTime1: '13:06:57',
    orderTime2: '',
    orderTime3: '',
    orderTime4: '',
    sellOrderId: -1,
    sysOrderId: '******************',
    memberId: -1,
    tradeId: -1,
    quantity: '',
    actualQuantity: '',
    amount: '0.00',
    price: '',
    name: '',
    account: '',
    categoryId: -1,
    icon: '',
    bankName: '',
    collectCode: '',
    direction: -1,
    status: 4,
    cancelTime: '0000-00-00 00:00:00',
    confirmTime: '',
    payTime: '',
    successTime: '',
    confirmExpireTime: '0000-00-00 00:00:00',
    payExpireTime: '',
    collectionExpireTime: '',
    minAmt: '',
    maxAmt: '',
    isDivide: -1,
    payName: '',
    payAccount: '',
    payCategoryId: -1,
    payIcon: '',
    payBankName: '',
    payCollectCode: '',
    memberAccountCollectId: -1,
    confirmCountdown: -1,
    payCountdown: -1,
    collectCountdown: -1,
    memberAvatarUrl: '',
    memberBuyRate: '0.00%',
    tradeAvatarUrl: '',
    tradeBuyRate: '0.00%',
    payPicture: <PayPicture>[],
    memberUsername: 'User Name',
    tradeUsername: 'User Name',
    delayFlag: -1,
    serverCurrentTime: -1,
    tempCollectId: -1,
    delayedSettlementTime: -1,
    precautions: '',
    arbitrationCustomerService: [],
    arbitrationCategory: [],
  );

  factory OrderSubInfoModel.fromJson(Map<String, dynamic> json) => OrderSubInfoModel(
    id: json["id"] ?? -1,
    createdTime: json["createdTime"] ?? '13:06:57',
    orderTime1: json["orderTime1"] ?? '13:06:57',
    orderTime2: json["orderTime2"] ?? '',
    orderTime3: json["orderTime3"] ?? '',
    orderTime4: json["orderTime4"] ?? '',
    sellOrderId: json["sellOrderId"] ?? -1,
    sysOrderId: json["sysOrderId"] ?? '',
    memberId: json["memberId"] ?? -1,
    tradeId: json["tradeId"] ?? -1,
    quantity: json["quantity"] ?? '',
    actualQuantity: json["actualQuantity"] ?? '',
    amount: json["amount"] ?? '0.00',
    price: json["price"] ?? '',
    name: json["name"] ?? '',
    account: json["account"] ?? '',
    categoryId: json["categoryId"] ?? -1,
    icon: json["icon"] ?? '',
    bankName: json["bankName"] ?? '',
    collectCode: json["collectCode"] ?? '',
    direction: json["direction"] ?? -1,
    status: json["status"] ?? 1,
    cancelTime: json["cancelTime"] ?? '',
    confirmTime: json["confirmTime"] ?? '',
    payTime: json["payTime"] ?? '',
    successTime: json["successTime"] ?? '',
    confirmExpireTime: json["confirmExpireTime"] ?? '2024-09-02 13:06:57',
    payExpireTime: json["payExpireTime"] ?? '',
    collectionExpireTime: json["collectionExpireTime"] ?? '',
    minAmt: json["minAmt"] ?? '',
    maxAmt: json["maxAmt"] ?? '',
    isDivide: json["isDivide"] ?? -1,
    payName: json["payName"] ?? '',
    payAccount: json["payAccount"] ?? '',
    payCategoryId: json["payCategoryId"] ?? -1,
    payIcon: json["payIcon"] ?? '',
    payBankName: json["payBankName"] ?? '',
    payCollectCode: json["payCollectCode"] ?? '',
    memberAccountCollectId: json["memberAccountCollectId"] ?? -1,
    confirmCountdown: json["confirmCountdown"] ?? -1,
    payCountdown: json["payCountdown"] ?? -1,
    collectCountdown: json["collectCountdown"] ?? -1,
    memberAvatarUrl: json["memberAvatarUrl"] ?? '',
    memberBuyRate: json["MemberBuyRate"] ?? '0.00%',
    tradeAvatarUrl: json["tradeAvatarUrl"] ?? '',
    tradeBuyRate: json["tradeBuyRate"] ?? '0.00%',
    memberUsername: json["memberUsername"] ?? 'User Name',
    tradeUsername: json["tradeUsername"] ?? 'User Name',
    delayFlag: json["delayFlag"] ?? -1,
    serverCurrentTime: json["serverCurrentTime"] ?? -1,
    tempCollectId: json["tempCollectId"] ?? -1,
    delayedSettlementTime: json["delayedSettlementTime"] ?? -1,
    payPicture: json["PayPicture"] == null
      ? <PayPicture>[]
      : List<PayPicture>.from(json["PayPicture"].map((x) => PayPicture.fromJson(x))),
    precautions: json["buyPrecautions"] ?? '',
    arbitrationCustomerService: json["arbitrationCustomerService"] == null
      ? <String>[]
      : List<String>.from(json["arbitrationCustomerService"].map((x) => x.toString())),
    arbitrationCategory: json["arbitrationCategory"] == null ? [] : List<ArbitrationCategory>.from(json["arbitrationCategory"].map((e) => ArbitrationCategory.fromJson(e))),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "createdTime": createdTime,
    "orderTime1": orderTime1,
    "orderTime2": orderTime2,
    "orderTime3": orderTime3,
    "orderTime4": orderTime4,
    "sellOrderId": sellOrderId,
    "sysOrderId": sysOrderId,
    "memberId": memberId,
    "tradeId": tradeId,
    "quantity": quantity,
    "actualQuantity": actualQuantity,
    "amount": amount,
    "price": price,
    "name": name,
    "account": account,
    "categoryId": categoryId,
    "icon": icon,
    "bankName": bankName,
    "collectCode": collectCode,
    "direction": direction,
    "status": status,
    "cancelTime": cancelTime,
    "confirmTime": confirmTime,
    "payTime": payTime,
    "successTime": successTime,
    "confirmExpireTime": confirmExpireTime,
    "payExpireTime": payExpireTime,
    "collectionExpireTime": collectionExpireTime,
    "minAmt": minAmt,
    "maxAmt": maxAmt,
    "isDivide": isDivide,
    "payName": payName,
    "payAccount": payAccount,
    "payCategoryId": payCategoryId,
    "payIcon": payIcon,
    "payBankName": payBankName,
    "payCollectCode": payCollectCode,
    "memberAccountCollectId": memberAccountCollectId,
    "confirmCountdown": confirmCountdown,
    "payCountdown": payCountdown,
    "collectCountdown": collectCountdown,
    "memberAvatarUrl": memberAvatarUrl,
    "MemberBuyRate": memberBuyRate,
    "tradeAvatarUrl": tradeAvatarUrl,
    "tradeBuyRate": tradeBuyRate,
    "tradeUsername": tradeUsername,
    "memberUsername": memberUsername,
    "delayFlag": delayFlag,
    "serverCurrentTime": serverCurrentTime,
    "tempCollectId": tempCollectId,
    "delayedSettlementTime": delayedSettlementTime,
    "PayPicture": payPicture?.map((x) => x.toJson()).toList(),
    "buyPrecautions": precautions,
    "arbitrationCustomerService": arbitrationCustomerService,
    "arbitrationCategory": List<dynamic>.from(arbitrationCategory.map((x) => x.toJson())),
  };

  Future<void> update(String subId) async {
    await UserController.to.dio?.post<OrderSubInfoModel>(ApiPath.market.getSubOrderInfo,
      onSuccess: (code, msg, result) {
        id = result.id;
        createdTime = result.createdTime;
        orderTime1 = result.orderTime1;
        orderTime2 = result.orderTime2;
        orderTime3 = result.orderTime3;
        orderTime4 = result.orderTime4;
        sellOrderId = result.sellOrderId;
        sysOrderId = result.sysOrderId;
        memberId = result.memberId;
        tradeId = result.tradeId;
        quantity = result.quantity;
        actualQuantity = result.actualQuantity;
        amount = result.amount;
        price = result.price;
        name = result.name;
        account = result.account;
        categoryId = result.categoryId;
        icon = result.icon;
        bankName = result.bankName;
        collectCode = result.collectCode;
        direction = result.direction;
        status = result.status;
        cancelTime = result.cancelTime;
        confirmTime = result.confirmTime;
        payTime = result.payTime;
        successTime = result.successTime;
        confirmExpireTime = result.confirmExpireTime;
        payExpireTime = result.payExpireTime;
        collectionExpireTime = result.collectionExpireTime;
        minAmt = result.minAmt;
        maxAmt = result.maxAmt;
        isDivide = result.isDivide;
        payName = result.payName;
        payAccount = result.payAccount;
        payCategoryId = result.payCategoryId;
        payIcon = result.payIcon;
        payBankName = result.payBankName;
        payCollectCode = result.payCollectCode;
        memberAccountCollectId = result.memberAccountCollectId;
        confirmCountdown = result.confirmCountdown;
        payCountdown = result.payCountdown;
        collectCountdown = result.collectCountdown;
        memberAvatarUrl = result.memberAvatarUrl;
        memberBuyRate = result.memberBuyRate;
        tradeAvatarUrl = result.tradeAvatarUrl;
        tradeBuyRate = result.tradeBuyRate;
        tradeUsername = result.tradeUsername;
        memberUsername = result.memberUsername;
        payPicture = result.payPicture;
        precautions = result.precautions;
        tempCollectId = result.tempCollectId;
        delayedSettlementTime = result.delayedSettlementTime;
        delayFlag = result.delayFlag;
        serverCurrentTime = result.serverCurrentTime;
        arbitrationCustomerService = result.arbitrationCustomerService;
        arbitrationCategory = result.arbitrationCategory;
      },
      data: {"sysOrderId": subId},
      onModel: (m) => OrderSubInfoModel.fromJson(m),
    );
  }
}
class PayPicture {
  int id;
  int subOrderId;
  String picUrl;

  PayPicture({
    required this.id,
    required this.subOrderId,
    required this.picUrl,
  });

  factory PayPicture.fromJson(Map<String, dynamic> json) {
    return PayPicture(
      id: json['ID'] ?? 0,
      subOrderId: json['subOrderId'] ?? 0,
      picUrl: json['picUrl'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'ID': id,
      'subOrderId': subOrderId,
      'picUrl': picUrl,
    };
  }
}
