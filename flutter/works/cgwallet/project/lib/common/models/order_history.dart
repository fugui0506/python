import 'package:cgwallet/common/common.dart';

class OrderHistoryListModel {
  List<OrderHistoryModel> list;
  int total;
  int page;
  int pageSize;
  Summary summary;


  OrderHistoryListModel({
    required this.list,
    required this.total,
    required this.page,
    required this.pageSize,
    required this.summary
  });

  factory OrderHistoryListModel.fromJson(Map<String, dynamic> json) => OrderHistoryListModel(
    total: json["total"] ?? 0,
    page: json["page"] ?? 1,
    pageSize: json["pageSize"] ?? 10,
    list: List<OrderHistoryModel>.from(json["list"].map((x) => OrderHistoryModel.fromJson(x))),
    summary: Summary.fromJson(json["summary"]),
  );

  factory OrderHistoryListModel.empty() => OrderHistoryListModel(
    list: [],
    total: 0,
    page: 0,
    pageSize: 0,
    summary: Summary.empty(),
  );

  Map<String, dynamic> toJson() => {
    "total": total,
    "page": page,
    "pageSize": pageSize,
    "list": List<dynamic>.from(list.map((x) => x.toJson())),
    "summary": summary.toJson(),
  };

  Future<void> onRefresh(Map<String, dynamic> data, {bool isBuy = true}) async {
    await UserController.to.dio?.post<OrderHistoryListModel>(
      isBuy ? ApiPath.market.getHistoryBuy : ApiPath.market.getHistorySell,
      onSuccess: (code, msg, results) async {
        total = results.total;
        page = results.page;
        pageSize = results.pageSize;
        list = results.list;
        summary = results.summary;
      },
      data: data,
      onModel: (m) => OrderHistoryListModel.fromJson(m),
    );
  }

  Future<bool> onLoading(Map<String, dynamic> data, {bool isBuy = true}) async {
    bool isNoData = false;
    await UserController.to.dio?.post<OrderHistoryListModel>(
      isBuy ? ApiPath.market.getHistoryBuy : ApiPath.market.getHistorySell,
      onSuccess: (code, msg, results) async {
        if (results.list.isNotEmpty) {
          total = results.total;
          page = results.page;
          pageSize = results.pageSize;
          list.addAll(results.list);
          summary = results.summary;
        } else {
          isNoData = true;
        }
      },
      data: data,
      onModel: (m) => OrderHistoryListModel.fromJson(m),
    );
    return isNoData;
  }
}

class OrderHistoryModel {
  String sysOrderId;
  String createdTime;
  int status; // 0:挂单中  1:待确认 2:待付款 3:待收款,4:成功 5:失败 6:取消
  String quantity;
  String actualQuantity;
  String amount;
  String price;
  String? minAmt;
  String? maxAmt;
  int isDivide;
  int direction;
  String icons;
  int memberId;
  int isRelease;
  String activityInfo;
  List<OrderMarketInfoModel>? subOrders;

  OrderHistoryModel({
    required this.sysOrderId,
    required this.createdTime,
    required this.status,
    required this.quantity,
    required this.actualQuantity,
    required this.amount,
    required this.price,
    this.minAmt,
    this.maxAmt,
    required this.isDivide,
    required this.direction,
    required this.icons,
    required this.memberId,
    required this.isRelease,
    required this.activityInfo,
    this.subOrders,
  });

  factory OrderHistoryModel.fromJson(Map<String, dynamic> json) => OrderHistoryModel(
    sysOrderId: json["sysOrderId"] ?? 0,
    createdTime: json["createdTime"] ?? "",
    status: json["status"] ?? 0,
    quantity: json["quantity"] ?? "",
    actualQuantity: json["actualQuantity"] ?? "",
    amount: json["amount"] ?? "",
    price: json["price"] ?? "",
    minAmt: json["minAmt"] ?? "",
    maxAmt: json["maxAmt"] ?? "",
    isDivide: json["isDivide"] ?? 0,
    direction: json["direction"] ?? 0,
    icons: json["icons"] ?? "",
    memberId: json["memberId"] ?? 0,
    isRelease: json["isRelease"] ?? 0,
    activityInfo: json["activityInfo"] ?? "",
    subOrders: json["subOrders"] == null ? null : List<OrderMarketInfoModel>.from(json["subOrders"].map((x) => OrderMarketInfoModel.fromJson(x))),
  );


  Map<String, dynamic> toJson() => {
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
    "icons": icons,
    "memberId": memberId,
    "isRelease": isRelease,
    "activityInfo": activityInfo,
    "subOrders": subOrders == null ? null : List<dynamic>.from(subOrders!.map((x) => x.toJson())),
  };
}

class Summary {
  String totalBuyQuantity;
  String totalInProcessingBuyQuantity;
  String totalCancelBuyQuantity;
  String totalSuccessBuyQuantity;

  String totalSellQuantity;
  String totalInProcessingSellQuantity;
  String totalCancelSellQuantity;
  String totalSuccessSellQuantity;

  Summary({
    required this.totalBuyQuantity,
    required this.totalInProcessingBuyQuantity,
    required this.totalCancelBuyQuantity,
    required this.totalSuccessBuyQuantity,

    required this.totalSellQuantity,
    required this.totalInProcessingSellQuantity,
    required this.totalCancelSellQuantity,
    required this.totalSuccessSellQuantity,
  });

  factory Summary.fromJson(Map<String, dynamic> json) => Summary(
    totalBuyQuantity: json["totalBuyQuantity"] == null || json["totalBuyQuantity"].toString().isEmpty ? '0.00' : json["totalBuyQuantity"],
    totalInProcessingBuyQuantity: json["totalInProcessingBuyQuantity"] == null || json["totalInProcessingBuyQuantity"].toString().isEmpty ? '0.00' : json["totalInProcessingBuyQuantity"],
    totalCancelBuyQuantity: json["totalCancelBuyQuantity"] == null || json["totalCancelBuyQuantity"].toString().isEmpty ? '0.00' : json["totalCancelBuyQuantity"],
    totalSuccessBuyQuantity: json["totalSuccessBuyQuantity"] == null || json["totalSuccessBuyQuantity"].toString().isEmpty ? '0.00' : json["totalSuccessBuyQuantity"],

    totalSellQuantity: json["totalSellQuantity"] == null || json["totalSellQuantity"].toString().isEmpty ? '0.00' : json["totalSellQuantity"],
    totalInProcessingSellQuantity: json["totalInProcessingSellQuantity"] == null || json["totalInProcessingSellQuantity"].toString().isEmpty ? '0.00' : json["totalInProcessingSellQuantity"],
    totalCancelSellQuantity: json["totalCancelSellQuantity"] == null || json["totalCancelSellQuantity"].toString().isEmpty ? '0.00' : json["totalCancelSellQuantity"],
    totalSuccessSellQuantity: json["totalSuccessSellQuantity"] == null || json["totalSuccessSellQuantity"].toString().isEmpty ? '0.00' : json["totalSuccessSellQuantity"],
  );

  Map<String, dynamic> toJson() => {
    "totalBuyQuantity": totalBuyQuantity,
    "totalInProcessingBuyQuantity": totalInProcessingBuyQuantity,
    "totalCancelBuyQuantity": totalCancelBuyQuantity,
    "totalSuccessBuyQuantity": totalSuccessBuyQuantity,

    "totalSellQuantity": totalSellQuantity,
    "totalInProcessingSellQuantity": totalInProcessingSellQuantity,
    "totalCancelSellQuantity": totalCancelSellQuantity,
    "totalSuccessSellQuantity": totalSuccessSellQuantity,
  };

  static Summary empty() => Summary(
    totalBuyQuantity: "0",
    totalInProcessingBuyQuantity: "0",
    totalCancelBuyQuantity: "0",
    totalSuccessBuyQuantity: "0",

    totalSellQuantity: "0",
    totalInProcessingSellQuantity: "0",
    totalCancelSellQuantity: "0",
    totalSuccessSellQuantity: "0",
  );
}

class OrderHistoryParameterModel {
  int page;
  int pageSize;
  List<int> status;
  List<int> payCategoryId;
  // int dateType;
  String beginDate;
  String endDate;

  OrderHistoryParameterModel({
    required this.page,
    required this.pageSize,
    required this.status,
    required this.payCategoryId,
    // required this.dateType,
    required this.beginDate,
    required this.endDate,
  });

  factory OrderHistoryParameterModel.sell() {
    final today = DateTime.now();
    final ago = today.subtract(const Duration(days: 30));
    final beginDate = '$ago'.split(' ').first;
    final endDate = '$today'.split(' ').first;

    return OrderHistoryParameterModel(
      page: 1,
      pageSize: 10,
      status: [0, 1, 2, 3, 7],
      payCategoryId: [99],
      // dateType: 3,
      beginDate: beginDate,
      endDate: endDate,
    );
  }

  factory OrderHistoryParameterModel.buy() {
    final today = DateTime.now();
    final ago = today.subtract(const Duration(days: 30));
    final beginDate = '$ago'.split(' ').first;
    final endDate = '$today'.split(' ').first;

    return OrderHistoryParameterModel(
      page: 1,
      pageSize: 10,
      status: [99],
      payCategoryId: [99],
      // dateType: 3,
      beginDate: beginDate,
      endDate: endDate,
    );
  }

  factory OrderHistoryParameterModel.fromJson(Map<String, dynamic> json) => OrderHistoryParameterModel(
    page: json["page"],
    pageSize: json["pageSize"],
    status: json["status"],
    payCategoryId: json["payCategoryId"],
    // dateType: json["dateType"],
    beginDate: json["beginDate"],
    endDate: json["endDate"],
  );

  Map<String, dynamic> toJson() => {
    "page": page,
    "pageSize": pageSize,
    "status": status,
    "payCategoryId": payCategoryId,
    // "dateType": dateType,
    "beginDate": beginDate,
    "endDate": endDate,
  };
}
