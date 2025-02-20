import 'package:cgwallet/common/common.dart';

class OrderSettingModel {
  bool verified;
  List<int> conditionsOfUse;
  int todayTotalSell;
  int todayTotalBuy;
  int sellInterval;
  int buyInterval;
  String dailyBuyAmount;
  String dailySellAmount;
  int concurrentOrders;
  // int sellMax;
  // int sellMin;
  Map<String, dynamic> sellAmountRange;
  Map<String, dynamic> quicklyBuyAmountList;
  int sellTodayCancellations;
  int buyTodayCancellations;
  int auditMultiplier;
  int thawTime;
  int delayedSettlementTime;
  int payCountdown;
  int confirmCountdown;
  int collectCountdown;
  String sellPrecautions;
  String buyPrecautions;
  String mySellPrecautions;
  String divideDefaultMin;
  String divideDefaultMax;
  String divideAmountMin;
  String divideAmountMax;
  // String quicklyBuyCoins;

  OrderSettingModel({
    required this.verified,
    required this.conditionsOfUse,
    required this.todayTotalSell,
    required this.todayTotalBuy,
    required this.sellInterval,
    required this.buyInterval,
    required this.dailyBuyAmount,
    required this.dailySellAmount,
    required this.concurrentOrders,
    // required this.sellMax,
    // required this.sellMin,
    required this.sellTodayCancellations,
    required this.quicklyBuyAmountList,
    required this.buyTodayCancellations,
    required this.auditMultiplier,
    required this.thawTime,
    required this.delayedSettlementTime,
    required this.payCountdown,
    required this.confirmCountdown,
    required this.collectCountdown,
    required this.sellPrecautions,
    required this.buyPrecautions,
    required this.mySellPrecautions,
    required this.divideDefaultMin,
    required this.divideDefaultMax,
    required this.divideAmountMin,
    required this.divideAmountMax,
    // required this.quicklyBuyCoins,
    required this.sellAmountRange,
  });

  factory OrderSettingModel.empty() => OrderSettingModel(
    verified: false,
    conditionsOfUse: [],
    todayTotalSell: 0,
    todayTotalBuy: 0,
    sellInterval: 0,
    buyInterval: 0,
    dailyBuyAmount: '',
    dailySellAmount: '',
    concurrentOrders: 0,
    // sellMax: 0,
    // sellMin: 0,
    sellTodayCancellations: 0,
    buyTodayCancellations: 0,
    auditMultiplier: 0,
    thawTime: 0,
    delayedSettlementTime: 0,
    payCountdown: 0,
    confirmCountdown: 0,
    collectCountdown: 0,
    sellPrecautions: '',
    buyPrecautions: '',
    mySellPrecautions: '',
    divideDefaultMin: '',
    divideDefaultMax: '',
    divideAmountMin: '',
    divideAmountMax: '',
    // quicklyBuyCoins: '',
    sellAmountRange: {},
    quicklyBuyAmountList: {},
  );

  factory OrderSettingModel.fromJson(Map<String, dynamic> json) => OrderSettingModel(
    verified: json["verified"] ?? false,
    conditionsOfUse: json["conditions_of_use"] != null
      ? List<int>.from(json["conditions_of_use"].map((x) => x ?? 0))
      : [],
    todayTotalSell: json["today_total_sell"] ?? 0,
    todayTotalBuy: json["today_total_buy"] ?? 0,
    sellInterval: json["sell_interval"] ?? 0,
    buyInterval: json["buy_interval"] ?? 0,
    dailyBuyAmount: json["daily_buy_amount"] ?? '',
    dailySellAmount: json["daily_sell_amount"] ?? '',
    concurrentOrders: json["concurrent_orders"] ?? 0,
    // sellMax: json["sell_max"] ?? 0,
    // sellMin: json["sell_min"] ?? 0,
    sellTodayCancellations: json["sell_today_cancellations"] ?? 0,
    buyTodayCancellations: json["buy_today_cancellations"] ?? 0,
    auditMultiplier: json["audit_multiplier"] ?? 0,
    thawTime: json["thaw_time"] ?? 0,
    delayedSettlementTime: json["delayed_settlement_time"] ?? 0,
    payCountdown: json["pay_countdown"] ?? 0,
    confirmCountdown: json["confirm_countdown"] ?? 0,
    collectCountdown: json["collect_countdown"] ?? 0,
    sellPrecautions: json["sell_precautions"] ?? '',
    buyPrecautions: json["buy_precautions"] ?? '',
    mySellPrecautions: json["my_sell_precautions"] ?? '',
    divideDefaultMin: json["divide_default_min"] ?? '',
    divideDefaultMax: json["divide_default_max"] ?? '',
    divideAmountMin: json["divide_amount_min"] ?? '',
    divideAmountMax: json["divide_amount_max"] ?? '',
    // quicklyBuyCoins: json["quicklyBuyCoins"] ?? '',
    sellAmountRange: json["sellAmountRange"] ?? {},
    quicklyBuyAmountList: json["quicklyBuyAmountList"]?? {},
  );

  Map<String, dynamic> toJson() => {
    "verified": verified,
    "conditions_of_use": conditionsOfUse,
    "today_total_sell": todayTotalSell,
    "today_total_buy": todayTotalBuy,
    "sell_interval": sellInterval,
    "buy_interval": buyInterval,
    "daily_buy_amount": dailyBuyAmount,
    "daily_sell_amount": dailySellAmount,
    "concurrent_orders": concurrentOrders,
    // "sell_max": sellMax,
    // "sell_min": sellMin,
    "sell_today_cancellations": sellTodayCancellations,
    "buy_today_cancellations": buyTodayCancellations,
    "audit_multiplier": auditMultiplier,
    "thaw_time": thawTime,
    "delayed_settlement_time": delayedSettlementTime,
    "pay_countdown": payCountdown,
    "confirm_countdown": confirmCountdown,
    "collect_countdown": collectCountdown,
    "sell_precautions": sellPrecautions,
    "buy_precautions": buyPrecautions,
    "my_sell_precautions": mySellPrecautions,
    "divide_default_min": divideDefaultMin,
    "divide_default_max": divideDefaultMax,
    "divide_amount_min": divideAmountMin,
    "divide_amount_max": divideAmountMax,
    // "quicklyBuyCoins": quicklyBuyCoins,
    "sellAmountRange": sellAmountRange,
    "quicklyBuyAmountList": quicklyBuyAmountList,
  };

  Future<void> update() async {
    await UserController.to.dio?.post<OrderSettingModel>(ApiPath.market.getOrderSetting,
      onSuccess: (code, msg, data) {
        verified = data.verified;
        conditionsOfUse = data.conditionsOfUse;
        todayTotalSell = data.todayTotalSell;
        todayTotalBuy = data.todayTotalBuy;
        sellInterval = data.sellInterval;
        buyInterval = data.buyInterval;
        dailyBuyAmount = data.dailyBuyAmount;
        dailySellAmount = data.dailySellAmount;
        concurrentOrders = data.concurrentOrders;
        // sellMax = data.sellMax;
        // sellMin = data.sellMin;
        sellTodayCancellations = data.sellTodayCancellations;
        buyTodayCancellations = data.buyTodayCancellations;
        auditMultiplier = data.auditMultiplier;
        thawTime = data.thawTime;
        delayedSettlementTime = data.delayedSettlementTime;
        payCountdown = data.payCountdown;
        confirmCountdown = data.confirmCountdown;
        collectCountdown = data.collectCountdown;
        sellPrecautions = data.sellPrecautions;
        buyPrecautions = data.buyPrecautions;
        mySellPrecautions = data.mySellPrecautions;
        divideDefaultMin = data.divideDefaultMin;
        divideDefaultMax = data.divideDefaultMax;
        divideAmountMin = data.divideAmountMin;
        divideAmountMax = data.divideAmountMax;
        // quicklyBuyCoins = data.quicklyBuyCoins;
        sellAmountRange = data.sellAmountRange;
        quicklyBuyAmountList = data.quicklyBuyAmountList;
      },
      onModel: (m) => OrderSettingModel.fromJson(m),
    );
  }
}
