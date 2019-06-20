import 'package:dio/dio.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:flutter_wanandroid/constant/AppConfig.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

///基于dio封装的网络请求工具
///dio是一个强大的Http请求库
///支持Restful API、FormData、拦截器、请求取消、Cookie管理、文件上传/下载、超时、自定义适配器等
class HttpUtilDio {
  static HttpUtilDio mInstance;
  static String mToken;
  static Dio mDio;
  static String mCookiePath = "";

  //Dio配置
  BaseOptions mOptions;

  static HttpUtilDio getInstance() {
    if (mInstance == null) {
      mInstance = new HttpUtilDio();
    }
//    getCookiePath();
    return mInstance;
  }

  static void getCookiePath() async {
    Directory appDocDir = await getApplicationDocumentsDirectory();
    mCookiePath = appDocDir.path;
    //PersistCookieJar 实现了RFC中标准的cookie策略.
    // PersistCookieJar 会将cookie保存在文件中，所以 cookies 会一直存在除非显式调用 delete 删除
    mDio.interceptors
      ..add(CookieManager(PersistCookieJar(dir: mCookiePath + "/cookies/")))
      ..add(LogInterceptor());
  }

  HttpUtilDio() {
    getCookiePath();
    // 初始化 mOptions
    mOptions = new BaseOptions(
        baseUrl: AppConfig.BaseUrl,
        connectTimeout: AppConfig.ConnectTimeOut,
        receiveTimeout: AppConfig.ReceiveTimeOut,
        headers: {});
    mDio = new Dio(mOptions);
  }

  // get 请求封装
  get(url, {options, queryParams, token}) async {
    print('get:::url：$url ,queryParameters: $queryParams');
    Response<Map<String, dynamic>> response;
    try {
      response = await mDio.get<Map<String, dynamic>>(url,
          queryParameters: queryParams, cancelToken: token);
      print(response);
    } on DioError catch (e) {
      if (CancelToken.isCancel(e)) {
        print('get请求取消：' + e.message);
      } else {
        print('get请求发生错误：$e');
      }
    }
    return response.data;
  }

  post(url, {options, queryParams, token}) async {
    print('post::: url：$url ,queryParameters: $queryParams');
    Response<Map<String, dynamic>> response;
    try {
      response = await mDio.post<Map<String, dynamic>>(url,
          queryParameters: queryParams, cancelToken: token);
      print(response);
    } on DioError catch (e) {
      if (CancelToken.isCancel(e)) {
        print('post请求取消：' + e.message);
      } else {
        print('post请求发生错误：$e');
      }
    }
    return response.data;
  }
}
