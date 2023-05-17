import 'package:im_flutter_sdk/im_flutter_sdk.dart';
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

  static Future<void> getChatInfo() async {
    EMClient.getInstance.chatManager.getConversationsFromServer();
  }

  static Future<void> getMessageFirst() async {
    final conversations =
        await EMClient.getInstance.chatManager.loadAllConversations();
    for (var element in conversations) {

    }
  }
}
