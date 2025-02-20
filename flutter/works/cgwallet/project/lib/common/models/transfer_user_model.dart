import 'package:cgwallet/common/common.dart';

class TransferUserModel {
  String avatarUrl;
  int memberId;
  String? username;
  bool isOnline;
  String walletAddress;
  String nickName;

  TransferUserModel({
    required this.avatarUrl,
    required this.memberId,
    this.username,
    required this.isOnline,
    required this.walletAddress,
    required this.nickName,
  });

  Future<void> update(String address) async {
    await UserController.to.dio?.post<TransferUserModel>(ApiPath.transfer.getTransferUser,
      onSuccess: (code, msg, results) async {
        avatarUrl = results.avatarUrl;
        memberId = results.memberId;
        username = results.username;
        isOnline = results.isOnline;
        walletAddress = results.walletAddress;
        nickName = results.nickName;
      },
      data: {
        'Address': address
      },
      onModel: (m) => TransferUserModel.fromJson(m),
    );
  }

  factory TransferUserModel.fromJson(Map<String, dynamic> json) => TransferUserModel(
    walletAddress: json["walletAddress"] ?? ' ',
    avatarUrl: json["avatarUrl"] ?? '',
    memberId: json["memberId"] ?? -1,
    username: json["username"] ?? '',
    isOnline: json["isOnline"] ?? '',
    nickName: json["nickName"] ?? '',
  );

  factory TransferUserModel.empty() => TransferUserModel(
    avatarUrl: '',
    memberId: -1,
    username: 'User Name',
    isOnline: false,
    walletAddress: '000000000000000000',
    nickName: 'Nick Name',
  );
}


class TransferSettings {
  String precautions;

  TransferSettings({
    required this.precautions,
  });

  factory TransferSettings.fromJson(Map<String, dynamic> json) => TransferSettings(
    precautions: json["precautions"] ?? '',
  );

  factory TransferSettings.empty() => TransferSettings(
    precautions: '',
  );

  Map<String, dynamic> toJson() => {
    "precautions": precautions,
  };

  Future<void> update() async {
    await UserController.to.dio?.get<TransferSettings>(ApiPath.transfer.settings,
      onSuccess: (code, msg, data) {
        precautions = data.precautions;
      },
      onModel: (m) => TransferSettings.fromJson(m),
    );
  }
}
