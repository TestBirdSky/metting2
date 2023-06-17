class CallBean {
  CallBean({this.userAvator = "", this.userName = "", required this.uid});

  String userAvator = "";
  String userName = "";
  String channelId = "";
  String token = "";
  num uid;
  int callType = 2;
  bool isReceive = false;

  @override
  String toString() {
    return "userAvator$userAvator userName$userName  channelId$channelId token$token uid$uid";
  }
}

// enum CallType {
//
// }
