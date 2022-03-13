import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:monggo_pinarak/monggo_pinarak.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

class DioService {
  static String apiKeyClientStag = "SB-Mid-client-aa2ER60LuDxSBvOX";
  static String apiKeyServerStag = "SB-Mid-server-isqWXbsyvCAXAje3ejYOR2kk";

  static String apiKeyClientProd = "Mid-client-RGPawffjB4tR8lR0";
  static String apiKeyServerProd = "Mid-server-4yxW3fJWkY5_0cKFiFal9HEs";

  static BuildContext? loadingContext;
  static bool debug = true;
  static bool prod = false;

  static Future<Dio> setupDio({
    bool isLoading = false,
  }) async {
    if (isLoading) {
      dialogLoading();
    }

    Dio dio = Dio();

    BaseOptions options = await _createBaseOption();

    dio = Dio(options);

    // print('============= onRequest ============= ${dio.options.baseUrl}');

    DateTime responseTime = DateTime.now();
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (RequestOptions? option, handler) async {
          responseTime = DateTime.now();
          print('============= onRequest =============');
          handler.next(option!);
        },
        onResponse: (Response response, handler) async {
          // print('DateTime ${DateTime.now().toString()}');
          // print(
          //     'responseTime ${DateTime.now().difference(responseTime).inMilliseconds}ms');
          // print('method ${response.requestOptions.method}');
          // print(
          //     'API ${response.requestOptions.uri.origin}${response.requestOptions.uri.path}');
          // print('responseData ${response.data}');
          if (isLoading && loadingContext != null) {
            Navigator.pop(loadingContext!);
          }
          print('============= onResponse =============');
          handler.next(response);
        },
        onError: (DioError e, handler) async {
          // print('DateTime ${DateTime.now().toString()}');
          // print(
          //     'responseTime ${DateTime.now().difference(responseTime).inMilliseconds}ms');
          // print('method ${e.requestOptions.method}');
          // print(
          //     'API ${e.requestOptions.uri.origin}${e.requestOptions.uri.path}');
          // print('responseData ${e.response}');
          print('============= onError =============');

          handler.next(e);
        },
      ),
    );

    dio.interceptors.add(
      PrettyDioLogger(
        error: debug,
        request: debug,
        requestBody: debug,
        requestHeader: debug,
        responseBody: debug,
        responseHeader: debug,
        compact: debug,
        maxWidth: 500,
      ),
    );

    return dio;
  }

  static Future<BaseOptions> _createBaseOption() async {
    String baseUrlStag = r'https://api.sandbox.midtrans.com/v2/';
    String baseUrlProd = r'https://api.midtrans.com/v2/';

    // if (isUseBearer) isUseBearer = await GlobalFunction.checkIsLogin();
    String credentials = "${prod ? apiKeyServerProd : apiKeyServerStag}:";
    Codec<String, String> stringToBase64 = utf8.fuse(base64);
    String encoded = stringToBase64.encode(credentials);

    var options = BaseOptions(
        baseUrl: prod ? baseUrlProd : baseUrlStag,
        connectTimeout: Duration(seconds: 30).inMilliseconds,
        receiveTimeout: Duration(seconds: 30).inMilliseconds,
        sendTimeout: Duration(seconds: 30).inMilliseconds,
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
          'Authorization': 'Basic $encoded',
        });
    return options;
  }

  static void dialogLoading() => showCupertinoDialog(
        context: navGK.currentState!.context,
        barrierDismissible: true,
        builder: (BuildContext buildContext) {
          loadingContext = buildContext;
          return Scaffold(
            backgroundColor: Colors.transparent,
            body: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CupertinoActivityIndicator(),
                    ),
                  ),
                  Text(
                    r'Mohon Tunggu',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );
}
