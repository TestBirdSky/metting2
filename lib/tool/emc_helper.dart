import 'package:get/get.dart';
import 'package:im_flutter_sdk/im_flutter_sdk.dart';
import 'package:metting/database/get_storage_manager.dart';
import 'package:metting/page/call/call_bean.dart';
import 'package:metting/page/call/video_chat_page.dart';
import 'package:metting/page/call/voice_chat_page.dart';
import 'package:metting/page/message/conversations_bean.dart';
import 'package:metting/page/message/message_list_controller.dart';
import 'package:metting/tool/log.dart';
import 'package:metting/widget/my_toast.dart';

import '../dialog/my_dialog.dart';
import 'account_utils.dart';

class EmcHelper {
  static const appKey = "1100230401164364#demo";

  static Future<void> initSDK() async {
    EMOptions options = EMOptions(
      appKey: appKey,
      autoLogin: true,
    );
    options.enableAPNs('certName');
    await EMClient.getInstance.init(options);
    // 通知sdk ui已经准备好，执行后才会收到`EMChatRoomEventHandler`, `EMContactEventHandler`, `EMGroupEventHandler` 回调。
    await EMClient.getInstance.startCallback();
  }

  static void _addConnectionListener() {
    EMClient.getInstance.addConnectionEventHandler(
      "${getMineUID()}",
      EMConnectionEventHandler(
        // sdk 连接成功;
        onConnected: () => {logger.i("_addConnectionListener onConnected ")},
        // 由于网络问题导致的断开，sdk会尝试自动重连，连接成功后会回调 "onConnected";
        onDisconnected: () =>
            {logger.i("_addConnectionListener onDisconnected ")},
        // 用户 token 鉴权失败;
        onUserAuthenticationFailed: () =>
            {logger.i("_addConnectionListener onUserAuthenticationFailed ")},
        // 由于密码变更被踢下线;
        onUserDidChangePassword: () => {},
        // 用户被连接被服务器禁止;
        onUserDidForbidByServer: () => {},
        // 用户已经在其他设备登录;
        onUserDidLoginFromOtherDevice: () => {
          logger.i("_addConnectionListener onUserDidLoginFromOtherDevice "),
          AccountUtils.logoutDataHandler(),
          showAccountOfflineDialog(),
        },
        // 用户登录设备超出数量限制;
        onUserDidLoginTooManyDevice: () => {},
        // 用户从服务器删除;
        onUserDidRemoveFromServer: () => {},
        // 由于其他设备登录被踢下线；
        onUserKickedByOtherDevice: () => {
          logger.i("_addConnectionListener  由于其他设备登录被踢下线； "),
          AccountUtils.logoutDataHandler(),
          showAccountOfflineDialog(),
        },
        // Token 过期;
        onTokenDidExpire: () => {},
        // Token 即将过期，需要调用 renewToken;
        onTokenWillExpire: () => {},
      ),
    );
  }

  static Future<void> signIn(String _userId, String token) async {
    try {
      await EMClient.getInstance.login(_userId, token, true);
      _addLogToConsole("sign in succeed, username: $_userId--$token");
      _addConnectionListener();
    } on EMError catch (e) {
      _addLogToConsole(
          "sign in failed, e: ${e.code} , ${e.description} $_userId--$token");
      rethrow;
    }
  }

  static Future<void> signOut() async {
    try {
      EMClient.getInstance.removeConnectionEventHandler("${getMineUID()}");
      EMClient.getInstance.chatManager.clearEventHandlers();
      removeGlobalMessageListener();
      await EMClient.getInstance.logout(true);
      _addLogToConsole("sign out succeed");
    } on EMError catch (e) {
      _addLogToConsole(
          "sign out failed, code: ${e.code}, desc: ${e.description}");
    }
  }

  static void _addLogToConsole(String msg) {
    logger.e(msg);
  }

  //
  // static Future<List<EMConversation>> getAllMessageFromServer() async {
  //   return EMClient.getInstance.chatManager.getConversationsFromServer();
  // }

  static Future<EMConversation?> getConversationMessage(
      int targetUid, int minUid) async {
    return await EMClient.getInstance.chatManager.getConversation("$targetUid");
  }

  //获取本地会话消息
  static Future<List<ConversationBean>> getAllConversationsMessage({
    int pageNum = 1,
    int pageSize = 30,
  }) async {
    List<EMConversation> conversations = await EMClient.getInstance.chatManager
        .fetchConversationListFromServer(pageNum: pageNum, pageSize: pageSize);
    if (conversations.isEmpty) {
      conversations =
          await EMClient.getInstance.chatManager.loadAllConversations();
    }
    List<ConversationBean> msgBeanList = [];
    logger.i('conversations size->${conversations.length}');
    for (var element in conversations) {
      logger.i('conversations ->${element.id}');
      if (element.id == "admin") {
        continue;
      }
      final bean = ConversationBean();
      await bean.updateConversation(element);
      await setConversationBeanUserInfo(bean, element.id);
      msgBeanList.add(bean);
    }
    return msgBeanList;
  }

  static Future<EMUserInfo?> setConversationBeanUserInfo(
      ConversationBean bean, String id) async {
    final userInfo = await fetchUserInfo(id);
    if (userInfo != null) {
      bean.avator = userInfo.avatarUrl;
      bean.name = userInfo.nickName;
    }
    return userInfo;
  }

  static Future<EMUserInfo?> fetchUserInfo(String id) async {
    final mapInfo = await fetchUserInfoList([id]);
    return mapInfo?[id];
  }

  //获取用户信息
  static Future<Map<String, EMUserInfo>?> fetchUserInfoList(
      List<String> list) async {
    // List<String> list = ["tom", "json"];
    try {
      Map<String, EMUserInfo> userInfos =
          await EMClient.getInstance.userInfoManager.fetchUserInfoById(list);
      return userInfos;
    } on EMError catch (e) {
      // 获取用户属性失败，返回错误信息。
    }
    return null;
  }

  //删除会话及其消息
  static Future<bool> delConversation(String conversationId,
      {bool isDeleteMessage = false}) async {
    // 删除会话时是否同时删除服务端的历史消息。
    EMConversationType conversationType = EMConversationType.Chat;
    await EMClient.getInstance.chatManager.deleteRemoteConversation(
      conversationId,
      conversationType: conversationType,
      isDeleteMessage: isDeleteMessage,
    );
    // 删除会话时是否同时删除本地的历史消息。
    return await EMClient.getInstance.chatManager
        .deleteConversation(conversationId, deleteMessages: isDeleteMessage);
  }

  //删除某个会话消息
  static Future<void> delConOneMessage(
      String conversationId, String msgId) async {
    EMConversation? conversation =
        await EMClient.getInstance.chatManager.getConversation(
      conversationId,
    );
    conversation?.deleteMessage(msgId);
  }

  static Future<EMMessage> sendTxtMessage(
    String chatId,
    String msgContent,
  ) async {
    var msg =
        EMMessage.createTxtSendMessage(targetId: chatId, content: msgContent);
    final message = await EMClient.getInstance.chatManager.sendMessage(
      msg,
    );
    return message;
  }

// USER_LOGIN_ANOTHER_DEVICE 206 账号在其它手机登录
  static void addGlobalEmcMessageListener() {
    EMClient.getInstance.chatManager.addEventHandler(
        appKey,
        EMChatEventHandler(onMessagesReceived: (messages) {
          for (var msg in messages) {
            Get.find<MessageListController>().newMessageReceive(msg);
            switch (msg.body.type) {
              case MessageType.TXT:
                {
                  EMTextMessageBody body = msg.body as EMTextMessageBody;
                  _addLogToConsole(
                    "receive text message: ${body.content}, from: ${msg.from}",
                  );
                }
                break;
              case MessageType.LOCATION:
                {
                  _addLogToConsole(
                    "receive location message, from: ${msg.from}",
                  );
                }
                break;
              case MessageType.VOICE:
                {
                  _addLogToConsole(
                    "receive voice message, from: ${msg.from}",
                  );
                }
                break;
              case MessageType.FILE:
                {
                  _addLogToConsole(
                    "receive image message, from: ${msg.from}",
                  );
                }
                break;
              case MessageType.CUSTOM:
                EmcHelper.handleCallMessage(msg);
                break;
            }
          }
        }, onCmdMessagesReceived: (messages) {
          for (var msg in messages) {
            switch (msg.body.type) {
              case MessageType.CMD:
                {
                  handleCmdMessage(msg);
                }
                break;
            }
          }
        }));
  }

  static void removeGlobalMessageListener() {
    logger.i("removePushListener");
    EMClient.getInstance.chatManager.removeEventHandler(appKey);
  }

  static Future<EMMessage> sendAudioMessage(
      String token, String channelId, String targetUid) async {
    final mineInfo = GStorage.getMineUserBasic();
    Map<String, String> body = {
      "type": CustomEvent.AUDIO,
      "token": token,
      "channelId": channelId,
      "from": "${getMineUID()}",
      "mineAvatar": "${mineInfo?.avatar}",
      "mineName": "${mineInfo?.cname}",
      "to": targetUid,
    };
    var msg = EMMessage.createCustomSendMessage(
        targetId: targetUid, event: CustomEvent.AUDIO, params: body);
    final message = await EMClient.getInstance.chatManager.sendMessage(
      msg,
    );
    return message;
  }

  static Future<EMMessage> sendVideoMessage(
      String token, String channelId, String targetUid) async {
    final mineInfo = GStorage.getMineUserBasic();
    Map<String, String> body = {
      "type": CustomEvent.VIDEO,
      "token": token,
      "channelId": channelId,
      "from": "${getMineUID()}",
      "mineAvatar": "${mineInfo?.avatar}",
      "mineName": "${mineInfo?.cname}",
      "to": targetUid,
    };
    var msg = EMMessage.createCustomSendMessage(
        targetId: targetUid, event: CustomEvent.VIDEO, params: body);
    final message = await EMClient.getInstance.chatManager.sendMessage(msg);
    return message;
  }

  static Future<EMMessage> sendDisAgreeChatMessage(String targetUid) async {
    logger.i("sendDisAgreeChatMessage$targetUid --${getMineUID()}");
    final message = await EMClient.getInstance.chatManager.sendMessage(
        EMMessage.createCmdSendMessage(
            targetId: targetUid, action: CMD_Action.DIS_AGREE_CHAT));
    return message;
  }

  static Future<EMMessage> sendCancelChatMessage(String targetUid) async {
    final message = await EMClient.getInstance.chatManager.sendMessage(
        EMMessage.createCmdSendMessage(
            targetId: targetUid, action: CMD_Action.CANCEL_CHAT));
    return message;
  }

  static void handleCmdMessage(EMMessage emMessage) {
    switch (emMessage.body.type) {
      case MessageType.CMD:
        {
          EMCmdMessageBody body = emMessage.body as EMCmdMessageBody;
          logger.i('CMD message ->$body');
          switch (body.action) {
            case CMD_Action.DIS_AGREE_CHAT:
              if (_curPageIsChatPage()) {
                MyToast.show("对方拒绝通话");
                Get.back();
              }
              break;
            case CMD_Action.CANCEL_CHAT:
              if (_curPageIsChatPage()) {
                // MyToast.show("对方取消通话");
                Get.back();
              }
              break;
          }
        }
        break;
    }
  }

  static bool _curPageIsChatPage() {
    return Get.currentRoute == "/VideoChatPage" ||
        Get.currentRoute == "/VoiceChatPage" ||
        Get.currentRoute == "VideoChatPage" ||
        Get.currentRoute == "VoiceChatPage";
  }

  static bool handleCallMessage(EMMessage emMessage) {
    bool isNeedShowMessage = true;
    switch (emMessage.body.type) {
      case MessageType.CUSTOM:
        {
          EMCustomMessageBody body = emMessage.body as EMCustomMessageBody;
          int fromId = int.parse(body.params?["from"] ?? "0");
          CallBean callBean = CallBean(uid: fromId);
          callBean.token = body.params?["token"] ?? "";
          callBean.channelId = body.params?["channelId"] ?? "";
          callBean.userAvator = body.params?["mineAvatar"] ?? "";
          callBean.userName = body.params?["mineName"] ?? "";
          callBean.isReceive = true;
          switch (body.event) {
            case CustomEvent.VIDEO:
              Get.to(VideoChatPage(callBean: callBean));
              break;
            case CustomEvent.AUDIO:
              Get.to(VoiceChatPage(callBean: callBean));
              break;
          }
        }
        break;
    }
    return isNeedShowMessage;
  }
}

class CustomEvent {
  static const String VIDEO = "Video";
  static const String AUDIO = "Audio";
}

class CMD_Action {
  //拒绝通话
  static const String DIS_AGREE_CHAT = "disAgreeChat";

  //取消通话
  static const String CANCEL_CHAT = "cancelChat";
}
