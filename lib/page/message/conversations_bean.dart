import 'package:im_flutter_sdk/im_flutter_sdk.dart';

import '../../tool/date_utils.dart';
import '../../tool/emc_helper.dart';

class ConversationBean {
  String? avator;
  String? name;
  String id = "";
  EMMessage? newMsg;
  int unReadCount = 0;

  String getShowMsg() {
    final body = newMsg?.body;
    switch (body?.type) {
      case MessageType.TXT:
        return (body as EMTextMessageBody).content;
      case MessageType.VOICE:
        return "[语音]";
      case MessageType.IMAGE:
        return "[图片]";
      case MessageType.VIDEO:
        return "[视频]";
      case MessageType.FILE:
        return "[文件]";
      case MessageType.CUSTOM:
        final b = (body as EMCustomMessageBody);
        switch (b.event) {
          case CustomEvent.VIDEO:
            return "[视频通话]";
          case CustomEvent.AUDIO:
            return "[语音通话]";
        }
        break;
      default:
        return "[未知消息]";
        break;
    }
    return "";
  }

  String getShowTime() {
    return DateTools.getHomeMessageTime(newMsg?.serverTime ?? 0);
  }

  MessageStatus msgStatus() {
    return newMsg?.status ?? MessageStatus.FAIL;
  }

  Future<void> updateConversation(EMConversation element) async {
    newMsg = await element.latestMessage();
    unReadCount = await element.unreadCount();
    id = element.id;
  }

  String getUnReadCount() {
    return unReadCount == 0
        ? ""
        : unReadCount > 99
            ? "99"
            : "$unReadCount";
  }
}
