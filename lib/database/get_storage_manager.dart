import 'package:get_storage/get_storage.dart';

import '../network/bean/chat_lang.dart';
import '../network/bean/user_data_res.dart';
import '../tool/log.dart';

final _firstInitStorage = GetStorage('firstInitStorage');

final _commonStorage = GetStorage();

int getUID() {
  return _firstInitStorage.read('uid') ?? -1;
}

Future<void> saveUid(int? uid) {
  logger.i('saveUid $uid');
  return _firstInitStorage.write('uid', uid);
}

///保存某个人的基本信息数据
Future<void> saveUserBasic(UserDataRes userBasic) {
  return _commonStorage.write('${userBasic.uid}', userBasic);
}

///获取某个人的基本信息数据
UserDataRes? getUserBasic(int uid) {
  final userBasicMap = _commonStorage.read('$uid');
  try {
    logger.i(userBasicMap);
    return userBasicMap;
  } catch (e) {
    logger.e(e);
    return userBasicMap == null ? null : UserDataRes.fromJson(userBasicMap);
  }
}

ChatLang getChatLangFStroage() {
  final str = {
    "chat_lang": [
      "普通话",
      "英语",
      "北京话",
      "杭州话",
      "河南话",
      "苏州话",
      "上海话",
      "武汉话",
      "天津话",
      "闽南话",
      "广东话",
      "山东话",
      "四川话",
      "西安话",
      "东北话",
      "南京话",
      "长沙话",
      "南昌话",
      "梅县话",
      "江东话",
      "江南话",
      "江浙话",
      "客家话",
      "白话",
      "广府话",
      "福州话",
      "湖南话",
      "江西话"
    ]
  };
  final chat = _commonStorage.read('chatLang');
  try {
    return chat;
  } catch (e) {
    logger.e(e);
    return chat == null ? ChatLang.fromJson(str) : ChatLang.fromJson(chat);
  }
}

Future<void> saveChatLangTStorage(ChatLang? chatLang) {
  return _commonStorage.write('chatLang', chatLang);
}
