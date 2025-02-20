import 'package:cgwallet/common/common.dart';

class SwapSettingModel {
  String usdtRate;
  List<String> protocolList;
  String minAmountLimit;
  String maxAmountLimit;
  String precautions;

  SwapSettingModel({
    required this.usdtRate,
    required this.protocolList,
    required this.minAmountLimit,
    required this.maxAmountLimit,
    required this.precautions,
  });

  factory SwapSettingModel.fromJson(Map<String, dynamic> json) => SwapSettingModel(
    usdtRate: json["usdtRate"] ?? '7.2600',
    protocolList: List<String>.from(json["protocolList"] ?? []),
    minAmountLimit: json["minAmountLimit"] ?? '0.00',
    maxAmountLimit: json["maxAmountLimit"] ?? '0.00',
    precautions: json["precautions"] ?? '',
  );

  factory SwapSettingModel.empty() => SwapSettingModel(
    usdtRate: '7.2600',
    protocolList: [],
    minAmountLimit: '0.00',
    maxAmountLimit: '0.00',
    precautions: '',
  );

  Map<String, dynamic> toJson() => {
    "usdtRate": usdtRate,
    "minAmountLimit": minAmountLimit,
    "maxAmountLimit": maxAmountLimit,
    "protocolList": protocolList,
    "precautions": precautions,
  };

  Future<void> update() async {
    await UserController.to.dio?.get<SwapSettingModel>(ApiPath.swap.getSwapSetting,
      onSuccess: (code, msg, results) async {
        usdtRate = results.usdtRate;
        protocolList = results.protocolList;
        minAmountLimit = results.minAmountLimit;
        maxAmountLimit = results.maxAmountLimit;
        precautions = results.precautions;
      },
      onModel: (m) => SwapSettingModel.fromJson(m),
    );
  }
}
