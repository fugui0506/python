import 'package:cgwallet/common/common.dart';

class OrderFlashInfoListModel {
  List<OrderFlashInfoModel> list;
  int total;
  int page;
  int pageSize;

  OrderFlashInfoListModel({
    required this.list,
    required this.total,
    required this.page,
    required this.pageSize,
  });

  factory OrderFlashInfoListModel.fromJson(Map<String, dynamic> json) => OrderFlashInfoListModel(
    list: json["list"] == null ? [] : List<OrderFlashInfoModel>.from(json["list"].map((x) => OrderFlashInfoModel.fromJson(x))),
    total: json["total"] ?? -1,
    page: json["page"] ?? -1,
    pageSize: json["pageSize"] ?? -1,
  );

  factory OrderFlashInfoListModel.empty() {
    return OrderFlashInfoListModel(list: [], total: 0, page: 1, pageSize: 10);
  }

  Future<void> onRefresh(Map<String, dynamic> data) async {
    await UserController.to.dio?.post<OrderFlashInfoListModel>(ApiPath.swap.getSwapOrderList,
      onSuccess: (code, msg, results) async {
        total = results.total;
        page = results.page;
        pageSize = results.pageSize;
        list = results.list;
      },
      data: data,
      onModel: (m) => OrderFlashInfoListModel.fromJson(m),
    );
  }

  Future<bool> onLoading(Map<String, dynamic> data) async {
    bool isNoData = false;
    await UserController.to.dio?.post<OrderFlashInfoListModel>(ApiPath.swap.getSwapOrderList,
      onSuccess: (code, msg, results) async {
        if (results.list.isNotEmpty) {
          total = results.total;
          page = results.page;
          pageSize = results.pageSize;
          list.addAll(results.list);
        } else {
          isNoData = true;
        }
      },
      data: data,
      onModel: (m) => OrderFlashInfoListModel.fromJson(m),
    );
    return isNoData;
  }

  Map<String, dynamic> toJson() => {
    "list": List<dynamic>.from(list.map((x) => x)),
    "total": total,
    "page": page,
    "pageSize": pageSize,
  };
}

class OrderFlashInfoModel {
  String sysOrderId;
  int memberId;
  double usdtQuantity;
  String qrCode;
  String exchangeRate;
  double amount;
  String pact;
  String address;
  int memberConfirmAt;
  int adminConfirmAt;
  int successAt;
  int memberConfirmLimitAt;
  int adminConfirmLimitAt;
  String createdTime;
  String memberConfirmTime;
  String adminConfirmTime;
  String successTime;
  String memberConfirmLimitTime;
  String adminConfirmLimitTime;
  int status;
  String cancelType;
  int cancelStep;
  String remark;
  String flashOrderInfoModelOperator;
  bool blockResult;

  OrderFlashInfoModel({
    required this.sysOrderId,
    required this.memberId,
    required this.usdtQuantity,
    required this.qrCode,
    required this.exchangeRate,
    required this.amount,
    required this.pact,
    required this.address,
    required this.memberConfirmAt,
    required this.adminConfirmAt,
    required this.successAt,
    required this.memberConfirmLimitAt,
    required this.adminConfirmLimitAt,
    required this.createdTime,
    required this.memberConfirmTime,
    required this.adminConfirmTime,
    required this.successTime,
    required this.memberConfirmLimitTime,
    required this.adminConfirmLimitTime,
    required this.status,
    required this.cancelType,
    required this.cancelStep,
    required this.remark,
    required this.flashOrderInfoModelOperator,
    required this.blockResult,
  });

  Future<void> update(String id) async {
    await UserController.to.dio?.post<OrderFlashInfoModel>(ApiPath.swap.getSwapOrderInfo,
      onSuccess: (code, msg, results) async {
        sysOrderId = results.sysOrderId;
        memberId = results.memberId;
        usdtQuantity = results.usdtQuantity;
        qrCode = results.qrCode;
        exchangeRate = results.exchangeRate;
        amount = results.amount;
        pact = results.pact;
        address = results.address;
        memberConfirmAt = results.memberConfirmAt;
        adminConfirmAt = results.adminConfirmAt;
        successAt = results.successAt;
        memberConfirmLimitAt = results.memberConfirmLimitAt;
        adminConfirmLimitAt = results.adminConfirmLimitAt;
        createdTime = results.createdTime;
        memberConfirmTime = results.memberConfirmTime;
        adminConfirmTime = results.adminConfirmTime;
        successTime = results.successTime;
        memberConfirmLimitTime = results.memberConfirmLimitTime;
        adminConfirmLimitTime = results.adminConfirmLimitTime;
        status = results.status;
        cancelType = results.cancelType;
        cancelStep = results.cancelStep;
        remark = results.remark;
        flashOrderInfoModelOperator = results.flashOrderInfoModelOperator;
        blockResult = results.blockResult;
      },
      data:  {
        "orderId": id,
      },
      onModel: (m) => OrderFlashInfoModel.fromJson(m),
    );
  }

  factory OrderFlashInfoModel.empty() => OrderFlashInfoModel(
    sysOrderId: "",
    memberId: -1,
    usdtQuantity: 0,
    qrCode: "",
    exchangeRate: "",
    amount: 0,
    pact: "",
    address: "",
    memberConfirmAt: 0,
    adminConfirmAt: 0,
    successAt: 0,
    memberConfirmLimitAt: 0,
    adminConfirmLimitAt: 0,
    createdTime: "",
    memberConfirmTime: "",
    adminConfirmTime: "",
    successTime: "",
    memberConfirmLimitTime: "",
    adminConfirmLimitTime: "",
    status: 0,
    cancelType: "",
    cancelStep: 0,
    remark: "",
    flashOrderInfoModelOperator: "",
    blockResult: false,
  );

  factory OrderFlashInfoModel.fromJson(Map<String, dynamic> json) => OrderFlashInfoModel(
    sysOrderId: json["sysOrderId"] ?? "",
    memberId: json["memberId"] ?? -1,
    usdtQuantity: json["usdtQuantity"] == null ? 0 : double.parse('${json["usdtQuantity"]}'),
    qrCode: json["qrCode"] ?? "",
    exchangeRate: json["exchangeRate"] ?? "",
    amount: json["amount"] == null ? 0 : double.parse('${json["amount"]}'),
    pact: json["pact"] ?? "",
    address: json["address"] ?? "",
    memberConfirmAt: json["memberConfirmAt"] ?? 0,
    adminConfirmAt: json["adminConfirmAt"] ?? 0,
    successAt: json["successAt"] ?? 0,
    memberConfirmLimitAt: json["memberConfirmLimitAt"] ?? 0,
    adminConfirmLimitAt: json["adminConfirmLimitAt"] ?? 0,
    createdTime: json["createdTime"] ?? "",
    memberConfirmTime: json["memberConfirmTime"] ?? "",
    adminConfirmTime: json["adminConfirmTime"] ?? "",
    successTime: json["successTime"] ?? "",
    memberConfirmLimitTime: json["memberConfirmLimitTime"] ?? "",
    adminConfirmLimitTime: json["adminConfirmLimitTime"] ?? "",
    status: json["status"] ?? 0,
    cancelType: json["cancelType"] ?? "",
    cancelStep: json["cancelStep"] ?? 0,
    remark: json["remark"] ?? "",
    flashOrderInfoModelOperator: json["operator"] ?? "",
    blockResult: json["blockResult"] ?? false,
  );

  Map<String, dynamic> toJson() => {
    "sysOrderId": sysOrderId,
    "memberId": memberId,
    "usdtQuantity": usdtQuantity,
    "qrCode": qrCode,
    "exchangeRate": exchangeRate,
    "amount": amount,
    "pact": pact,
    "address": address,
    "memberConfirmAt": memberConfirmAt,
    "adminConfirmAt": adminConfirmAt,
    "successAt": successAt,
    "memberConfirmLimitAt": memberConfirmLimitAt,
    "adminConfirmLimitAt": adminConfirmLimitAt,
    "createdTime": createdTime,
    "memberConfirmTime": memberConfirmTime,
    "adminConfirmTime": adminConfirmTime,
    "successTime": successTime,
    "memberConfirmLimitTime": memberConfirmLimitTime,
    "adminConfirmLimitTime": adminConfirmLimitTime,
    "status": status,
    "cancelType": cancelType,
    "cancelStep": cancelStep,
    "remark": remark,
    "operator": flashOrderInfoModelOperator,
    "blockResult": blockResult,
  };
}