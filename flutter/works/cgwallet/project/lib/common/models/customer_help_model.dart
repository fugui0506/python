import 'package:cgwallet/common/common.dart';

class CustomerHelpModel {
  String title;
  String avatarUrl;
  List<CustomerQuestionModel> customerQuestions;

  CustomerHelpModel({
    required this.title,
    required this.customerQuestions,
    required this.avatarUrl,
  });

  factory CustomerHelpModel.fromJson(Map<String, dynamic> json) => CustomerHelpModel(
    title: json['title'] ?? '',
    avatarUrl: json['avatarUrl']?? '',
    customerQuestions: List<CustomerQuestionModel>.from(json["customer"]?.map((x) => CustomerQuestionModel.fromJson(x)) ?? []),
  );

  factory CustomerHelpModel.empty() => CustomerHelpModel(
    title: '',
    avatarUrl: '',
    customerQuestions: [],
  );

  Map<String, dynamic> toJson() => {
    'title': title,
    'customerQuestions': customerQuestions.map((x) => x.toJson()).toList(),
  };

  Future<void> update() async {
    final LoginCustomerConfigModel loginCustomerConfigModel = LoginCustomerConfigModel.empty();
    await loginCustomerConfigModel.update();

    title = loginCustomerConfigModel.customerServiceHelp;

    final LoginCustomerTypeListModel loginCustomerTypeListModel = LoginCustomerTypeListModel.empty();
    await loginCustomerTypeListModel.update();

    for (var x in loginCustomerTypeListModel.list) {
      final LoginCustomerListAnswer loginCustomerListAnswer = LoginCustomerListAnswer.empty();
      await loginCustomerListAnswer.update(x.id);

      List<CustomerQuestionTypeModel> customerQuestionTypeList = [];

      for (var y in loginCustomerListAnswer.list) {
        customerQuestionTypeList.add(CustomerQuestionTypeModel(
          title: y.name,
          customerAnswer: y.answer,
          createTime: MyTimer.getNowTime(),
          isClicked: false,
        ));
      }

      customerQuestions.add(CustomerQuestionModel(
        title: x.name,
        customerQuestionTypes: customerQuestionTypeList,
        createTime: MyTimer.getNowTime(),
        isClicked: false,
      ));
    }
  }
}

class CustomerQuestionModel {
  String createTime;
  String title;
  List<CustomerQuestionTypeModel> customerQuestionTypes;
  bool isClicked;

  CustomerQuestionModel({
    required this.title,
    required this.customerQuestionTypes,
    required this.createTime,
    required this.isClicked,
  });

  factory CustomerQuestionModel.fromJson(Map<String, dynamic> json) => CustomerQuestionModel(
    createTime: json['createTime']?? '',
    title: json['title'] ?? '',
    customerQuestionTypes: List<CustomerQuestionTypeModel>.from(json["customerQuestionTypes"]?.map((x) => CustomerQuestionTypeModel.fromJson(x)) ?? []),
    isClicked: json['isClicked'] ?? false,
  );

  factory CustomerQuestionModel.empty() => CustomerQuestionModel(
    createTime: '',
    title: '',
    customerQuestionTypes: [],
    isClicked: false,
  );

  Map<String, dynamic> toJson() => {
    'createTime': createTime,
    'title': title,
    'customerQuestions': customerQuestionTypes.map((x) => x.toJson()).toList(),
    'isClicked': isClicked,
  };
}

class CustomerQuestionTypeModel {
  String createTime;
  String title;
  String customerAnswer;
  bool isClicked;

  CustomerQuestionTypeModel({
    required this.createTime,
    required this.title,
    required this.customerAnswer,
    required this.isClicked,
  });

  factory CustomerQuestionTypeModel.fromJson(Map<String, dynamic> json) => CustomerQuestionTypeModel(
    createTime: json['createTime'] ?? '',
    title: json['title'] ?? '',
    customerAnswer: json['customerAnswer'] ?? '',
    isClicked: json['isClicked'] ?? false,
  );

  factory CustomerQuestionTypeModel.empty() => CustomerQuestionTypeModel(
    createTime: '',
    title: '',
    customerAnswer: '',
    isClicked: false,
  );

  Map<String, dynamic> toJson() => {
    'createTime': createTime,
    'title': title,
    'customerAnswer': customerAnswer,
    'isClicked': isClicked,
  };
}

class CustomerUserMessageModel {
  String createTime;
  String title;

  CustomerUserMessageModel({
    required this.createTime,
    required this.title,
  });

  factory CustomerUserMessageModel.fromJson(Map<String, dynamic> json) => CustomerUserMessageModel(
    title: json['title'] ?? '',
    createTime: json['createTime'] ?? '',
  );

  factory CustomerUserMessageModel.empty() => CustomerUserMessageModel(
    title: '',
    createTime: '',
  );

  Map<String, dynamic> toJson() => {
    'title': title,
    'createTime': createTime,
  };
}

class LoginCustomerConfigModel {
  int customerCategoryId;
  String customerServiceHelp;
  int disappearingTime;

  LoginCustomerConfigModel({
    required this.customerCategoryId,
    required this.customerServiceHelp,
    required this.disappearingTime,
  });

  factory LoginCustomerConfigModel.fromJson(Map<String, dynamic> json) => LoginCustomerConfigModel(
    customerCategoryId: json["customerCategoryId"] ?? -1,
    customerServiceHelp: json["customerServiceHelp"] ?? '',
    disappearingTime: json["disappearingTime"] ?? -1,
  );

  factory LoginCustomerConfigModel.empty() => LoginCustomerConfigModel(
    customerCategoryId: -1,
    customerServiceHelp: '',
    disappearingTime: -1,
  );

  Map<String, dynamic> toJson() => {
    "customerCategoryId": customerCategoryId,
    "customerServiceHelp": customerServiceHelp,
    "disappearingTime": disappearingTime,
  };

  Future<void> update() async {
    await UserController.to.dio?.post(ApiPath.me.getLoginCustomerConfig,
      onSuccess: (code, msg, data) {
        customerCategoryId = data.customerCategoryId;
        customerServiceHelp = data.customerServiceHelp;
        disappearingTime = data.disappearingTime;
      },
      onModel: (m) => LoginCustomerConfigModel.fromJson(m),
    );
  }
}

class LoginCustomerTypeListModel {
  List<LoginCustomerTypeModel> list;

  LoginCustomerTypeListModel({
    required this.list,
  });

  factory LoginCustomerTypeListModel.fromJson(List<dynamic> json) => LoginCustomerTypeListModel(
    list: json.isEmpty ? [] : List<LoginCustomerTypeModel>.from(json.map((x) => LoginCustomerTypeModel.fromJson(x))),
  );

  factory LoginCustomerTypeListModel.empty() => LoginCustomerTypeListModel(
    list: [],
  );

  Map<String, dynamic> toJson() => {
    "list": List<dynamic>.from(list.map((x) => x.toJson())),
  };

  Future<void> update() async {
    await UserController.to.dio?.post(ApiPath.me.getLoginCustomerType,
      onSuccess: (code, msg, data) {
        list = data.list;
      },
      onModel: (m) => LoginCustomerTypeListModel.fromJson(m),
    );
  }
}

class LoginCustomerTypeModel {
  int id;
  int createdAt;
  int updatedAt;
  String createdTime;
  String updatedTime;
  String name;
  int sort;

  LoginCustomerTypeModel({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.createdTime,
    required this.updatedTime,
    required this.name,
    required this.sort,
  });

  factory LoginCustomerTypeModel.fromJson(Map<String, dynamic> json) => LoginCustomerTypeModel(
    id: json["ID"] ?? -1,
    createdAt: json["createdAt"] ?? -1,
    updatedAt: json["updatedAt"] ?? -1,
    createdTime: json["createdTime"] ?? '',
    updatedTime: json["updatedTime"] ?? '',
    name: json["name"] ?? '',
    sort: json["sort"] ?? -1,
  );

  factory LoginCustomerTypeModel.empty() => LoginCustomerTypeModel(
    id: -1,
    createdAt: -1,
    updatedAt: -1,
    createdTime: '',
    updatedTime: '',
    name: '',
    sort: -1,
  );

  Map<String, dynamic> toJson() => {
    "ID": id,
    "createdAt": createdAt,
    "updatedAt": updatedAt,
    "createdTime": createdTime,
    "updatedTime": updatedTime,
    "name": name,
    "sort": sort,
  };
}

class LoginCustomerListAnswer {
  List<LoginCustomerAnswer> list;

  LoginCustomerListAnswer({
    required this.list,
  });

  factory LoginCustomerListAnswer.fromJson(List<dynamic> json) => LoginCustomerListAnswer(
    list: json.isEmpty ? [] : List<LoginCustomerAnswer>.from(json.map((x) => LoginCustomerAnswer.fromJson(x))),
  );

  factory LoginCustomerListAnswer.empty() => LoginCustomerListAnswer(
    list: [],
  );

  Future<void> update(int id) async {
    await UserController.to.dio?.get('${ApiPath.me.getLoginCustomerAnswer}/$id',
      onSuccess: (code, msg, data) {
        list = data.list;
      },
      onModel: (m) => LoginCustomerListAnswer.fromJson(m),
    );
  }

  Map<String, dynamic> toJson() => {
    "list": List<dynamic>.from(list.map((x) => x.toJson())),
  };
}

class LoginCustomerAnswer {
  int id;
  int createdAt;
  int updatedAt;
  String createdTime;
  String updatedTime;
  int loginCustomerServiceCategoryId;
  String name;
  String answer;
  int sort;

  LoginCustomerAnswer({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.createdTime,
    required this.updatedTime,
    required this.loginCustomerServiceCategoryId,
    required this.name,
    required this.answer,
    required this.sort,
  });

  factory LoginCustomerAnswer.fromJson(Map<String, dynamic> json) => LoginCustomerAnswer(
    id: json["ID"] ?? -1,
    createdAt: json["createdAt"] ?? -1,
    updatedAt: json["updatedAt"] ?? -1,
    createdTime: json["createdTime"] ?? '',
    updatedTime: json["updatedTime"] ?? '',
    loginCustomerServiceCategoryId: json["login_customer_service_category_id"] ?? -1,
    name: json["Name"] ?? '',
    answer: json["Answer"] ?? '',
    sort: json["sort"] ?? -1,
  );

  factory LoginCustomerAnswer.empty() => LoginCustomerAnswer(
    id: -1,
    createdAt: -1,
    updatedAt: -1,
    createdTime: '',
    updatedTime: '',
    loginCustomerServiceCategoryId: -1,
    name: '',
    answer: '',
    sort: -1,
  );

  Map<String, dynamic> toJson() => {
    "ID": id,
    "createdAt": createdAt,
    "updatedAt": updatedAt,
    "createdTime": createdTime,
    "updatedTime": updatedTime,
    "login_customer_service_category_id": loginCustomerServiceCategoryId,
    "Name": name,
    "Answer": answer,
    "sort": sort,
  };
}
