import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:metting/network/bean/listener.dart';

import '../tool/log.dart';
import 'base_data.dart';
import 'bean/chat_lang.dart';
import 'bean/file_response.dart';
import 'bean/login_response.dart';
import 'bean/user_data_res.dart';

final errorBasePageData = BasePageData(errorCodeNetworkError, '网络异常', null);

BasePageData<T> syncData<T>(Response response) {
  final Map<String, dynamic> responseMap = jsonDecode(response.data);
  final respData = BaseResp.fromJson(responseMap);
  try {
    if (respData.isOk()) {
      T data;
      logger.i("type -->${T.toString()}");
      final k = T.toString();
      if (k == "LoginResponse") {
        data = LoginResponse.fromJson(respData.data) as T;
      } else if (k == "FileResponse") {
        data = FileResponse.fromJson(respData.data) as T;
      } else if (k == "UserDataRes") {
        data = UserDataRes.fromJson(respData.data) as T;
      } else if (k == "ChatLang") {
        data = ChatLang.fromJson(respData.data) as T;
      } else if (k == "ListenerList") {
        data = ListenerList.fromJson(respData) as T;
      } else {
        logger.i('syncData not set data Type');
        data = response.data;
      }
      return BasePageData(respData.code, respData.msg, data);
    }
  } catch (e) {
    logger.e('syncData e$e');
  }
  return BasePageData(respData.code, respData.msg, null);
}
