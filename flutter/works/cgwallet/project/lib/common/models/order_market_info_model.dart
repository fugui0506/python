import 'package:cgwallet/common/common.dart';

class OrderMarketListModel {
  List<OrderMarketInfoModel> list;
  int total;
  int page;
  int pageSize;

  OrderMarketListModel({
    required this.list,
    required this.total,
    required this.page,
    required this.pageSize,
  });

  factory OrderMarketListModel.fromJson(Map<String, dynamic> json) => OrderMarketListModel(
    list: json["list"] != null
      ? List<OrderMarketInfoModel>.from(json["list"].map((x) => OrderMarketInfoModel.fromJson(x)))
      : [],
    total: json["total"] ?? 0,
    page: json["page"] ?? 0,
    pageSize: json["pageSize"] ?? 0,
  );

  factory OrderMarketListModel.empty() => OrderMarketListModel(
    list: [],
    total: 0,
    page: 0,
    pageSize: 0,
  );

  Map<String, dynamic> toJson() => {
    "list": list.map((i) => i.toJson()).toList(),
    "total": total,
    "page": page,
    "pageSize": pageSize,
  };

  Future<void> onRefresh(Map<String, dynamic> data) async {
    await UserController.to.dio?.post<OrderMarketListModel>(ApiPath.market.getMarketList,
      onSuccess: (code, msg, results) async {
        list = results.list;
        total = results.total;
        page = results.page;
        pageSize = results.pageSize;
      },
      data: data,
      onModel: (m) => OrderMarketListModel.fromJson(m),
    );
  }

  Future<bool> onLoading(Map<String, dynamic> data) async {
    bool isNoData = false;
    await UserController.to.dio?.post<OrderMarketListModel>(ApiPath.market.getMarketList,
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
      onModel: (m) => OrderMarketListModel.fromJson(m),
    );
    return isNoData;
  }
}

class OrderMarketInfoModel {
  List<Collect> collects;
  List<PayPicture>? payPicture;
  String extra;
  String activityInfo;
  int id;
  String maxAmt;
  Member member;
  String minAmt;
  List<OrderSubInfoModel> subOrders;
  String account;
  String actualQuantity;
  String amount;
  dynamic cancelTime;
  int categoryId;
  dynamic collectionExpireTime;
  dynamic confirmExpireTime;
  dynamic confirmTime;
  String createdTime;
  int deletedAt;
  int direction;
  String icon;
  String inProcessingQuantity;
  int isDivide;
  bool isOnline;
  int lockTimestamp;
  int memberId;
  int isRelease;
  String name;
  String singleOperator;
  dynamic payExpireTime;
  dynamic payTime;
  String price;
  String quantity;
  String remark;
  int sellOrderId;
  String site;
  int status;
  dynamic successTime;
  String symbol;
  String sysOrderId;
  String mainOrderId;
  int tradeId;
  String username;
  int delayedSettlementTime;
  String sellPrecautions;
  List<String> arbitrationCustomerService;
  String forSaleQuantity;
  String meReadContent;
  List<ArbitrationCategory> arbitrationCategory;

  OrderMarketInfoModel({
    required this.collects,
    required this.isRelease,
    required this.activityInfo,
    required this.forSaleQuantity,
    this.payPicture,
    required this.extra,
    required this.id,
    required this.maxAmt,
    required this.member,
    required this.minAmt,
    required this.subOrders,
    required this.account,
    required this.actualQuantity,
    required this.amount,
    required this.cancelTime,
    required this.categoryId,
    required this.collectionExpireTime,
    required this.confirmExpireTime,
    required this.confirmTime,
    required this.createdTime,
    required this.deletedAt,
    required this.direction,
    required this.icon,
    required this.inProcessingQuantity,
    required this.isDivide,
    required this.isOnline,
    required this.lockTimestamp,
    required this.memberId,
    required this.name,
    required this.singleOperator,
    required this.payExpireTime,
    required this.payTime,
    required this.price,
    required this.quantity,
    required this.remark,
    required this.sellOrderId,
    required this.site,
    required this.status,
    required this.successTime,
    required this.symbol,
    required this.sysOrderId,
    required this.mainOrderId,
    required this.tradeId,
    required this.username,
    required this.delayedSettlementTime,
    required this.sellPrecautions,
    required this.arbitrationCustomerService,
    required this.meReadContent,
    required this.arbitrationCategory,
  });

  factory OrderMarketInfoModel.fromJson(Map<String, dynamic> json) => OrderMarketInfoModel(
    collects: json["Collects"] != null
      ? List<Collect>.from(json["Collects"].map((x) => Collect.fromJson(x)))
      : [],
    payPicture: json["PayPicture"] != null
      ? List<PayPicture>.from(json["PayPicture"].map((x) => PayPicture.fromJson(x)))
      : [],
    extra: json["Extra"] ?? '',
    id: json["ID"] ?? 0,
    maxAmt: json["MaxAmt"] ?? '',
    member: json["Member"] != null
      ? Member.fromJson(json["Member"])
      : Member.fromJson({}),
    minAmt: json["MinAmt"] ?? '',
    subOrders: json["SubOrders"] != null
      ? List<OrderSubInfoModel>.from(json["SubOrders"].map((x) => OrderSubInfoModel.fromJson(x)))
      : [],
    account: json["account"] ?? '',
    actualQuantity: json["actualQuantity"] ?? '',
    amount: json["amount"] ?? '',
    cancelTime: json["cancelTime"] ?? '',
    categoryId: json["categoryId"] ?? 0,
    collectionExpireTime: json["collectionExpireTime"] ?? '',
    confirmExpireTime: json["confirmExpireTime"] ?? '',
    confirmTime: json["confirmTime"] ?? '',
    createdTime: json["createdTime"] ?? '',
    deletedAt: json["deletedAt"] ?? 0,
    direction: json["direction"] ?? 0,
    icon: json["icon"] ?? '',
    inProcessingQuantity: json["inProcessingQuantity"] ?? '',
    isDivide: json["isDivide"] ?? 0,
    isOnline: json["isOnline"] ?? false,
    lockTimestamp: json["lockTimestamp"] ?? 0,
    memberId: json["memberId"] ?? 0,
    name: json["name"] ?? '',
    singleOperator: json["operator"] ?? '',
    payExpireTime: json["payExpireTime"] ?? '',
    payTime: json["payTime"] ?? '',
    price: json["price"] ?? '',
    quantity: json["quantity"] ?? '',
    remark: json["remark"] ?? '',
    sellOrderId: json["sellOrderId"] ?? 0,
    site: json["site"] ?? '',
    status: json["status"] ?? 0,
    successTime: json["successTime"] ?? '',
    symbol: json["symbol"] ?? '',
    sysOrderId: json["sysOrderId"] ?? '',
    mainOrderId: json["mainOrderId"] ?? '',
    tradeId: json["tradeId"] ?? 0,
    username: json["username"] ?? '',
    delayedSettlementTime: json["delayedSettlementTime"] ?? 0,
    sellPrecautions: json["sellPrecautions"] ?? '',
    arbitrationCustomerService: json["arbitrationCustomerService"] == null ? [] : List<String>.from(json["arbitrationCustomerService"].map((e) => e.toString())),
    isRelease: json["isRelease"] ?? 0,
    forSaleQuantity: json["forSaleQuantity"] ?? '',
    activityInfo: json["activityInfo"] ?? '',
    meReadContent: json["meReadContent"] ?? '',
    arbitrationCategory: json["arbitrationCategory"] == null ? [] : List<ArbitrationCategory>.from(json["arbitrationCategory"].map((e) => ArbitrationCategory.fromJson(e))),
  );

  Future<void> update(String orderId, String isOrderRecord) async {
    await UserController.to.dio?.post<OrderMarketInfoModel>(ApiPath.market.getMarketOrderInfo,
      onSuccess: (code, msg, result) {
        collects = result.collects;
        payPicture = result.payPicture;
        extra = result.extra;
        id = result.id;
        maxAmt = result.maxAmt;
        member = result.member;
        minAmt = result.minAmt;
        subOrders = result.subOrders;
        account = result.account;
        actualQuantity = result.actualQuantity;
        amount = result.amount;
        cancelTime = result.cancelTime;
        categoryId = result.categoryId;
        collectionExpireTime = result.collectionExpireTime;
        confirmExpireTime = result.confirmExpireTime;
        confirmTime = result.confirmTime;
        createdTime = result.createdTime;
        deletedAt = result.deletedAt;
        direction = result.direction;
        icon = result.icon;
        inProcessingQuantity = result.inProcessingQuantity;
        isDivide = result.isDivide;
        isOnline = result.isOnline;
        lockTimestamp = result.lockTimestamp;
        memberId = result.memberId;
        name = result.name;
        singleOperator = result.singleOperator;
        payExpireTime = result.payExpireTime;
        payTime = result.payTime;
        price = result.price;
        quantity = result.quantity;
        remark = result.remark;
        sellOrderId = result.sellOrderId;
        site = result.site;
        status = result.status;
        successTime = result.successTime;
        symbol = result.symbol;
        sysOrderId = result.sysOrderId;
        mainOrderId = result.mainOrderId;
        tradeId = result.tradeId;
        username = result.username;
        delayedSettlementTime = result.delayedSettlementTime;
        sellPrecautions = result.sellPrecautions;
        arbitrationCustomerService = result.arbitrationCustomerService;
        isRelease = result.isRelease;
        forSaleQuantity = result.forSaleQuantity;
        activityInfo = result.activityInfo;
        meReadContent = result.meReadContent;
        arbitrationCategory = result.arbitrationCategory;
      },
      data: {"sysOrderId": orderId, "isOrderRecord": isOrderRecord},
      onModel: (m) => OrderMarketInfoModel.fromJson(m),
    );
  }

  Future<void> updateForId(String orderId) async {
    await UserController.to.dio?.post<OrderMarketInfoModel>(ApiPath.market.getPendingOrder,
      onSuccess: (code, msg, result) {
        if (result.id == 0) {
          return;
        }
        collects = result.collects;
        payPicture = result.payPicture;
        extra = result.extra;
        id = result.id;
        maxAmt = result.maxAmt;
        member = result.member;
        minAmt = result.minAmt;
        subOrders = result.subOrders;
        account = result.account;
        actualQuantity = result.actualQuantity;
        amount = result.amount;
        cancelTime = result.cancelTime;
        categoryId = result.categoryId;
        collectionExpireTime = result.collectionExpireTime;
        confirmExpireTime = result.confirmExpireTime;
        confirmTime = result.confirmTime;
        createdTime = result.createdTime;
        deletedAt = result.deletedAt;
        direction = result.direction;
        icon = result.icon;
        inProcessingQuantity = result.inProcessingQuantity;
        isDivide = result.isDivide;
        isOnline = result.isOnline;
        lockTimestamp = result.lockTimestamp;
        memberId = result.memberId;
        name = result.name;
        singleOperator = result.singleOperator;
        payExpireTime = result.payExpireTime;
        payTime = result.payTime;
        price = result.price;
        quantity = result.quantity;
        remark = result.remark;
        sellOrderId = result.sellOrderId;
        site = result.site;
        status = result.status;
        successTime = result.successTime;
        symbol = result.symbol;
        sysOrderId = result.sysOrderId;
        mainOrderId = result.mainOrderId;
        tradeId = result.tradeId;
        username = result.username;
        delayedSettlementTime = result.delayedSettlementTime;
        sellPrecautions = result.sellPrecautions;
        arbitrationCustomerService = result.arbitrationCustomerService;
        isRelease = result.isRelease;
        forSaleQuantity = result.forSaleQuantity;
        activityInfo = result.activityInfo;
        meReadContent = result.meReadContent;
        arbitrationCategory = result.arbitrationCategory;
      },
      data: {"sysOrderId": orderId},
      onModel: (m) => OrderMarketInfoModel.fromJson(m),
    );
  }

  factory OrderMarketInfoModel.empty() => OrderMarketInfoModel(
    collects: [],
    payPicture: [],
    extra: '',
    id: -1,
    maxAmt: '',
    member: Member.empty(),
    minAmt: '',
    subOrders: [],
    account: '',
    actualQuantity: '0.00',
    amount: '0.00',
    cancelTime: '',
    categoryId: -1,
    collectionExpireTime: '',
    confirmExpireTime: '',
    confirmTime: '',
    createdTime: '',
    deletedAt: -1,
    direction: -1,
    icon: '',
    inProcessingQuantity: '',
    isDivide: -1,
    isOnline: false,
    lockTimestamp: -1,
    memberId: -1,
    name: '',
    singleOperator: '',
    payExpireTime: '',
    payTime: '',
    price: '',
    quantity: '0.00',
    remark: '',
    sellOrderId: -1,
    site: '',
    status: -1,
    successTime: '',
    symbol: '',
    sysOrderId: '',
    mainOrderId: '',
    tradeId: -1,
    username: '',
    delayedSettlementTime: -1,
    sellPrecautions: '',
    arbitrationCustomerService: [''],
    isRelease: -1,
    forSaleQuantity: '',
    activityInfo: '',
    meReadContent: '',
    arbitrationCategory: [],
  );

  Map<String, dynamic> toJson() => {
    "Collects": List<dynamic>.from(collects.map((x) => x.toJson())),
    "PayPicture": payPicture != null
      ? List<dynamic>.from(payPicture!.map((x) => x.toJson()))
      : [],
    "Extra": extra,
    "ID": id,
    "MaxAmt": maxAmt,
    "Member": member.toJson(),
    "MinAmt": minAmt,
    "SubOrders": List<dynamic>.from(subOrders.map((x) => x.toJson())),
    "account": account,
    "actualQuantity": actualQuantity,
    "amount": amount,
    "cancelTime": cancelTime,
    "categoryId": categoryId,
    "collectionExpireTime": collectionExpireTime,
    "confirmExpireTime": confirmExpireTime,
    "confirmTime": confirmTime,
    "createdTime": createdTime,
    "deletedAt": deletedAt,
    "direction": direction,
    "icon": icon,
    "inProcessingQuantity": inProcessingQuantity,
    "isDivide": isDivide,
    "isOnline": isOnline,
    "lockTimestamp": lockTimestamp,
    "memberId": memberId,
    "name": name,
    "operator": singleOperator,
    "payExpireTime": payExpireTime,
    "payTime": payTime,
    "price": price,
    "quantity": quantity,
    "remark": remark,
    "sellOrderId": sellOrderId,
    "site": site,
    "status": status,
    "successTime": successTime,
    "symbol": symbol,
    "sysOrderId": sysOrderId,
    "mainOrderId": mainOrderId,
    "tradeId": tradeId,
    "username": username,
    "delayedSettlementTime": delayedSettlementTime,
    "sellPrecautions": sellPrecautions,
    "arbitrationCustomerService": List<dynamic>.from(arbitrationCustomerService.map((x) => x)),
    "isRelease": isRelease,
    "forSaleQuantity": forSaleQuantity,
    "activityInfo": activityInfo,
    "meReadContent": meReadContent,
    "arbitrationCategory": List<dynamic>.from(arbitrationCategory.map((x) => x.toJson())),
  };
}

class SellOrderArgument {
  String marketOrderId;
  String subOrderId;
  String type;

  SellOrderArgument({
    required this.marketOrderId,
    required this.subOrderId,
    required this.type 
  });

  factory SellOrderArgument.fromJson(Map<String, dynamic> json) => SellOrderArgument(
    marketOrderId: json["MarketOrderId"] ?? '',
    subOrderId: json["SubOrderId"] ?? '',
    type: json["Type"] ?? '',
  );

  factory SellOrderArgument.empty() => SellOrderArgument(
    marketOrderId: '',
    subOrderId: '',
    type: '',
  );

  Map<String, dynamic> toJson() => {
    "MarketOrderId": marketOrderId,
    "SubOrderId": subOrderId,
  };
}

class ArbitrationCategory {
  int arbitrationType;
  int categoryId;
  String categoryName;

  ArbitrationCategory({
    required this.categoryId,
    required this.categoryName,
    required this.arbitrationType,
  });

  factory ArbitrationCategory.fromJson(Map<String, dynamic> json) => ArbitrationCategory(
    categoryId: json["categoryId"] ?? -1,
    categoryName: json["categoryName"] ?? '',
    arbitrationType: json["arbitrationType"]?? -1,
  );

  Map<String, dynamic> toJson() => {
    "categoryId": categoryId,
    "categoryName": categoryName,
    "arbitrationType": arbitrationType,
  };
}
