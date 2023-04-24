import 'package:dio/dio.dart';
import 'package:metting/network/base_data.dart';
import 'package:metting/network/bean/listener.dart';
import 'package:metting/network/bean/login_response.dart';
import 'package:metting/network/bean/note_details.dart';
import 'package:metting/network/bean/user_data_res.dart';
import 'package:metting/tool/log.dart';

import '../database/get_storage_manager.dart';
import 'bean/all_user_notes.dart';
import 'bean/chat_lang.dart';
import 'bean/create_record_response.dart';
import 'bean/file_response.dart';
import 'bean/front_response.dart';
import 'bean/topic_list_res.dart';
import 'dio_helper.dart';
import 'sync_data.dart';

Map _addCommonInfo(Map map) {
  map['uid'] = getUID();
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
    saveUid(r.data?.uid);

    return r;
  } catch (e) {
    logger.e("$e");
    return errorBasePageData;
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

Future<BasePageData> addAudTrends(String content, int second) async {
  try {
    Response response = await getDio().post('index/Trends/addTrends',
        data: _addCommonInfo({"content": content, "type": 2, "mt": second}));
    logger.i("$response---${response.data}}");
    return syncData(response);
  } catch (e) {
    logger.e("$e");
    return errorBasePageData;
  }
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

Future<BasePageData> delTrends(int trendId) async {
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

Future<BasePageData<UserDataRes?>> getUserData(int id) async {
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

Future<BasePageData<TopicBean?>> getTopicList() async {
  try {
    Response response =
        await getDio().post('index/Trends/topicList', data: _addCommonInfo({}));
    final data = syncData<TopicBean>(response);
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

Future<BasePageData<ListUserNotesBean?>> getMemoryList(int page) async {
  try {
    Response response = await getDio().post('index/Memory/memoryList',
        data: _addCommonInfo({"page": page}));
    final data = syncData<ListUserNotesBean>(response);
    return data;
  } catch (e) {
    logger.e("$e");
    return errorBasePageData;
  }
}
