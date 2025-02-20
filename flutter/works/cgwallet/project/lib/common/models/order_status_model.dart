import 'package:cgwallet/common/common.dart';

class OrderStatusListModel {
  List<OrderStatusModel> list;

  OrderStatusListModel({required this.list});

  factory OrderStatusListModel.fromJson(List<dynamic> json) => OrderStatusListModel(
    list: json.map((x) => OrderStatusModel.fromJson(x)).toList(),
  );

  factory OrderStatusListModel.empty() => OrderStatusListModel(
    list: [],
  );

  Map<String, dynamic> toJson() => {
    "list": List<dynamic>.from(list.map((x) => x.toJson())),
  };

  Future<void> update() async {
    await UserController.to.dio?.get<OrderStatusListModel>(ApiPath.market.getStatus,
      onSuccess: (code, msg, results) async {
        list = results.list;
      },
      onModel: (m) => OrderStatusListModel.fromJson(m),
    );
  }
}

class OrderStatusModel {
  int id;
  String statusName;
  int status;

  OrderStatusModel({
    required this.id,
    required this.statusName,
    required this.status,
  });

  factory OrderStatusModel.fromJson(Map<String, dynamic> json) => OrderStatusModel(
    id: json["ID"] ?? 0,
    statusName: json["statusName"] ?? '',
    status: json["status"] ?? 0,
  );

  factory OrderStatusModel.empty() => OrderStatusModel(
    id: 0,
    statusName: '',
    status: 0,
  );

  Map<String, dynamic> toJson() => {
    "ID": id,
    "statusName": statusName,
    "status": status,
  };
}
