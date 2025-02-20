import 'package:cgwallet/common/common.dart';

class VersionModel {
  int force;
  String iosUrl;
  String content;
  String version;
  String androidUrl;
  String h5Url;
  String apiUrl;

  VersionModel({
    this.force = -1,
    this.iosUrl = '',
    this.content = '',
    this.version = '1.0.0',
    this.androidUrl = '',
    this.h5Url = '',
    this.apiUrl = '',
  });

  factory VersionModel.fromJson(Map<String, dynamic> json) => VersionModel(
    force: json["force"] ?? -1,
    iosUrl: json["iosUrl"] ?? '',
    content: json["content"] ?? '',
    version: json["version"] ?? '1.0.0',
    androidUrl: json["androidUrl"] ?? '',
    h5Url: json["h5Url"] ?? '',
    apiUrl: json["apiUrl"] ?? '',
  );

  Map<String, dynamic> toJson() => {
    "force": force,
    "iosUrl": iosUrl,
    "content": content,
    "version": version,
    "androidUrl": androidUrl,
    "h5Url": h5Url,
    "apiUrl": apiUrl,
  };
  
  Future<void> update() async {
    await UserController.to.dio?.post<VersionModel>(ApiPath.me.getVersion,
      onSuccess: (code, msg, data) {
        force = data.force;
        iosUrl = data.iosUrl;
        content = data.content;
        version = data.version;
        androidUrl = data.androidUrl;
        h5Url = data.h5Url;
        apiUrl = data.apiUrl;
      },
      onModel: (m) => VersionModel.fromJson(m)
    );
  }
}
