import 'package:cgwallet/common/common.dart';

class UserInfoModel {
  User user;
  String token;
  int? expiresAt;
  String balance;
  String frozenBalance;
  String lockBalance;
  String buyRate;
  String walletAddress;
  int createAt;

  UserInfoModel({
    required this.user,
    required this.token,
    this.expiresAt,
    required this.balance,
    required this.frozenBalance,
    required this.lockBalance,
    required this.buyRate,
    required this.walletAddress,
    required this.createAt,
  });

  factory UserInfoModel.fromJson(Map<String, dynamic> json) => UserInfoModel(
    user: json["user"] != null ? User.fromJson(json["user"]) : User.empty(),
    token: json["token"] ?? '',
    expiresAt: json["expiresAt"],
    balance: json["balance"] ?? '0.00',
    frozenBalance: json["frozenBalance"] ?? '0.00',
    lockBalance: json["lockBalance"] ?? '0.00',
    buyRate: json["buyRate"] ?? '0.00%',
    walletAddress: json["walletAddress"] ?? '0000000000000000',
    createAt: json["createAt"] ?? 0,
  );

  factory UserInfoModel.empty() => UserInfoModel(
    user: User.empty(),
    token: '',
    expiresAt: -1,
    balance: '0.00',
    frozenBalance: '0.00',
    lockBalance: '0.00',
    buyRate: '0.00%',
    walletAddress: '0000000000000000',
    createAt: 0,
  );

  Map<String, dynamic> toJson() => {
    "user": user.toJson(),
    "token": token,
    "expiresAt": expiresAt,
    "balance": balance,
    "frozenBalance": frozenBalance,
    "lockBalance": lockBalance,
    "buyRate": buyRate,
    "walletAddress": walletAddress,
    "createAt": createAt,
  };

  Future<void> update() async {
    await UserController.to.dio?.post<UserInfoModel>(ApiPath.base.getUserInfo,
      onSuccess: (code, msg, results) async {
        balance = results.balance;
        lockBalance = results.lockBalance;
        frozenBalance = results.frozenBalance;
        user.id = results.user.id;
        user.username = results.user.username;
        user.phone = results.user.phone;
        user.realName = results.user.realName;
        user.nickName = results.user.nickName;
        user.avatarUrl = results.user.avatarUrl;
        user.enable = results.user.enable;
        user.isAuth = results.user.isAuth;
        // user.lastTime = results.user.lastTime;
        // user.lastAt = results.user.lastAt;
        // user.lastIp = results.user.lastIp;
        user.totalBuyOrder = results.user.totalBuyOrder;
        user.totalSaleOrder = results.user.totalSaleOrder;
        user.totalSwap = results.user.totalSwap;
        user.enableTransfer = results.user.enableTransfer;
        user.identityId = results.user.identityId;
        user.identityFront = results.user.identityFront;
        user.identityBack = results.user.identityBack;
        user.registerDeviceNo = results.user.registerDeviceNo;
        user.loginDeviceNo = results.user.loginDeviceNo;
        user.riskMessage = results.user.riskMessage;
        buyRate = results.buyRate;
        expiresAt = results.expiresAt;
        walletAddress = results.walletAddress;
      },
      onModel: (m) => UserInfoModel.fromJson(m),
    );
  }
}

class User {
  int id;
  String username;
  String phone;
  String realName;
  String nickName;
  String avatarUrl;
  int enable;
  int isAuth;
  int lastTime;
  String lastAt;
  String lastIp;
  String totalBuyOrder;
  String totalSaleOrder;
  String totalSwap;
  int enableTransfer;
  String identityId;
  String identityFront;
  String identityBack;
  String registerDeviceNo;
  String loginDeviceNo;
  String riskMessage;

  User({
    this.id = -1,
    this.username = '',
    this.phone = '',
    this.realName = '',
    this.nickName = 'NICKNAME',
    this.avatarUrl = '',
    this.enable = -1,
    this.isAuth = -1,
    this.lastTime = -1,
    this.lastAt = '',
    this.lastIp = '',
    this.totalBuyOrder = '',
    this.totalSaleOrder = '',
    this.totalSwap = '',
    this.enableTransfer = -1,
    this.identityId = '',
    this.identityFront = '',
    this.identityBack = '',
    this.registerDeviceNo = '',
    this.loginDeviceNo = '',
    this.riskMessage = '',
  });

  factory User.empty() => User(
    enable: -1,
    enableTransfer: -1,
    isAuth: -1,
    lastTime: -1,
    lastIp: '',
    totalBuyOrder: '',
    totalSaleOrder: '',
    totalSwap: '',
    username: '',
    phone: '',
    realName: '',
    nickName: 'NICKNAME',
    avatarUrl: '',
    identityId: '',
    identityFront: '',
    identityBack: '',
    registerDeviceNo: '',
    loginDeviceNo: '',
    riskMessage: '',
    id: -1,
    lastAt: '',
  );

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json["ID"] ?? -1,
    username: json["username"] ?? '',
    phone: json["phone"] ?? '',
    realName: json["realName"] ?? '',
    nickName: json["nickName"] ?? 'NICKNAME',
    avatarUrl: json["avatarUrl"] ?? '',
    enable: json["enable"] ?? -1,
    isAuth: json["isAuth"] ?? -1,
    lastTime: json["lastTime"] ?? -1,
    lastAt: json["lastAt"] ?? '',
    lastIp: json["lastIP"] ?? '',
    totalBuyOrder: json["totalBuyOrder"] ?? '',
    totalSaleOrder: json["totalSaleOrder"] ?? '',
    totalSwap: json["totalSwap"] ?? '',
    enableTransfer: json["enableTransfer"] ?? -1,
    identityId: json["identityId"] ?? '',
    identityFront: json["identityFront"] ?? '',
    identityBack: json["identityBack"] ?? '',
    registerDeviceNo: json["registerDeviceNo"] ?? '',
    loginDeviceNo: json["loginDeviceNo"] ?? '',
    riskMessage: json["riskMessage"] ?? '',
  );

  Map<String, dynamic> toJson() => {
    "ID": id,
    "username": username,
    "phone": phone,
    "realName": realName,
    "nickName": nickName,
    "avatarUrl": avatarUrl,
    "enable": enable,
    "isAuth": isAuth,
    "lastTime": lastTime,
    "lastAt": lastAt,
    "lastIP": lastIp,
    "totalBuyOrder": totalBuyOrder,
    "totalSaleOrder": totalSaleOrder,
    "totalSwap": totalSwap,
    "enableTransfer": enableTransfer,
    "identityId": identityId,
    "identityFront": identityFront,
    "identityBack": identityBack,
    "registerDeviceNo": registerDeviceNo,
    "loginDeviceNo": loginDeviceNo,
    "riskMessage": riskMessage,
  };
}

class AvatarModel {
  int id;
  String avatarUrl;

  AvatarModel({
    required this.id,
    required this.avatarUrl,
  });

  factory AvatarModel.fromJson(Map<String, dynamic> json) => AvatarModel(
    id: json['id'] ?? -1,
    avatarUrl: json['avatar_url'] ?? '',
  );

  factory AvatarModel.empty() => AvatarModel(id: -1, avatarUrl: '');
}
