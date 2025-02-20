import 'package:cgwallet/common/common.dart';

class FeedbackRemarkModel {
  String? remark;

  FeedbackRemarkModel({
    this.remark,
  });

  factory FeedbackRemarkModel.fromJson(Map<String, dynamic> json) => FeedbackRemarkModel(
    remark: json["remark"],
  );

  Map<String, dynamic> toJson() => {
    "remark": remark,
  };

  Future<void> update() async {
    await UserController.to.dio?.post<FeedbackRemarkModel>(ApiPath.me.getFeedback,
      onSuccess: (code, msg, results) async {
        remark = results.remark;
      },
      onModel: (m) => FeedbackRemarkModel.fromJson(m),
    );
  }
}