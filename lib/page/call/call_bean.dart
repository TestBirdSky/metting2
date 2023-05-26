class CallBean {
  CallBean(
      {required this.userAvator, required this.userName, required this.uid});

  String userAvator;
  String userName;
  String? channelId;
  num uid;
  int callType = 2;
}

// enum CallType {
//
// }