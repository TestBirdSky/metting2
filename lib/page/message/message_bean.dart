import 'package:im_flutter_sdk/im_flutter_sdk.dart';

class MessageBean {
  String? avator;
  String? name;
  String uid = "";
  EMMessage? newMsg;
  int unReadCount = 0;
  String? lastTime;

  String getShowMsg() {
    final body = newMsg?.body;
    if (body != null && body.type == MessageType.TXT) {
      return (body as EMTextMessageBody).content;
    }
    return "";
  }
}
