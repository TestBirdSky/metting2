/// id : 28
/// time : "15:18"
/// content : "啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊"
/// uid : 164027
/// date : "04月11"

class ListNoteDetail {
  List<NoteDetailsBean>? _data;

  List<NoteDetailsBean>? get data => _data;

  ListNoteDetail.fromJson(dynamic json) {
    if (json != null) {
      _data = [];
      json.forEach((v) {
        _data?.add(NoteDetailsBean.fromJson(v));
      });
    }
  }
}

class NoteDetailsBean {
  NoteDetailsBean({
    num? id,
    String? time,
    String? content,
    num? uid,
    String? date,
  }) {
    _id = id;
    _time = time;
    _content = content;
    _uid = uid;
    _date = date;
  }

  NoteDetailsBean.fromJson(dynamic json) {
    _id = json['id'];
    _time = json['time'];
    _content = json['content'];
    _uid = json['uid'];
    _date = json['date'];
  }

  num? _id;
  String? _time;
  String? _content;
  num? _uid;
  String? _date;

  NoteDetailsBean copyWith({
    num? id,
    String? time,
    String? content,
    num? uid,
    String? date,
  }) =>
      NoteDetailsBean(
        id: id ?? _id,
        time: time ?? _time,
        content: content ?? _content,
        uid: uid ?? _uid,
        date: date ?? _date,
      );

  num? get id => _id;

  String? get time => _time;

  String? get content => _content;

  num? get uid => _uid;

  String? get date => _date;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['time'] = _time;
    map['content'] = _content;
    map['uid'] = _uid;
    map['date'] = _date;
    return map;
  }
}
