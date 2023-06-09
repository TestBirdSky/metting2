import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:metting/network/bean/listener.dart';

import '../tool/log.dart';
import 'base_data.dart';
import 'bean/all_user_notes.dart';
import 'bean/balance_bean.dart';
import 'bean/call_chat_history_list.dart';
import 'bean/chat_id_bean.dart';
import 'bean/chat_lang.dart';
import 'bean/file_response.dart';
import 'bean/front_response.dart';
import 'bean/login_response.dart';
import 'bean/note_details.dart';
import 'bean/pay_list_response.dart';
import 'bean/random_nickname.dart';
import 'bean/square.dart';
import 'bean/topic_list_res.dart';
import 'bean/tread_list.dart';
import 'bean/user_data_res.dart';
import 'bean/vip_res.dart';
import 'bean/withdrawal_history_res.dart';
import 'bean/withdrawal_list.dart';

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
        data = ListenerList.fromJson(respData.data) as T;
      } else if (k == "FrontResponse") {
        data = FrontResponse.fromListJson(respData.data) as T;
      } else if (k == "TopicRes") {
        data = TopicRes.fromJson(respData.data) as T;
      } else if (k == "ListNoteDetail") {
        data = ListNoteDetail.fromJson(respData.data) as T;
      } else if (k == "RandomNickname") {
        data = RandomNickname.fromJson(respData.data) as T;
      } else if (k == "TreadList") {
        data = TreadList.fromJson(respData.data) as T;
      } else if (k == "ListUserNotesBean") {
        data = ListUserNotesBean.fromJson(respData.data) as T;
      } else if (k == "SquareRes") {
        data = SquareRes.fromJson(respData.data) as T;
      } else if (k == "BalanceBean") {
        data = BalanceBean.fromJson(respData.data) as T;
      } else if (k == "PayListResponse") {
        data = PayListResponse.fromJson(respData.data) as T;
      } else if (k == "WithdrawalList") {
        data = WithdrawalList.fromJson(respData.data) as T;
      } else if (k == "VipBean") {
        data = VipBean.fromJson(respData.data) as T;
      } else if (k == "CallChatHistoryList") {
        data = CallChatHistoryList.fromJson(respData.data) as T;
      } else if (k == "WithdrawalHistoryRes") {
        data = WithdrawalHistoryRes.fromJson(respData.data) as T;
      } else if (k == "ChatIdBean") {
        data = ChatIdBean.fromJson(respData.data) as T;
      } else {
        logger.i('syncData not set data Type${response.data}');
        data = response.data;
      }
      return BasePageData(respData.code, respData.msg, data);
    }
  } catch (e) {
    logger.e('syncData e$e');
  }
  return BasePageData(respData.code, respData.msg, null);
}
