import 'package:cgwallet/common/common.dart';
import 'package:cgwallet/common/models/server_info_model.dart';
import 'package:dio/dio.dart';

class MyTimer {
  /// 时间格式化
  /// 把秒数转成：00:00:00的格式
  static String getDuration(int seconds) {
    // 初始化
    // 首先默认所有的时间都是 0
    String s = '';
    String m = '';
    String h = '';

    if (seconds % 60 < 10) {
      s = '0${seconds % 60}';
    } else {
      s = '${seconds % 60}';
    }

    if (seconds ~/ 60 % 60 < 10) {
      m = '0${seconds ~/ 60 % 60}';
    } else {
      m = '${seconds ~/ 60 % 60}';
    }

    if (seconds ~/ 3600 < 10) {
      h = '0${seconds ~/ 3600}';
    } else {
      h = '${seconds ~/ 3600}';
    }

    return seconds ~/ 3600 > 0 ? '$h:$m:$s' : '$m:$s';
  }

  static String getNowTime() {
    DateTime now = DateTime.now();
    return now.toString().split('.').first;
  }

  static Duration difference(int createAt) {
    final nowTimeUTC = DateTime.now().toUtc();
    final createTimeUTC = DateTime.fromMillisecondsSinceEpoch(createAt).toUtc();
    return nowTimeUTC.difference(createTimeUTC);
  }

  static bool isPassToday(int createAt) {
    final nowTimeUTC = DateTime.now().toUtc().add(const Duration(hours: 8));
    final createTimeUTC = DateTime.fromMillisecondsSinceEpoch(createAt).toUtc().add(const Duration(hours: 8));
    return nowTimeUTC.day > createTimeUTC.day;
  }

  static Future<String> getLowestLatencyUrl(List<String> urls) async {
    List<Future<UrlLatency>> futures = [];
    Dio dio = Dio();
    for (String url in urls) {
      futures.add(checkLatency(dio, url));
    }
    List<UrlLatency> results = await Future.wait(futures);
    results.sort((a, b) => a.latency.compareTo(b.latency));
    dio.close();
    return results.first.latency >= const Duration(days: 1) ? '' : results.first.url;
  }

  static Future<int> getSeconds({required String startTime, required String endTime}) async {
    DateTime start = DateTime.parse(startTime);
    showLoading();
    await UserController.to.dio?.post<ServerInfoModel>(ApiPath.me.getServerInfo,
      onSuccess: (code, msg, result) {
        start = DateTime.parse(result.time);
      },
      onModel: (m) => ServerInfoModel.fromJson(m)
    );
    hideLoading();
    DateTime end = DateTime.parse(endTime);

    int days = end.day - start.day;
    int hours = end.hour - start.hour;
    int minutes = end.minute - start.minute;
    int seconds = end.second - start.second;

    return seconds + minutes * 60 + hours * 60 * 60 + days * 60 * 60 * 24;
  }
}
