import 'package:cgwallet/common/common.dart';

class ActivitySignInModel {
  List<RechargeReward> rechargeReward;
  String depositSuccessAmount;
  String depositAmount;
  int consecutiveDays;
  String description;
  int isSign;

  ActivitySignInModel({
    required this.rechargeReward,
    required this.depositSuccessAmount,
    required this.depositAmount,
    required this.consecutiveDays,
    required this.description,
    required this.isSign,
  });

  factory ActivitySignInModel.fromJson(Map<String, dynamic> json) => ActivitySignInModel(
    rechargeReward: json["rechargeReward"] == null ? [] : List<RechargeReward>.from(json["rechargeReward"].map((x) => RechargeReward.fromJson(x))),
    depositSuccessAmount: json["depositSuccessAmount"] ?? '0',
    depositAmount: json["depositAmount"] ?? '0',
    consecutiveDays: json["consecutiveDays"] ?? 0,
    description: json["description"] ?? '',
    isSign: json["isSign"] ?? 0,
  );

  Map<String, dynamic> toJson() => {
    "rechargeReward": List<dynamic>.from(rechargeReward.map((x) => x.toJson())),
    "depositSuccessAmount": depositSuccessAmount,
    "depositAmount": depositAmount,
    "consecutiveDays": consecutiveDays,
    "description": description,
    "isSign": isSign,
  };

  factory ActivitySignInModel.empty() => ActivitySignInModel(
    rechargeReward: [],
    depositSuccessAmount: "0",
    depositAmount: "0",
    consecutiveDays: 0,
    description: "",
    isSign: 0,
  );

  Future<void> update() async {
    final path = ApiPath.activity.getActivitySignIn;
    await UserController.to.dio?.get<ActivitySignInModel>(path,
      onSuccess: (code, msg, results) async {
        rechargeReward = results.rechargeReward;
        depositSuccessAmount = results.depositSuccessAmount;
        depositAmount = results.depositAmount;
        consecutiveDays = results.consecutiveDays;
        description = results.description;
        isSign = results.isSign;
      },
      onModel: (m) => ActivitySignInModel.fromJson(m),
    );
  }
}

class RechargeReward {
  int consecutiveDays;
  String amount;
  int rewardStatus;
  int id;

  RechargeReward({
    required this.consecutiveDays,
    required this.amount,
    required this.rewardStatus,
    required this.id,
  });

  factory RechargeReward.fromJson(Map<String, dynamic> json) => RechargeReward(
    consecutiveDays: json["consecutiveDays"],
    amount: json["amount"],
    rewardStatus: json["rewardStatus"],
    id: json["id"],
  );

  factory RechargeReward.empty() => RechargeReward(
    consecutiveDays: 5,
    amount: '100',
    rewardStatus: 0,
    id: 0,
  );

  Map<String, dynamic> toJson() => {
    "consecutiveDays": consecutiveDays,
    "amount": amount,
    "rewardStatus": rewardStatus,
    "id": id,
  };
}