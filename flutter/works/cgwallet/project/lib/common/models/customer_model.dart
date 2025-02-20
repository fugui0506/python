import 'package:cgwallet/common/common.dart';

class CustomerModel {
  int chatId;
  String chatUrl;
  int status;
  String urlImg;
  String urlApi;
  String sign;
  List<Customer> customer;

  CustomerModel({
    required this.chatId,
    required this.chatUrl,
    required this.status,
    required this.urlImg,
    required this.urlApi,
    required this.customer,
    required this.sign,
  });

  factory CustomerModel.fromJson(Map<String, dynamic> json) => CustomerModel(
    chatId: json["chatId"] ?? 0,
    chatUrl: json["chatUrl"] ?? '',
    status: json["status"] ?? -1,
    urlImg: json["urlImg"] ?? '',
    urlApi: json["urlApi"] ?? '',
    sign: json["sign"] ?? 'qianbao',
    customer: List<Customer>.from(json["customer"]?.map((x) => Customer.fromJson(x)) ?? []),
  );

  factory CustomerModel.empty() => CustomerModel(
    chatUrl: '',
    status: -1,
    urlImg: '',
    urlApi: '',
    customer: [],
    chatId: 0,
    sign: '',
  );

  Map<String, dynamic> toJson() => {
    "chatUrl": chatUrl,
    "status": status,
    "urlImg": urlImg,
    "urlApi": urlApi,
    "customer": List<dynamic>.from(customer.map((x) => x.toJson())),
    "chatId": chatId,
    "sign": sign,
  };

  Future<void> update({required List<int> typeName}) async {
    await UserController.to.dio?.post<CustomerModel>(ApiPath.me.getCustomer,
      onSuccess: (code, msg, results) async {
        chatUrl = results.chatUrl;
        status = results.status;
        urlImg = results.urlImg;
        urlApi = results.urlApi;
        customer = results.customer;
        chatId = results.chatId;
        sign = results.sign;
      },
      data: {
        "typeName": typeName,
      },
      onModel: (m) => CustomerModel.fromJson(m),
    );
  }
}
class Customer {
  int customerServiceType;
  String cret;
  String remark;
  String customerServiceAvatar;

  Customer({
    required this.customerServiceType,
    required this.cret,
    required this.remark,
    required this.customerServiceAvatar,
  });

  factory Customer.fromJson(Map<String, dynamic> json) => Customer(
    customerServiceType: json["customerServiceType"] ?? 0,
    cret: json["cret"] ?? '',
    remark: json["remark"] ?? '',
    customerServiceAvatar: json["customerServiceAvatar"] ?? '',
  );

  Map<String, dynamic> toJson() => {
    "customerServiceType": customerServiceType,
    "cret": cret,
    "remark": remark,
    "customerServiceAvatar": customerServiceAvatar,
  };
}
