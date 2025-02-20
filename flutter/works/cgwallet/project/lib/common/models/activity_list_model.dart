import 'dart:convert';

import 'package:cgwallet/common/common.dart';

class ActivityListModel {
  List<Activity> activity;
  bool isRed;

  ActivityListModel({
    required this.activity,
    required this.isRed,
  });

  factory ActivityListModel.fromRawJson(String str) => ActivityListModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ActivityListModel.fromJson(Map<String, dynamic> json) => ActivityListModel(
    activity: json["activity"] == null ? [] : List<Activity>.from(json["activity"].map((x) => Activity.fromJson(x))),
    isRed: json["isRed"] ?? false,
  );

  factory ActivityListModel.empty() => ActivityListModel(
    activity: [],
    isRed: false,
  );

  Map<String, dynamic> toJson() => {
    "activity": List<dynamic>.from(activity.map((x) => x.toJson())),
    "isRed": isRed,
  };

  Future<void> update() async {
    await UserController.to.dio?.post<ActivityListModel>(ApiPath.activity.getActivityList, 
      onSuccess: (code, msg, results) async {
        activity = results.activity;
        bool isRedTemp = false;
        for (var item in activity) {
          if (item.activitySwitch == 1 && (item.rewardDot == 1 || item.rechargeSignDot == 1)) {
            isRedTemp = true;
            break;
          }
        }
        isRed = isRedTemp;
      },
      onModel: (m) => ActivityListModel.fromJson(m),
    );
  }
}

class Activity {
  String name;
  int rechargeSignDot;
  int rewardDot;
  int activitySwitch;
  String activityIcon;

  Activity({
    required this.name,
    required this.rechargeSignDot,
    required this.rewardDot,
    required this.activitySwitch,
    required this.activityIcon,
  });

  factory Activity.fromRawJson(String str) => Activity.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Activity.fromJson(Map<String, dynamic> json) => Activity(
    name: json["name"] ?? '',
    rechargeSignDot: json["rechargeSignDot"] ?? -1,
    rewardDot: json["rewardDot"] ?? -1,
    activitySwitch: json["switch"] ?? -1,
    activityIcon: json["activityIcon"] ?? '',
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "rechargeSignDot": rechargeSignDot,
    "rewardDot": rewardDot,
    "switch": activitySwitch,
    "activityIcon": activityIcon,
  };
}

class RedDotModel {
  // int rechargeSignDot;
  // int rewardDot;
  int versionDot;
  String content;

  RedDotModel({
    // required this.rechargeSignDot,
    // required this.rewardDot,
    required this.versionDot,
    required this.content,
  });
  factory RedDotModel.fromJson(Map<String, dynamic> json) => RedDotModel(
    // rechargeSignDot: json["rechargeSignDot"] ?? 0,
    // rewardDot: json["rewardDot"] ?? 0,
    versionDot: json["versionDot"] ?? 0,
    content: json["content"] ?? '',
  );

  factory RedDotModel.empty() => RedDotModel(
    // rechargeSignDot: 0,
    // rewardDot: 0,
    versionDot: 0,
    content: '',
  );

  Map<String, dynamic> toJson() => {
    // "rechargeSignDot": rechargeSignDot,
    // "rewardDot": rewardDot,
    "versionDot": versionDot,
    "content": content,
  };

  Future<void> update() async {
    await UserController.to.dio?.post<RedDotModel>(ApiPath.me.getVersionNoticeRedDot,
      onSuccess: (code, msg, results) {
        // rechargeSignDot = results.rechargeSignDot;
        // rewardDot = results.rewardDot;
        versionDot = results.versionDot;
        content = results.content;
      },
      onModel: (m) => RedDotModel.fromJson(m),
    );
  }
}
