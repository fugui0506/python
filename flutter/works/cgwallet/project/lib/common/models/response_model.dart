// 返回数据格式化
class ResponseModel {
  int code;
  dynamic data;
  String msg;

  ResponseModel({
    required this.code,
    required this.data,
    required this.msg,
  });

  factory ResponseModel.fromJson(Map<String, dynamic> json) => ResponseModel(
    code: json["code"] ?? -1,
    data: json["data"] ?? {},
    msg: json["msg"] ?? '',
  );

  factory ResponseModel.empty() => ResponseModel(
    code: -1,
    data: {},
    msg: '',
  );

  Map<String, dynamic> toJson() => {
    "code": code,
    "data": data,
    "msg": msg,
  };
}
