import 'dart:convert';

import 'package:cgwallet/common/common.dart';
import 'package:dio/dio.dart';
import 'package:uuid/uuid.dart';
// import 'package:uuid/v8.dart';

class MyDio {
  CancelToken cancelTokenPublic = CancelToken();

  late final Dio dio;

  MyDio({
    required String baseUrl,
    required String token,
    String? time,
    String? device,
    bool? isUUID,
  }) {
    dio = Dio(_getDioOptions(baseUrl: baseUrl));
    dio.interceptors.add(_getInterceptorsWrapper(
      token: token,
      time: time,
      device: device,
      isUUID: isUUID,
    ));
  }

  BaseOptions _getDioOptions({
    required String baseUrl,
  }) {
    return BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: MyConfig.app.timeOutDefault,
      receiveTimeout: MyConfig.app.timeOutDefault,
      sendTimeout: MyConfig.app.timeOutDefault,
      contentType: 'application/json; charset=utf-8',
      responseType: ResponseType.json,
    );
  }

  InterceptorsWrapper _getInterceptorsWrapper({
    required String token,
    String? time,
    String? device,
    bool? isUUID,
  }) {
    return InterceptorsWrapper(
      onRequest: (options, handler) {
        options.headers.addAll({
          if (token.isNotEmpty)
            'x-token': token,
          if (time != null && time.isNotEmpty)
            'x-timestamp': DateTime.now().microsecondsSinceEpoch.toString(),
          if (device != null && device.isNotEmpty)
            'x-device': device,
          if (isUUID!= null && isUUID)
            'x-trace-id': const Uuid().v4(),
        });
        return handler.next(options);
      },
      onResponse: (response, handler) async {
        if (response.data is Map<String, dynamic>) {
          final responseModel = ResponseModel.fromJson(response.data);
          if ([4].contains(responseModel.code)) {
            UserController.to.goLoginView();
            await Future.delayed(MyConfig.app.timePageTransition);
            MyAlert.snackbar(responseModel.msg);
          } else if ([2].contains(responseModel.code)) {
            UserController.to.goFaceVerified();
            await Future.delayed(MyConfig.app.timePageTransition);
            MyAlert.snackbar(responseModel.msg);
          }
        }
        return handler.next(response);
      },
      onError: (DioException err, handler) {
        MyLogger.dioErr(err);
        // MyAlert.snackbar('${err.message}');
        return handler.next(err);
      },
    );
  }

  void cancel() {
    cancelTokenPublic.cancel();
  }

  void close() {
    dio.close();
    cancelTokenPublic.cancel();
  }

  void getNewCancelToken() {
    if (cancelTokenPublic.isCancelled) {
      cancelTokenPublic = CancelToken();
    }
  }

  Future<void> get<T>(
    String path, {
    Function(int code, String msg, T data)? onSuccess,
    Map<String, dynamic>? data,
    CancelToken? cancelToken,
    void Function(int, int)? onReceiveProgress,
    T Function(dynamic)? onModel,
    void Function()? onError,
  }) async {
    try {
      final response = await dio.get(path,
        queryParameters: data,
        cancelToken: cancelToken ?? cancelTokenPublic,
        onReceiveProgress: onReceiveProgress,
      );

      final responseModel = ResponseModel.fromJson(response.data);
      MyLogger.http(response);

      if (responseModel.code == 0) {
        final model = onModel != null ? onModel(responseModel.data) : responseModel.data as T;
        onSuccess?.call(responseModel.code, responseModel.msg, model);
      } else {
        MyAlert.snackbar(responseModel.msg);
        onError?.call();
      }
    } on DioException catch (e) {
      MyLogger.dioErr(e);
      // MyAlert.snackbar('$e');
      onError?.call();
    }
  }

  Future<void> post<T>(
    String path, {
    Function(int code, String msg, T data)? onSuccess,
    Map<String, dynamic>? data,
    CancelToken? cancelToken,
    T Function(dynamic)? onModel,
    void Function()? onError,
  }) async {
    try {
      final response = await dio.post(path,
        data: data,
        cancelToken: cancelToken ?? cancelTokenPublic,
      );

      final responseModel = ResponseModel.fromJson(response.data);
      MyLogger.http(response);

      if (responseModel.code == 0) {
        final model = onModel != null ? onModel(responseModel.data) : responseModel.data as T;
        onSuccess?.call(responseModel.code, responseModel.msg, model);
      } else {
        onError?.call();
        MyAlert.snackbar(responseModel.msg);
      }
    } on DioException catch (e) {
      onError?.call();
      MyLogger.dioErr(e);
      // MyAlert.snackbar('$e');
    }
  }


  Future<void> upload<T>(String path, {
    Function(int code, String msg, T data)? onSuccess,
    Map<String, dynamic>? data,
    CancelToken? cancelToken,
    T Function(dynamic)? onModel,
    void Function()? onError,
    void Function(int, int)? onSendProgress,
  }) async {
    try {
      final response = await dio.post(path,
        data: data == null ? null : FormData.fromMap(data),
        cancelToken: cancelToken ?? cancelTokenPublic,
        options: Options(contentType: 'multipart/form-data'),
        onSendProgress: onSendProgress,
      );

      final responseModel = ResponseModel.fromJson(response.data);
      // MyLogger.http('post', dio.options.baseUrl + path, response, responseModel);
      MyLogger.w("上传成功");

      if (responseModel.code == 0) {
        final model = onModel != null ? onModel(responseModel.data) : responseModel.data as T;
        onSuccess?.call(responseModel.code, responseModel.msg, model);
      } else {
        onError?.call();
        MyAlert.snackbar(responseModel.msg);
      }
    } on DioException catch (e) {
      onError?.call();
      MyLogger.dioErr(e);
      // MyAlert.snackbar('$e');
    }
  }


  Future<void> uploadQiChat<T>(
    String path, {
    Function(int code, String msg, T data)? onSuccess,
    Map<String, dynamic>? data,
    CancelToken? cancelToken,
    T Function(dynamic)? onModel,
    void Function()? onError,
    void Function(int, int)? onSendProgress,
  }) async {
    try {
      final response = await dio.post(path,
        data: data == null ? null : FormData.fromMap(data),
        cancelToken: cancelToken ?? cancelTokenPublic,
        options: Options(contentType: 'multipart/form-data'),
        onSendProgress: onSendProgress,
      );

      final json = jsonDecode(response.data);

      final responseModel = ResponseModel.empty();
      responseModel.code = json['code'];
      responseModel.msg = json['message'];
      responseModel.data = json['data'];

      // MyLogger.http('post', dio.options.baseUrl + path, response, responseModel);

      if (responseModel.code == 200) {
        final model = onModel != null ? onModel(responseModel.data) : responseModel.data as T;
        onSuccess?.call(responseModel.code, responseModel.msg, model);
      } else {
        onError?.call();
        MyAlert.snackbar(responseModel.msg);
      }
    } on DioException catch (e) {
      onError?.call();
      MyLogger.dioErr(e);
      // MyAlert.snackbar('$e');
    }
  }
}