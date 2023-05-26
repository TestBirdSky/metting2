import 'package:im_flutter_sdk/im_flutter_sdk.dart';
import 'package:metting/page/message/message_bean.dart';
import 'package:metting/tool/log.dart';

class EmcHelper {
  static Future<void> initSDK() async {
    EMOptions options = EMOptions(
      appKey: "1100230401164364#demo",
      autoLogin: false,
    );
    await EMClient.getInstance.init(options);
    // 通知sdk ui已经准备好，执行后才会收到`EMChatRoomEventHandler`, `EMContactEventHandler`, `EMGroupEventHandler` 回调。
    await EMClient.getInstance.startCallback();
  }

  static Future<void> signIn(String _userId, String token) async {
    try {
      await EMClient.getInstance.login(_userId, token, false);
      _addLogToConsole("sign in succeed, username: $_userId");
    } on EMError catch (e) {
      _addLogToConsole("sign in failed, e: ${e.code} , ${e.description}");
    }
  }

  static Future<void> signOut() async {
    try {
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

  static Future<void> getAllMessageFromServer() async {
    EMClient.getInstance.chatManager.getConversationsFromServer();
  }

  //获取本地会话消息
  static Future<void> getAllMessage() async {
    final conversations =
        await EMClient.getInstance.chatManager.loadAllConversations();
    List<MessageBean> msgBeanList = [];
    for (var element in conversations) {
      final bean=MessageBean();
      // bean.newMsg= (await element.latestMessage()).from;
      // msgBeanList.add(element.id);
    }
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
  static Future<bool> delConversation(String conversationId) async {
    // 删除会话时是否同时删除服务端的历史消息。
    bool deleteMessage = true;
    EMConversationType conversationType = EMConversationType.Chat;
    await EMClient.getInstance.chatManager.deleteRemoteConversation(
      conversationId,
      conversationType: conversationType,
      isDeleteMessage: deleteMessage,
    );
    // 删除会话时是否同时删除本地的历史消息。
    return await EMClient.getInstance.chatManager
        .deleteConversation(conversationId, deleteMessages: deleteMessage);
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

  void _addChatListener() {
    // 添加消息状态变更监听
    EMClient.getInstance.chatManager.addMessageEvent(
        // ChatMessageEvent 对应的 key。
        "UNIQUE_HANDLER_ID",
        ChatMessageEvent(
          onSuccess: (msgId, msg) {
            _addLogToConsole("send message succeed");
          },
          onProgress: (msgId, progress) {
            _addLogToConsole("send message succeed");
          },
          onError: (msgId, msg, error) {
            _addLogToConsole(
              "send message failed, code: ${error.code}, desc: ${error.description}",
            );
          },
        ));

    // 添加收消息监听
    EMClient.getInstance.chatManager.addEventHandler(
      // EMChatEventHandle 对应的 key。
      "UNIQUE_HANDLER_ID",
      EMChatEventHandler(
        onMessagesReceived: (messages) {
          for (var msg in messages) {
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
                {
                  _addLogToConsole(
                    "receive custom message, from: ${msg.from}",
                  );
                }
                break;
              case MessageType.CMD:
                {
                  // 当前回调中不会有 CMD 类型消息，CMD 类型消息通过 [EMChatEventHandler.onCmdMessagesReceived] 回调接收
                }
                break;
            }
          }
        },
      ),
    );
  }

  void _sendMessage(String chatId, String msgContent) async {
    // if (_chatId.isEmpty || _messageContent.isEmpty) {
    //   _addLogToConsole("single chat id or message content is null");
    //   return;
    // }
    var msg = EMMessage.createTxtSendMessage(
      targetId: chatId,
      content: msgContent,
    );
    final message = await EMClient.getInstance.chatManager.sendMessage(msg);
    var msg1 = EMMessage.createVoiceSendMessage(
        targetId: chatId, filePath: msgContent);
  }
}
