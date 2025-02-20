class ServerInfoModel {
  String timeZone;
  int timestamp;
  String time;
  int offset;

  ServerInfoModel({
    required this.timeZone,
    required this.timestamp,
    required this.time,
    required this.offset,
  });

  factory ServerInfoModel.fromJson(Map<String, dynamic> json) => ServerInfoModel(
    timeZone: json["timeZone"] ?? '',
    timestamp: json["timestamp"] ?? '',
    time: json["time"] ?? '',
    offset: json["offset"] ?? '',
  );

  Map<String, dynamic> toJson() => {
    "timeZone": timeZone,
    "timestamp": timestamp,
    "time": time,
    "offset": offset,
  };
}