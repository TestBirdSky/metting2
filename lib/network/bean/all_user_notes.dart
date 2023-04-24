/// uid : 164027
/// avatar : "http://moshengapp.oss-cn-beijing.aliyuncs.com/2023/04/12/33a7c202304122146596721.jpg"
/// list : [{"time":"04-11","content":"啊啊啊啊啊啊啊啊啊"},{"time":"04-11","content":"啊啊啊啊啊啊啊啊啊"},{"time":"04-11","content":"啊啊啊啊啊啊啊啊啊"},{"time":"04-11","content":"啊啊啊啊啊啊啊啊啊"},{"time":"04-11","content":"啊啊啊啊啊啊啊啊啊"}]

class ListUserNotesBean {
  List<UserNotesBean>? _data;
  List<UserNotesBean>? get data => _data;

  ListUserNotesBean.fromJson(dynamic json) {
    if (json!= null) {
      _data = [];
      json.forEach((v) {
        _data?.add(UserNotesBean.fromJson(v));
      });
    }
  }


}

class UserNotesBean {
  UserNotesBean({
    num? uid,
    String? avatar,
    List<ListInfo>? list,
  }) {
    _uid = uid;
    _avatar = avatar;
    _list = list;
  }

  UserNotesBean.fromJson(dynamic json) {
    _uid = json['uid'];
    _avatar = json['avatar'];
    if (json['list'] != null) {
      _list = [];
      json['list'].forEach((v) {
        _list?.add(ListInfo.fromJson(v));
      });
    }
  }

  num? _uid;
  String? _avatar;
  List<ListInfo>? _list;

  UserNotesBean copyWith({
    num? uid,
    String? avatar,
    List<ListInfo>? list,
  }) =>
      UserNotesBean(
        uid: uid ?? _uid,
        avatar: avatar ?? _avatar,
        list: list ?? _list,
      );

  num? get uid => _uid;

  String? get avatar => _avatar;

  List<ListInfo>? get list => _list;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['uid'] = _uid;
    map['avatar'] = _avatar;
    if (_list != null) {
      map['list'] = _list?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

/// time : "04-11"
/// content : "啊啊啊啊啊啊啊啊啊"

class ListInfo {
  ListInfo({
    String? time,
    String? content,
  }) {
    _time = time;
    _content = content;
  }

  ListInfo.fromJson(dynamic json) {
    _time = json['time'];
    _content = json['content'];
  }

  String? _time;
  String? _content;

  ListInfo copyWith({
    String? time,
    String? content,
  }) =>
      ListInfo(
        time: time ?? _time,
        content: content ?? _content,
      );

  String? get time => _time;

  String? get content => _content;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['time'] = _time;
    map['content'] = _content;
    return map;
  }
}
