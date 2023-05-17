/// data : [{"userid":164033,"time":"一个月前","chat_minutes":0,"cname":"Aa**aa","sex":3,"age":33,"avatar":"http://moshengapp.oss-cn-beijing.aliyuncs.com/2023/04/12/33a7c202304122146596721.jpg"},{"userid":164033,"time":"一个月前","chat_minutes":0,"cname":"Aa**aa","sex":3,"age":33,"avatar":"http://moshengapp.oss-cn-beijing.aliyuncs.com/2023/04/12/33a7c202304122146596721.jpg"},{"userid":164033,"time":"一个月前","chat_minutes":4,"cname":"Aa**aa","sex":3,"age":33,"avatar":"http://moshengapp.oss-cn-beijing.aliyuncs.com/2023/04/12/33a7c202304122146596721.jpg"},{"userid":164033,"time":"一个月前","chat_minutes":2,"cname":"Aa**aa","sex":3,"age":33,"avatar":"http://moshengapp.oss-cn-beijing.aliyuncs.com/2023/04/12/33a7c202304122146596721.jpg"},{"userid":164033,"time":"一个月前","chat_minutes":0,"cname":"Aa**aa","sex":3,"age":33,"avatar":"http://moshengapp.oss-cn-beijing.aliyuncs.com/2023/04/12/33a7c202304122146596721.jpg"}]

class CallChatHistoryList {
  CallChatHistoryList({
    List<HistoryBean>? data,
  }) {
    _data = data;
  }

  CallChatHistoryList.fromJson(dynamic json) {
    if (json != null) {
      _data = [];
      json.forEach((v) {
        _data?.add(HistoryBean.fromJson(v));
      });
    }
  }

  List<HistoryBean>? _data;

  CallChatHistoryList copyWith({
    List<HistoryBean>? data,
  }) =>
      CallChatHistoryList(
        data: data ?? _data,
      );

  List<HistoryBean>? get data => _data;
}

/// userid : 164033
/// time : "一个月前"
/// chat_minutes : 0
/// cname : "Aa**aa"
/// sex : 3
/// age : 33
/// avatar : "http://moshengapp.oss-cn-beijing.aliyuncs.com/2023/04/12/33a7c202304122146596721.jpg"

class HistoryBean {
  HistoryBean({
    num? userid,
    String? time,
    num? chatMinutes,
    String? cname,
    num? sex,
    num? age,
    String? avatar,
  }) {
    _userid = userid;
    _time = time;
    _chatMinutes = chatMinutes;
    _cname = cname;
    _sex = sex;
    _age = age;
    _avatar = avatar;
  }

  HistoryBean.fromJson(dynamic json) {
    _userid = json['userid'];
    _time = json['time'];
    _chatMinutes = json['chat_minutes'];
    _cname = json['cname'];
    _sex = json['sex'];
    _age = json['age'];
    _avatar = json['avatar'];
  }

  num? _userid;
  String? _time;
  num? _chatMinutes;
  String? _cname;
  num? _sex;
  num? _age;
  String? _avatar;

  HistoryBean copyWith({
    num? userid,
    String? time,
    num? chatMinutes,
    String? cname,
    num? sex,
    num? age,
    String? avatar,
  }) =>
      HistoryBean(
        userid: userid ?? _userid,
        time: time ?? _time,
        chatMinutes: chatMinutes ?? _chatMinutes,
        cname: cname ?? _cname,
        sex: sex ?? _sex,
        age: age ?? _age,
        avatar: avatar ?? _avatar,
      );

  num? get userid => _userid;

  String? get time => _time;

  num? get chatMinutes => _chatMinutes;

  String? get cname => _cname;

  num? get sex => _sex;

  num? get age => _age;

  String? get avatar => _avatar;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['userid'] = _userid;
    map['time'] = _time;
    map['chat_minutes'] = _chatMinutes;
    map['cname'] = _cname;
    map['sex'] = _sex;
    map['age'] = _age;
    map['avatar'] = _avatar;
    return map;
  }
}
