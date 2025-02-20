class CustomerHistoryListModel {
  List<CustomerHistoryModel> list;

  CustomerHistoryListModel({required this.list});

  factory CustomerHistoryListModel.fromJson(Map<String, dynamic> json) => CustomerHistoryListModel(
    list: json['list']?.map((x) => CustomerHistoryModel.fromJson(x))?? []
  );


  Map<String, dynamic> toJson() {
    return {
      'list': list.map((x) => x.toJson()).toList(),
    };
  }

  factory CustomerHistoryListModel.empty() => CustomerHistoryListModel(
    list: []
  );

  CustomerHistoryModel getHistory(String cert) {
    return list.firstWhere((x) => x.cert == cert,
      orElse: () => CustomerHistoryModel.empty(),
    );
  }

  void update(CustomerHistoryModel newData) {

    for (var item in list) {
      if (item.cert == newData.cert) {
        item.token = newData.token;
        item.lastMsgId = newData.lastMsgId;
        item.newLength = newData.newLength;
        item.workerId = newData.workerId;
        item.consultId = newData.consultId;
        item.apiUrl = newData.apiUrl;
        break;
      }
    }
  }


  void reset(String cert) {
    for (var item in list) {
      if (item.cert == cert) {
        item.newLength = 0;
        break;
      }
    }
  }
}

class CustomerHistoryModel {
  String cert;
  String token;
  String lastMsgId;
  int newLength;
  int workerId;
  int consultId;
  String apiUrl;


  CustomerHistoryModel({
    required this.cert,
    required this.token,
    required this.lastMsgId,
    required this.newLength,
    required this.workerId,
    required this.consultId,
    required this.apiUrl,
  });

  factory CustomerHistoryModel.fromJson(Map<String, dynamic> json) => CustomerHistoryModel(
    cert: json['cert'] ?? '',
    token: json['token'] ?? '',
    lastMsgId: json['lastMsgId'] ?? '',
    newLength: json['newLength'] ?? 0,
    workerId: json['workerId'] ?? 0,
    consultId: json['consultId'] ?? 0,
    apiUrl: json['apiUrl'] ?? '',
  );

  factory CustomerHistoryModel.empty() => CustomerHistoryModel(
    cert: '',
    token: '',
    lastMsgId: '',
    newLength: 0,
    workerId: 0,
    consultId: 0,
    apiUrl: '',
  );

  Map<String, dynamic> toJson() => {
    'cert': cert,
    'token': token,
    'lastMsgId': lastMsgId,
    'newLength': newLength,
    'workerId': workerId,
    'consultId': consultId,
    'apiUrl': apiUrl,
  };
}