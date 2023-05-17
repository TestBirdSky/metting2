import 'package:get_storage/get_storage.dart';
import 'package:metting/network/bean/topic_list_res.dart';

import '../network/bean/chat_lang.dart';
import '../network/bean/user_data_res.dart';
import '../tool/log.dart';

final _firstInitStorage = GetStorage('firstInitStorage');

final _commonStorage = GetStorage();

int getMineUID() {
  return _firstInitStorage.read('uid') ?? -1;
}

Future<void> saveMineUid(int? uid) {
  logger.i('saveUid $uid');
  return _firstInitStorage.write('uid', uid);
}

String getLastLoginAccount() {
  return _firstInitStorage.read('accountLast') ?? '';
}

Future<void> saveLoginAccount(String account) {
  return _firstInitStorage.write('accountLast', account);
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

TopicRes? getTopicListFGS() {
  final chat = _commonStorage.read('TopicRes');
  try {
    return chat;
  } catch (e) {
    return TopicRes.fromJson(chat);
  }
}

Future<void> saveTopicListTStorage(TopicRes? topicRes) {
  return _commonStorage.write('TopicRes', topicRes);
}

class GStorage {
  static bool getIsOpenMessageNotification() {
    return _commonStorage.read('messNotificationStatus');
  }

  static Future<void> saveMessageNotificationStatus(bool isOpen) {
    return _commonStorage.write('messNotificationStatus', isOpen);
  }

  ///获取某个人的基本信息数据
  static UserDataRes? getMineUserBasic() {
    final userBasicMap = _commonStorage.read('${getMineUID()}');
    try {
      return userBasicMap == null ? null : UserDataRes.fromJson(userBasicMap);
    } catch (e) {
      logger.e(e);
      return null;
    }
  }

  ///获取某个人的基本信息数据
  static UserDataRes? getUserBasic(int uid) {
    final userBasicMap = _commonStorage.read('$uid');
    try {
      logger.i(userBasicMap);
      return userBasicMap == null ? null : UserDataRes.fromJson(userBasicMap);
    } catch (e) {
      logger.e(e);
      return null;
    }
  }

  ///保存某个人的基本信息数据
  static Future<void> saveUserBasic(UserDataRes userBasic) {
    return _commonStorage.write('${userBasic.uid}', userBasic);
  }

  static int getVoicePrice() {
    return _commonStorage.read('voicePrice');
  }

  static Future<void> saveVoicePrice(int voicePrice) {
    return _commonStorage.write('voicePrice', voicePrice);
  }

  static int getVideoPrice() {
    return _commonStorage.read('videoPrice');
  }

  static Future<void> saveVideoPrice(int videoPrice) {
    return _commonStorage.write('videoPrice', videoPrice);
  }
}
