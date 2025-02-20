import 'dart:io';

import 'package:cgwallet/common/common.dart';

class QueryEntranceModel {
  String name;
  String nick;
  String avatar;
  String guide;
  int defaultConsultId;
  String changeDefaultTime;
  List<Consult> consults;

  QueryEntranceModel({
    required this.name,
    required this.nick,
    required this.avatar,
    required this.guide,
    required this.defaultConsultId,
    required this.changeDefaultTime,
    required this.consults,
  });

  factory QueryEntranceModel.fromJson(Map<String, dynamic> json) => QueryEntranceModel(
    name: json["name"] ?? '',
    nick: json["nick"] ?? '',
    avatar: json["avatar"] ?? '',
    guide: json["guide"] ?? '',
    defaultConsultId: json["defaultConsultId"] ?? 0,
    changeDefaultTime: json["changeDefaultTime"] ?? '',
    consults: json["consults"] == null ? [] : List<Consult>.from(json["consults"]!.map((x) => Consult.fromJson(x))),
  );

  factory QueryEntranceModel.empty() => QueryEntranceModel(
    name: '',
    nick: '',
    avatar: '',
    guide: '',
    defaultConsultId: 0,
    changeDefaultTime: '',
    consults: [],
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "nick": nick,
    "avatar": avatar,
    "guide": guide,
    "defaultConsultId": defaultConsultId,
    "changeDefaultTime": changeDefaultTime,
    "consults": List<dynamic>.from(consults.map((x) => x.toJson())),
  };

  Future<void> update(MyDio? myDio) async {
    await myDio?.post<QueryEntranceModel>(ApiPath.qichat.queryEntrance,
      onSuccess: (code, msg, data) {
        name = data.name;
        nick = data.nick;
        avatar = data.avatar;
        guide = data.guide;
        defaultConsultId = data.defaultConsultId;
        changeDefaultTime = data.changeDefaultTime;
        consults = data.consults;
      },
      onModel: (m) => QueryEntranceModel.fromJson(m)
    );
  }
}

class Consult {
  int consultId;
  String name;
  String guide;
  List<Work> works;
  int unread;
  int priority;

  Consult({
    required this.consultId,
    required this.name,
    required this.guide,
    required this.works,
    required this.unread,
    required this.priority,
  });

  factory Consult.fromJson(Map<String, dynamic> json) => Consult(
    consultId: json["consultId"] ?? 0,
    name: json["name"] ?? '',
    guide: json["guide"] ?? '',
    works: json["Works"] == null ? [] : List<Work>.from(json["Works"]!.map((x) => Work.fromJson(x))),
    unread: json["unread"] ?? 0,
    priority: json["priority"] ?? 0,
  );

  Map<String, dynamic> toJson() => {
    "consultId": consultId,
    "name": name,
    "guide": guide,
    "Works": List<dynamic>.from(works.map((x) => x.toJson())),
    "unread": unread,
    "priority": priority,
  };
}

class Work {
  String nick;
  String avatar;
  int workerId;
  String nimId;
  String connectState;
  String onlineState;

  Work({
    required this.nick,
    required this.avatar,
    required this.workerId,
    required this.nimId,
    required this.connectState,
    required this.onlineState,
  });

  factory Work.fromJson(Map<String, dynamic> json) => Work(
    nick: json["nick"] ?? '',
    avatar: json["avatar"] ?? '',
    workerId: json["workerId"] ?? 0,
    nimId: json["nimId"] ?? '',
    connectState: json["connectState"] ?? '',
    onlineState: json["onlineState"] ?? '',
  );

  Map<String, dynamic> toJson() => {
    "nick": nick,
    "avatar": avatar,
    "workerId": workerId,
    "nimId": nimId,
    "connectState": connectState,
    "onlineState": onlineState,
  };
}

class AssignWorkerModel {
  String nick;
  String avatar;
  int workerId;
  String nimid;
  String tips;
  String chatId;

  AssignWorkerModel({
    required this.nick,
    required this.avatar,
    required this.workerId,
    required this.nimid,
    required this.tips,
    required this.chatId,
  });

  factory AssignWorkerModel.fromJson(Map<String, dynamic> json) => AssignWorkerModel(
    nick: json["nick"] ?? '',
    avatar: json["avatar"] ?? '',
    workerId: json["workerId"] ?? 0,
    nimid: json["nimid"] ?? '',
    tips: json["tips"] ?? '',
    chatId: json["chatId"] ?? '',
  );

  factory AssignWorkerModel.empty() => AssignWorkerModel(
    nick: '',
    avatar: '',
    workerId: 0,
    nimid: '',
    tips: '',
    chatId: '',
  );

  Map<String, dynamic> toJson() => {
    "nick": nick,
    "avatar": avatar,
    "workerId": workerId,
    "nimid": nimid,
    "tips": tips,
    "chatId": chatId,
  };

  Future<void> update(MyDio? myDio, Map<String, dynamic> data) async {
    await myDio?.post<AssignWorkerModel>(ApiPath.qichat.assignWorker,
      onSuccess: (code, msg, data) {
        nick = data.nick;
        avatar = data.avatar;
        workerId = data.workerId;
        nimid = data.nimid;
        tips = data.tips;
        chatId = data.chatId;
      },
      data: data,
      onModel: (m) => AssignWorkerModel.fromJson(m),
    );
  }
}

class AutoReplyModel {
  AutoReplyItemModel autoReplyItem;
  String createTime;

  AutoReplyModel({
    required this.autoReplyItem,
    required this.createTime,
  });

  factory AutoReplyModel.fromJson(Map<String, dynamic> json) => AutoReplyModel(
    autoReplyItem: json["autoReplyItem"] == null ? AutoReplyItemModel.empty() : AutoReplyItemModel.fromJson(json["autoReplyItem"]),
    createTime: json["createTime"] ?? '',
  );

  factory AutoReplyModel.empty() => AutoReplyModel(
    autoReplyItem: AutoReplyItemModel.empty(),
    createTime: '',
  );

  Future<void> update(MyDio? myDio, Map<String, dynamic> data) async {
    await myDio?.post<AutoReplyModel>(ApiPath.qichat.queryAutoReply,
      onSuccess: (code, msg, data) {
        autoReplyItem = data.autoReplyItem;
        createTime = MyTimer.getNowTime();
      },
      data: data,
      onModel: (m) => AutoReplyModel.fromJson(m),
    );
  }
}

class AutoReplyItemModel {
  String id;
  String name;
  String title;
  List<Qa> qa;
  List<int> workerId;
  List<String> workerNames;

  AutoReplyItemModel({
    required this.id,
    required this.name,
    required this.title,
    required this.qa,
    required this.workerId,
    required this.workerNames,
  });

  factory AutoReplyItemModel.empty() => AutoReplyItemModel(
    id: '',
    name: '',
    title: '',
    qa: [],
    workerId: [],
    workerNames: [],
  );

  factory AutoReplyItemModel.fromJson(Map<String, dynamic> json) => AutoReplyItemModel(
    id: json["id"] ?? '',
    name: json["name"] ?? '',
    title: json["title"] ?? '',
    qa: json["qa"] == null ? [] : List<Qa>.from(json["qa"]!.map((x) => Qa.fromJson(x))),
    workerId: json["workerId"] == null ? [] : List<int>.from(json["workerId"]!.map((x) => x)),
    workerNames: json["workerNames"] == null ? [] : List<String>.from(json["workerNames"]!.map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "title": title,
    "qa": List<dynamic>.from(qa.map((x) => x.toJson())),
    "workerId": List<dynamic>.from(workerId.map((x) => x)),
    "workerNames": List<dynamic>.from(workerNames.map((x) => x)),
  };
}

class Qa {
  int id;
  Question question;
  String content;
  List<Question> answer;
  List<Qa> related;

  Qa({
    required this.id,
    required this.question,
    required this.content,
    required this.answer,
    required this.related,
  });

  factory Qa.fromJson(Map<String, dynamic> json) => Qa(
    id: json["id"] ?? 0,
    question: json["question"] == null ? Question.empty() : Question.fromJson(json["question"]),
    content: json["content"] ?? '',
    answer: json["answer"] == null ? [] : List<Question>.from(json["answer"]!.map((x) => Question.fromJson(x))),
    related: json["related"] == null ? [] : List<Qa>.from(json["related"]!.map((x) => Qa.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "question": question.toJson(),
    "content": content,
    "answer": List<dynamic>.from(answer.map((x) => x.toJson())),
    "related": List<dynamic>.from(related.map((x) => x.toJson())),
  };
}
class Question {
  String chatId;
  String msgId;
  String msgTime;
  String sender;
  String replyMsgId;
  String msgOp;
  int worker;
  String autoReplyFlag;
  String msgFmt;
  String consultId;
  List<dynamic> withAutoReplies;
  String msgSourceType;
  String payloadId;
  Content content;
  ImageUrl image;

  Question({
    required this.chatId,
    required this.msgId,
    required this.msgTime,
    required this.sender,
    required this.replyMsgId,
    required this.msgOp,
    required this.worker,
    required this.autoReplyFlag,
    required this.msgFmt,
    required this.consultId,
    required this.withAutoReplies,
    required this.msgSourceType,
    required this.payloadId,
    required this.content,
    required this.image,
  });

  factory Question.fromJson(Map<String, dynamic> json) => Question(
    chatId: json["chatId"] ?? '',
    msgId: json["msgId"] ?? '',
    msgTime: json["msgTime"] ?? '',
    sender: json["sender"] ?? '',
    replyMsgId: json["replyMsgId"] ?? '',
    msgOp: json["msgOp"] ?? '',
    worker: json["worker"] ?? 0,
    autoReplyFlag: json["autoReplyFlag"] ?? '',
    msgFmt: json["msgFmt"] ?? '',
    consultId: json["consultId"] ?? '',
    withAutoReplies: json["withAutoReplies"] == null ? [] : List<dynamic>.from(json["withAutoReplies"]!.map((x) => x)),
    msgSourceType: json["msgSourceType"] ?? '',
    payloadId: json["payloadId"] ?? '',
    content: json["content"] == null ? Content.empty() : Content.fromJson(json["content"]),
    image: json["image"] == null ? ImageUrl.empty() : ImageUrl.fromJson(json["image"]),
  );

  factory Question.empty() => Question(
    chatId: '',
    msgId: '',
    msgTime: '',
    sender: '',
    replyMsgId: '',
    msgOp: '',
    worker: 0,
    autoReplyFlag: '',
    msgFmt: '',
    consultId: '',
    withAutoReplies: [],
    msgSourceType: '',
    payloadId: '',
    content: Content.empty(),
    image: ImageUrl.empty(),
  );

  Map<String, dynamic> toJson() => {
    "chatId": chatId,
    "msgId": msgId,
    "msgTime": msgTime,
    "sender": sender,
    "replyMsgId": replyMsgId,
    "msgOp": msgOp,
    "worker": worker,
    "autoReplyFlag": autoReplyFlag,
    "msgFmt": msgFmt,
    "consultId": consultId,
    "withAutoReplies": List<dynamic>.from(withAutoReplies.map((x) => x)),
    "msgSourceType": msgSourceType,
    "payloadId": payloadId,
    "content": content.toJson(),
    "image": image.toJson(),
  };
}

class Content {
  String data;

  Content({
    required this.data,
  });

  factory Content.fromJson(Map<String, dynamic> json) => Content(
    data: json["data"] ?? '',
  );

  factory Content.empty() => Content(
    data: '',
  );

  Map<String, dynamic> toJson() => {
    "data": data,
  };
}


class ImageUrl {
  String uri;

  ImageUrl({
    required this.uri,
  });

  factory ImageUrl.fromJson(Map<String, dynamic> json) => ImageUrl(
    uri: json["uri"] ?? '',
  );

  Map<String, dynamic> toJson() => {
    "uri": uri,
  };

  factory ImageUrl.empty() => ImageUrl(
    uri: '',
  );
}

class QichatHistory {
  Request request;
  List<QichatInfoModel> list;
  String lastMsgId;
  String nick;
  List<QichatInfoModel> replyList;

  QichatHistory({
    required this.request,
    required this.list,
    required this.lastMsgId,
    required this.nick,
    required this.replyList,
  });

  factory QichatHistory.fromJson(Map<String, dynamic> json) => QichatHistory(
    request: Request.fromJson(json["request"] ?? {}),
    list: json["list"] == null ? [] : List<QichatInfoModel>.from(json["list"].map((x) => QichatInfoModel.fromJson(x))),
    lastMsgId: json["lastMsgId"] ?? '',
    nick: json["nick"] ?? '',
    replyList: json["replyList"] == null ? [] : List<QichatInfoModel>.from(json["replyList"].map((x) => QichatInfoModel.fromJson(x))),
  );

  factory QichatHistory.empty() => QichatHistory(
    request: Request.empty(),
    list: [],
    lastMsgId: '',
    nick: '',
    replyList: [],
  );

  Map<String, dynamic> toJson() => {
    "request": request.toJson(),
    "list": List<dynamic>.from(list.map((x) => x.toJson())),
    "lastMsgId": lastMsgId,
    "nick": nick,
    "replyList": List<dynamic>.from(replyList.map((x) => x.toJson())),
  };

  Future<void> update(MyDio? myDio, Map<String, dynamic> data) async {
    await myDio?.post<QichatHistory>(ApiPath.qichat.messageHistory,
      onSuccess: (code, msg, data) {
        request = data.request;
        list = data.list;
        lastMsgId = data.lastMsgId;
        nick = data.nick;
        replyList = data.replyList;
      },
      data: data,
      onModel: (m) => QichatHistory.fromJson(m),
    );
  }
}

class QichatInfoModel {
  String chatId;
  String msgId;
  String msgTime;
  String sender;
  String replyMsgId;
  String msgOp;
  int worker;
  AutoReplyFlag autoReplyFlag;
  String msgFmt;
  String consultId;
  List<WithAutoReply> withAutoReplies;
  String msgSourceType;
  String payloadId;
  Content content;
  Media image;
  Media audio;
  Media video;
  Geo geo;
  FileClass file;
  WorkerTrans workerTrans;
  Blacklist blacklistApply;
  Blacklist blacklistConfirm;
  AutoReply autoReply;
  WorkerChanged workerChanged;

  QichatInfoModel({
    required this.chatId,
    required this.msgId,
    required this.msgTime,
    required this.sender,
    required this.replyMsgId,
    required this.msgOp,
    required this.worker,
    required this.autoReplyFlag,
    required this.msgFmt,
    required this.consultId,
    required this.withAutoReplies,
    required this.msgSourceType,
    required this.payloadId,
    required this.content,
    required this.image,
    required this.audio,
    required this.video,
    required this.geo,
    required this.file,
    required this.workerTrans,
    required this.blacklistApply,
    required this.blacklistConfirm,
    required this.autoReply,
    required this.workerChanged,
  });

  factory QichatInfoModel.fromJson(Map<String, dynamic> json) => QichatInfoModel(
    chatId: json["chatId"] ?? '',
    msgId: json["msgId"] ?? '',
    msgTime: json["msgTime"] ?? '',
    sender: json["sender"] ?? '',
    replyMsgId: json["replyMsgId"] ?? '',
    msgOp: json["msgOp"] ?? '',
    worker: json["worker"] ?? 0,
    autoReplyFlag: json["autoReplyFlag"] == null 
        ? AutoReplyFlag.empty() 
        : AutoReplyFlag.fromJson(json["autoReplyFlag"]),
    msgFmt: json["msgFmt"] ?? '',
    consultId: json["consultId"] ?? '',
    withAutoReplies: json["withAutoReplies"] == null
        ? []
        : List<WithAutoReply>.from(json["withAutoReplies"].map((x) => WithAutoReply.fromJson(x))),
    msgSourceType: json["msgSourceType"] ?? '',
    payloadId: json["payloadId"] ?? '',
    content: json["content"] == null ? Content.empty() : Content.fromJson(json["content"]),
    image: json["image"] == null ? Media.empty() : Media.fromJson(json["image"]),
    audio: json["audio"] == null ? Media.empty() : Media.fromJson(json["audio"]),
    video: json["video"] == null ? Media.empty() : Media.fromJson(json["video"]),
    geo: json["geo"] == null ? Geo.empty() : Geo.fromJson(json["geo"]),
    file: json["file"] == null ? FileClass.empty() : FileClass.fromJson(json["file"]),
    workerTrans: json["workerTrans"] == null ? WorkerTrans.empty() : WorkerTrans.fromJson(json["workerTrans"]),
    blacklistApply: json["blacklistApply"] == null ? Blacklist.empty() : Blacklist.fromJson(json["blacklistApply"]),
    blacklistConfirm: json["blacklistConfirm"] == null ? Blacklist.empty() : Blacklist.fromJson(json["blacklistConfirm"]),
    autoReply: json["autoReply"] == null ? AutoReply.empty() : AutoReply.fromJson(json["autoReply"]),
    workerChanged: json["workerChanged"] == null ? WorkerChanged.empty() : WorkerChanged.fromJson(json["workerChanged"]),
  );

  Map<String, dynamic> toJson() => {
    "chatId": chatId,
    "msgId": msgId,
    "msgTime": msgTime,
    "sender": sender,
    "replyMsgId": replyMsgId,
    "msgOp": msgOp,
    "worker": worker,
    "autoReplyFlag": autoReplyFlag.toJson(),
    "msgFmt": msgFmt,
    "consultId": consultId,
    "withAutoReplies": List<dynamic>.from(withAutoReplies.map((x) => x.toJson())),
    "msgSourceType": msgSourceType,
    "payloadId": payloadId,
    "content": content.toJson(),
    "image": image.toJson(),
    "audio": audio.toJson(),
    "video": video.toJson(),
    "geo": geo.toJson(),
    "file": file.toJson(),
    "workerTrans": workerTrans.toJson(),
    "blacklistApply": blacklistApply.toJson(),
    "blacklistConfirm": blacklistConfirm.toJson(),
    "autoReply": autoReply.toJson(),
    "workerChanged": workerChanged.toJson(),
  };
}

class Media {
  String uri;

  Media({
    required this.uri,
  });

  factory Media.fromJson(Map<String, dynamic> json) => Media(
        uri: json["uri"] ?? '',
      );

  Map<String, dynamic> toJson() => {
        "uri": uri,
      };

  factory Media.empty() => Media(uri: '');
}

class AutoReply {
  String id;
  String title;
  int delaySec;
  List<Qa> qa;

  AutoReply({
    required this.id,
    required this.title,
    required this.delaySec,
    required this.qa,
  });

  factory AutoReply.fromJson(Map<String, dynamic> json) => AutoReply(
    id: json["id"] ?? '',
    title: json["title"] ?? '',
    delaySec: json["delaySec"] ?? 0,
    qa: json["qa"] == null
        ? [] 
        : List<Qa>.from(json["qa"].map((x) => Qa.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "delaySec": delaySec,
    "qa": List<dynamic>.from(qa.map((x) => x.toJson())),
  };

  factory AutoReply.empty() => AutoReply(
    id: '',
    title: '',
    delaySec: 0,
    qa: [], 
  ); 
}

class Answer {
  Content content;
  Media image;
  Media audio;
  Media video;
  Geo geo;
  FileClass file;

  Answer({
    required this.content,
    required this.image,
    required this.audio,
    required this.video,
    required this.geo,
    required this.file,
  });

  factory Answer.fromJson(Map<String, dynamic> json) => Answer(
        content: json["content"] == null ? Content.empty() : Content.fromJson(json["content"]),
        image: json["image"] == null ? Media.empty() : Media.fromJson(json["image"]),
        audio: json["audio"] == null ? Media.empty() : Media.fromJson(json["audio"]),
        video: json["video"] == null ? Media.empty() : Media.fromJson(json["video"]),
        geo: json["geo"] == null ? Geo.empty() : Geo.fromJson(json["geo"]),
        file: json["file"] == null ? FileClass.empty() : FileClass.fromJson(json["file"]),
      );

  Map<String, dynamic> toJson() => {
        "content": content.toJson(),
        "image": image.toJson(),
        "audio": audio.toJson(),
        "video": video.toJson(),
        "geo": geo.toJson(),
        "file": file.toJson(),
      };

  factory Answer.empty() => Answer(
        content: Content.empty(),
        image: Media.empty(),
        audio: Media.empty(),
        video: Media.empty(),
        geo: Geo.empty(),
        file: FileClass.empty(),
      );
}

class FileClass {
  String uri;
  String fileName;
  int size;

  FileClass({
    required this.uri,
    required this.fileName,
    required this.size,
  });

  factory FileClass.fromJson(Map<String, dynamic> json) => FileClass(
        uri: json["uri"] ?? '',
        fileName: json["fileName"] ?? '',
        size: json["size"] ?? 0,
      );

  Map<String, dynamic> toJson() => {
        "uri": uri,
        "fileName": fileName,
        "size": size,
      };

  factory FileClass.empty() => FileClass(
        uri: '',
        fileName: '',
        size: 0,
      );
}

class Geo {
  String longitude;
  String latitude;

  Geo({
    required this.longitude,
    required this.latitude,
  });

  factory Geo.fromJson(Map<String, dynamic> json) => Geo(
        longitude: json["longitude"] ?? '',
        latitude: json["latitude"] ?? '',
      );

  Map<String, dynamic> toJson() => {
        "longitude": longitude,
        "latitude": latitude,
      };

  factory Geo.empty() => Geo(
        longitude: '',
        latitude: '',
      );
}

class AutoReplyFlag {
  String id;
  int qaId;

  AutoReplyFlag({
    required this.id,
    required this.qaId,
  });

  factory AutoReplyFlag.fromJson(Map<String, dynamic> json) => AutoReplyFlag(
        id: json["id"] ?? '',
        qaId: json["qaId"] ?? 0,
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "qaId": qaId,
      };

  factory AutoReplyFlag.empty() => AutoReplyFlag(
        id: '',
        qaId: 0,
      );
}

class Blacklist {
  int workerId;

  Blacklist({
    required this.workerId,
  });

  factory Blacklist.fromJson(Map<String, dynamic> json) => Blacklist(
        workerId: json["workerId"] ?? 0,
      );

  Map<String, dynamic> toJson() => {
        "workerId": workerId,
      };

  factory Blacklist.empty() => Blacklist(
        workerId: 0,
      );
}

class WithAutoReply {
  String id;
  String title;
  String createdTime;
  List<Answer> answers;

  WithAutoReply({
    required this.id,
    required this.title,
    required this.createdTime,
    required this.answers,
  });

  factory WithAutoReply.fromJson(Map<String, dynamic> json) => WithAutoReply(
        id: json["id"] ?? '',
        title: json["title"] ?? '',
        createdTime: json["createdTime"] ?? '',
        answers: json["answers"] == null
            ? []
            : List<Answer>.from(json["answers"].map((x) => Answer.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "createdTime": createdTime,
        "answers": List<dynamic>.from(answers.map((x) => x.toJson())),
      };

  factory WithAutoReply.empty() => WithAutoReply(
        id: '',
        title: '',
        createdTime: '',
        answers: [],
      );
}

class WorkerChanged {
  String workerClientId;
  int workerId;
  String name;
  String avatar;
  String greeting;
  String state;
  String consultId;

  WorkerChanged({
    required this.workerClientId,
    required this.workerId,
    required this.name,
    required this.avatar,
    required this.greeting,
    required this.state,
    required this.consultId,
  });

  factory WorkerChanged.fromJson(Map<String, dynamic> json) => WorkerChanged(
        workerClientId: json["workerClientId"] ?? '',
        workerId: json["workerId"] ?? 0,
        name: json["name"] ?? '',
        avatar: json["avatar"] ?? '',
        greeting: json["greeting"] ?? '',
        state: json["State"] ?? '',
        consultId: json["consultId"] ?? '',
      );

  Map<String, dynamic> toJson() => {
        "workerClientId": workerClientId,
        "workerId": workerId,
        "name": name,
        "avatar": avatar,
        "greeting": greeting,
        "State": state,
        "consultId": consultId,
      };

  factory WorkerChanged.empty() => WorkerChanged(
        workerClientId: '',
        workerId: 0,
        name: '',
        avatar: '',
        greeting: '',
        state: '',
        consultId: '',
      );
}

class WorkerTrans {
  int workerId;
  String workerName;
  String workerAvatar;
  int consultId;

  WorkerTrans({
    required this.workerId,
    required this.workerName,
    required this.workerAvatar,
    required this.consultId,
  });

  factory WorkerTrans.fromJson(Map<String, dynamic> json) => WorkerTrans(
        workerId: json["workerId"] ?? 0,
        workerName: json["workerName"] ?? '',
        workerAvatar: json["workerAvatar"] ?? '',
        consultId: json["consultId"] ?? 0,
      );

  Map<String, dynamic> toJson() => {
        "workerId": workerId,
        "workerName": workerName,
        "workerAvatar": workerAvatar,
        "consultId": consultId,
      };

  factory WorkerTrans.empty() => WorkerTrans(
        workerId: 0,
        workerName: '',
        workerAvatar: '',
        consultId: 0,
      );
}

class Request {
  String chatId;
  String msgId;
  int count;
  bool withLastOne;
  int workerId;
  int consultId;
  int userId;

  Request({
    required this.chatId,
    required this.msgId,
    required this.count,
    required this.withLastOne,
    required this.workerId,
    required this.consultId,
    required this.userId,
  });

  factory Request.fromJson(Map<String, dynamic> json) => Request(
        chatId: json["chatId"] ?? '',
        msgId: json["msgId"] ?? '',
        count: json["count"] ?? 0,
        withLastOne: json["withLastOne"] ?? false,
        workerId: json["workerId"] ?? 0,
        consultId: json["consultId"] ?? 0,
        userId: json["userId"] ?? 0,
      );

  Map<String, dynamic> toJson() => {
        "chatId": chatId,
        "msgId": msgId,
        "count": count,
        "withLastOne": withLastOne,
        "workerId": workerId,
        "consultId": consultId,
        "userId": userId,
      };

  factory Request.empty() => Request(
        chatId: '',
        msgId: '',
        count: 0,
        withLastOne: false,
        workerId: 0,
        consultId: 0,
        userId: 0,
      );
}

enum QichatType {
  image,
  text,
  video,
}

enum QichatSendingType {
  isLoading,
  success,
  failed,
}

class QichatUserMessageModel {
  QichatType type;
  String content;
  String createdTime;
  QichatSendingType qichatSendingType;
  List<int> bytes;
  List<int> onSendProgress;
  File? file;
  String msgId;
  String replyMsgId;

  QichatUserMessageModel({
    required this.type,
    required this.content,
    required this.createdTime,
    required this.qichatSendingType,
    required this.bytes,
    required this.onSendProgress,
    required this.msgId,
    required this.replyMsgId,
    this.file,
  });

  factory QichatUserMessageModel.empty() => QichatUserMessageModel(
    type: QichatType.text,
    content: '',
    createdTime: '',
    qichatSendingType: QichatSendingType.isLoading,
    bytes: [],
    onSendProgress: [],
    msgId: '0',
    replyMsgId: '0',
  );
}

class QichatCustomerMessageModel {
  QichatType type;
  String content;
  String createdTime;
  String msgId;
  String replyMsgId;
  String msgOp;

  QichatCustomerMessageModel({
    required this.type,
    required this.content,
    required this.createdTime,
    required this.msgId,
    required this.replyMsgId,
    required this.msgOp,
  });

  factory QichatCustomerMessageModel.empty() => QichatCustomerMessageModel(
    type: QichatType.text,
    content: '',
    createdTime: '',
    msgId: '',
    replyMsgId: 'String',
    msgOp: 'MSG_OP_POST',
  );
}

class ReplyMessageModel {
  QichatType type;
  String content;
  String msgId;

  ReplyMessageModel({
    required this.type,
    required this.content,
    required this.msgId
  });

  factory ReplyMessageModel.empty() => ReplyMessageModel(
    type: QichatType.text,
    content: '',
    msgId: '0'
  );
}
