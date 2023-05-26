import 'dart:io';

import 'package:dio/dio.dart';
import 'package:im_flutter_sdk/im_flutter_sdk.dart';
import 'package:metting/network/base_data.dart';
import 'package:metting/network/bean/listener.dart';
import 'package:metting/network/bean/login_response.dart';
import 'package:metting/network/bean/note_details.dart';
import 'package:metting/network/bean/square.dart';
import 'package:metting/network/bean/tread_list.dart';
import 'package:metting/network/bean/user_data_res.dart';
import 'package:metting/tool/emc_helper.dart';
import 'package:metting/tool/log.dart';

import '../database/get_storage_manager.dart';
import 'bean/all_user_notes.dart';
import 'bean/balance_bean.dart';
import 'bean/call_chat_history_list.dart';
import 'bean/chat_id_bean.dart';
import 'bean/chat_lang.dart';
import 'bean/create_record_response.dart';
import 'bean/file_response.dart';
import 'bean/front_response.dart';
import 'bean/pay_list_response.dart';
import 'bean/random_nickname.dart';
import 'bean/topic_list_res.dart';
import 'bean/vip_res.dart';
import 'bean/withdrawal_history_res.dart';
import 'bean/withdrawal_list.dart';
import 'dio_helper.dart';
import 'sync_data.dart';

Map _addCommonInfo(Map map) {
  map['uid'] = getMineUID();
  return map;
}

/// OSS文件上传 视频、图片先使用此接口进行上传
Future<BasePageData<String?>> fileUploadUrl(String filePath) async {
  final baseData = await fileUpload(filePath);
  return BasePageData(baseData.code, baseData.msg, baseData.data?.url);
}

/// OSS文件上传 视频、图片先使用此接口进行上传
Future<BasePageData<FileResponse?>> fileUpload(String filePath) async {
  FormData formData = FormData.fromMap({
    'file': await MultipartFile.fromFile(filePath),
  });
  try {
    Response response = await getNoEncryptionDio()
        .post('/index/share/ossUpload', data: formData);
    return syncData<FileResponse>(response);
  } catch (error) {
    logger.e(error);
  }
  return errorBasePageData;
}

Future<BasePageData<LoginResponse?>> loginPhone(
    String phone, String code) async {
  try {
    Response response = await getDio()
        .post('index/Login/codeLogin', data: {'phone': phone, 'code': code});
    final r = syncData<LoginResponse>(response);
    logger.i('r${r.data?.toJson()}');
    saveMineUid(r.data?.uid);
    LoginResponse? data = r.data;
    if (r.isOk() && data != null) {
      EmcHelper.signIn("${data.uid}", "${data.token}");
    }
    return r;
  } catch (e) {
    logger.e("$e");
    return errorBasePageData;
  }
}

Future<BasePageData> autoLogin() async {
  try {
    logger.e("message autoLogin");
    final token = getEmToken();
    final userId = getMineUID();
    logger.e("message$token---$userId");
    if (token.isEmpty || userId == -1) {
      return BasePageData(-1, "", null);
    }
    await EMClient.getInstance.login("$userId", token, false);
    return BasePageData(respCodeSuccess, "", null);
  } on EMError catch (e) {
    logger.e("message$e");
    return BasePageData(e.code, e.description, null);
  }
}

Future<BasePageData<String?>> sendSms(String phone) async {
  try {
    Response response =
        await getDio().post('/index/Login/sendCodeSms', data: {'phone': phone});
    logger.i("$response---${response.data}}");
    return syncData<String?>(response);
  } catch (e) {
    logger.e("$e");
  }
  return errorBasePageData;
}

Future<BasePageData<String?>> updateUserInfo(Map map) async {
  try {
    Response response =
        await getDio().post('index/User/upUserInfo', data: _addCommonInfo(map));
    return syncData<String>(response);
  } catch (e) {
    logger.e("$e");
  }
  return errorBasePageData;
}

Future<BasePageData> setMessageNotificationStatus(bool isOpen) async {
  final enable = isOpen ? 1 : 0;
  return await mineSetting({'messages_receiving': enable});
}

Future<BasePageData> setShowWomanInfo(bool isOpen) async {
  final enable = isOpen ? 1 : 0;
  return await mineSetting({'show_sex1': enable});
}

Future<BasePageData> setShowManInfo(bool isOpen) async {
  final enable = isOpen ? 1 : 0;
  return await mineSetting({'show_sex2': enable});
}

Future<BasePageData> setVideoCall(int money) async {
  return await mineSetting({'video_call': money});
}

Future<BasePageData> setVoiceCall(int money) async {
  return await mineSetting({'voice_call': money});
}

//     * index/User/userSetup
//      * 请求信息
//      * 必要条件字段
//      * uid [用户uid]
//      * 非必要条件字段
//      * messages_receiving [消息免打扰开关，0-否（不接收），1-是(接收)]
//      * show_sex1 [是否显示女性 ，0-否，1-是]
//      * show_sex2 [是否显示男性， 0-否，1-是]
//      * video_call [视频通话，每分钟收费]
//      * voice_call [语音通话，每分钟收费]
Future<BasePageData> mineSetting(Map map) async {
  try {
    Response response =
        await getDio().post('index/User/userSetup', data: _addCommonInfo(map));
    logger.i("$response---${response.data}}");
    return syncData(response);
  } catch (e) {
    logger.e("$e");
    return errorBasePageData;
  }
}

Future<BasePageData> delMineAccount() async {
  try {
    Response response = await getDio()
        .post('index/share/delUserData', data: _addCommonInfo({}));
    logger.i("$response---${response.data}}");
    return syncData(response);
  } catch (e) {
    logger.e("$e");
    return errorBasePageData;
  }
}

Future<BasePageData<TreadList?>> getTreadList(int page) async {
  try {
    Response response = await getDio()
        .post('index/Trends/trendsList', data: _addCommonInfo({"page": page}));
    logger.i("$response---${response.data}}");
    return syncData<TreadList>(response);
  } catch (e) {
    logger.e("$e");
    return errorBasePageData;
  }
}

Future<BasePageData> addVoiceTrends(File file,int second) async {
  try {
    final filePath = await fileUploadUrl(file.path);
    if (filePath.isOk() && filePath.data?.isNotEmpty == true) {
      String content = filePath.data!;
      Response response = await getDio().post('index/Trends/addTrends',
          data: _addCommonInfo({"content": content, "type": 2, "mt": second}));
      logger.i("$response---${response.data}}");
      return syncData(response);
    }
  } catch (e) {
    logger.e("$e");
  }
  return errorBasePageData;
}

Future<BasePageData> addTextTrends(String content) async {
  try {
    Response response = await getDio().post('index/Trends/addTrends',
        data: _addCommonInfo({"content": content, "type": 1}));
    logger.i("$response---${response.data}}");
    return syncData(response);
  } catch (e) {
    logger.e("$e");
    return errorBasePageData;
  }
}

Future<BasePageData> delTrends(num trendId) async {
  try {
    Response response =
        await getDio().post('index/Trends/delTrends', data: _addCommonInfo({}));
    logger.i("$response---${response.data}}");
    return syncData(response);
  } catch (e) {
    logger.e("$e");
    return errorBasePageData;
  }
}

Future<BasePageData<UserDataRes?>> getUserData(num id) async {
  try {
    Response response = await getDio()
        .post('index/User/getUserData', data: _addCommonInfo({"userId": id}));
    logger.i("$response---${response.data}}");
    return syncData<UserDataRes>(response);
  } catch (e) {
    logger.e("$e");
    return errorBasePageData;
  }
}

Future<BasePageData<ChatLang?>> getChatLang() async {
  try {
    Response response =
        await getDio().post('index/share/getLang', data: _addCommonInfo({}));
    final data = syncData<ChatLang>(response);
    if (data.isOk()) {
      saveChatLangTStorage(data.data);
    }
    return data;
  } catch (e) {
    logger.e("$e");
    return errorBasePageData;
  }
}

Future<BasePageData<ListenerList?>> getListener(int page,
    {List<int> topicId = const [], int sex = 3}) async {
  try {
    Response response = await getDio().post('index/Index/listenerList',
        data: _addCommonInfo({"page": page, "sex": sex, "topicId": topicId}));
    logger.i("$response---${response.data}}");
    final data = syncData<ListenerList>(response);
    return data;
  } catch (e) {
    logger.e("$e");
    return errorBasePageData;
  }
}

Future<BasePageData<TopicRes?>> getTopicList() async {
  try {
    Response response =
        await getDio().post('index/Trends/topicList', data: _addCommonInfo({}));
    final data = syncData<TopicRes>(response);
    return data;
  } catch (e) {
    logger.e("$e");
    return errorBasePageData;
  }
}

//创建通话记录
Future<BasePageData<CreateRecordResponse?>> getCreateChatId(
    int userid, int type, int classT) async {
  try {
    Response response = await getDio().post('index/Call/createRecord',
        data:
            _addCommonInfo({"userid": userid, "class": classT, "type": type}));
    logger.i("$response---${response.data}}");
    final data = syncData<CreateRecordResponse>(response);
    return data;
  } catch (e) {
    logger.e("$e");
    return errorBasePageData;
  }
}

//index/Index/frontPage 首页数据
Future<BasePageData<FrontResponse?>> getFrontPage(int page) async {
  try {
    Response response = await getDio().post('index/Index/frontPage',
        data: _addCommonInfo({"page": page, "sex": 3}));
    logger.i("$response---${response.data}}");
    final data = syncData<FrontResponse>(response);
    return data;
  } catch (e) {
    logger.e("$e");
    return errorBasePageData;
  }
}

// 添加日记 index/Memory/addMemory
Future<BasePageData> addNote(String content) async {
  try {
    Response response = await getDio().post('index/Memory/addMemory',
        data: _addCommonInfo({"content": content}));
    final data = syncData(response);
    return data;
  } catch (e) {
    logger.e("$e");
    return errorBasePageData;
  }
}

Future<BasePageData<ListNoteDetail?>> getNoteDetails(int uid, int page) async {
  try {
    Response response = await getDio()
        .post('index/Memory/personalList', data: {"page": page, "uid": uid});
    logger.i("$response---${response.data}}");
    final data = syncData<ListNoteDetail>(response);
    return data;
  } catch (e) {
    logger.e("$e");
    return errorBasePageData;
  }
}

//获取所有用户的日记
Future<BasePageData<ListUserNotesBean?>> getMemoryList(int page) async {
  try {
    Response response = await getDio()
        .post('index/Memory/memoryList', data: _addCommonInfo({"page": page}));
    final data = syncData<ListUserNotesBean>(response);
    return data;
  } catch (e) {
    logger.e("$e");
    return errorBasePageData;
  }
}

Future<BasePageData<String?>> getRandName() async {
  try {
    Response response =
        await getDio().post('index/User/randCname', data: _addCommonInfo({}));
    final data = syncData<RandomNickname>(response);
    return BasePageData(data.code, data.msg, data.data?.nicName);
  } catch (e) {
    logger.e("$e");
    return errorBasePageData;
  }
}

Future<BasePageData> addFeedback(String content, List<String> img) async {
  List<String> urlOSS = [];
  int length = img.length;
  for (int i = 0; i < length; i++) {
    BasePageData<String?> data = await fileUploadUrl(img[i]);
    if (data.isOk()) {
      if (data.data != null) {
        urlOSS.add(data.data ?? "");
      }
    }
  }
  try {
    Response response = await getDio().post('index/share/addFeedback',
        data: _addCommonInfo(
            {'content': content, 'img': urlOSS, 'userModel': 'iphone'}));
    return syncData(response);
  } catch (e) {
    logger.e("$e");
    return errorBasePageData;
  }
}

Future<BasePageData<SquareRes?>> getSquareList(int page) async {
  try {
    Response response = await getDio()
        .post('index/Square/squareList', data: _addCommonInfo({"page": page}));
    final data = syncData<SquareRes>(response);
    return data;
  } catch (e) {
    logger.e("$e");
    return errorBasePageData;
  }
}

Future<BasePageData> addSquare(
    List<String> topics, int type, int pirce, String des, int time) async {
  try {
    Response response = await getDio().post('index/Square/addSquare',
        data: _addCommonInfo({
          "topic": topics,
          "type": type,
          "price": pirce,
          "describe": des,
          "time": time
        }));
    final data = syncData(response);
    return data;
  } catch (e) {
    logger.e("$e");
    return errorBasePageData;
  }
}

//余额
Future<BasePageData<BalanceBean?>> getMyBalance() async {
  try {
    Response response =
        await getDio().post('index/Pay/getBalance', data: _addCommonInfo({}));
    final data = syncData<BalanceBean>(response);
    return data;
  } catch (e) {
    logger.e("$e");
    return errorBasePageData;
  }
}

//支付列表
Future<BasePageData<PayListResponse?>> getPayList() async {
  try {
    Response response =
        await getDio().post('index/Pay/rechargeList', data: _addCommonInfo({}));
    final data = syncData<PayListResponse>(response);
    return data;
  } catch (e) {
    logger.e("$e");
    return errorBasePageData;
  }
}

//提现列表
Future<BasePageData<WithdrawalList?>> getWithdrawalList() async {
  try {
    Response response = await getDio()
        .post('index/Withdrawal/withdrawalList', data: _addCommonInfo({}));
    return syncData<WithdrawalList>(response);
  } catch (e) {
    logger.e("$e");
    return errorBasePageData;
  }
}

//添加体现账号
Future<BasePageData> addAliUser(String aliID, String name) async {
  try {
    Response response = await getDio().post('index/Withdrawal/addAliUser',
        data: _addCommonInfo({"aliID": aliID, "name": name}));
    return syncData<WithdrawalList>(response);
  } catch (e) {
    logger.e("$e");
    return errorBasePageData;
  }
}

//提现
Future<BasePageData> getWithdrawalApply(num id) async {
  try {
    Response response = await getDio().post(
        'index/Withdrawal/withdrawalRecords',
        data: _addCommonInfo({"id": id}));
    return syncData(response);
  } catch (e) {
    logger.e("$e");
    return errorBasePageData;
  }
}

//提现历史
Future<BasePageData<WithdrawalHistoryRes?>> getWithdrawalHistory(
    num page) async {
  try {
    Response response = await getDio().post(
        'index/Withdrawal/withdrawal_records',
        data: _addCommonInfo({"page": page}));
    return syncData<WithdrawalHistoryRes>(response);
  } catch (e) {
    logger.e("$e");
    return errorBasePageData;
  }
}

//获取会员
Future<BasePageData<VipBean?>> getPayTime() async {
  try {
    Response response =
        await getDio().post('index/share/getPayTime', data: _addCommonInfo({}));
    return syncData<VipBean>(response);
  } catch (e) {
    logger.e("$e");
    return errorBasePageData;
  }
}

//生成内购订单号
Future<BasePageData<VipBean?>> createOrder(int productID) async {
  try {
    Response response = await getDio().post('index/Pay/createOrder',
        data: _addCommonInfo({'productID': productID}));
    return syncData<VipBean>(response);
  } catch (e) {
    logger.e("$e");
    return errorBasePageData;
  }
}

//验证内购订单号     * uid [充值人UID]
//      * orderId [充值订单id]
//      * receipt_data [支付凭证]
//      * transactionID [苹果交易ID]
Future<BasePageData<VipBean?>> verifyOrderOrder(int productID) async {
  try {
    Response response = await getDio().post('index/Pay/verifyOrder',
        data: _addCommonInfo({'productID': productID}));
    return syncData<VipBean>(response);
  } catch (e) {
    logger.e("$e");
    return errorBasePageData;
  }
}

Future<BasePageData<ChatIdBean?>> createVoiceWithListener(num userid) async {
  return _createRecord(userid, 1, 1);
}

Future<BasePageData<ChatIdBean?>> createVoiceWithUser(num userid) async {
  return _createRecord(userid, 1, 2);
}

Future<BasePageData<ChatIdBean?>> createVideoWithUser(num userid) async {
  return _createRecord(userid, 2, 2);
}

Future<BasePageData<ChatIdBean?>> createVideoWithListener(num userid) async {
  return _createRecord(userid, 2, 1);
}

Future<BasePageData<ChatIdBean?>> _createRecord(
    num userid, int type, int clazz) async {
  try {
    Response response = await getDio().post('index/Call/createRecord',
        data: _addCommonInfo({'userid': userid, "type": type, "class": clazz}));
    return syncData<ChatIdBean>(response);
  } catch (e) {
    logger.e("$e");
    return errorBasePageData;
  }
}

Future<BasePageData> updateChatStatusOneMin(int id) async {
  try {
    Response response =
        await getDio().post('index/Call/callHistory', data: {'id': id});
    return syncData(response);
  } catch (e) {
    logger.e("$e");
    return errorBasePageData;
  }
}

//通话记录
Future<BasePageData<CallChatHistoryList?>> getCallHistory(int page) async {
  try {
    Response response = await getDio()
        .post('index/Call/call_history', data: _addCommonInfo({"page": page}));
    return syncData<CallChatHistoryList>(response);
  } catch (e) {
    logger.e("$e");
    return errorBasePageData;
  }
}
