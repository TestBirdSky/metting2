/// data : [{"id":22903,"uid":164027,"content":"11***11","type":1,"mt":0},{"id":22902,"uid":164027,"content":"11***11","type":1,"mt":0}]

class TreadList {
  TreadList({
    List<TreadBean>? data,
  }) {
    _data = data;
  }

  TreadList.fromJson(dynamic json) {
    if (json != null) {
      _data = [];
      json.forEach((v) {
        _data?.add(TreadBean.fromJson(v));
      });
    }
  }

  List<TreadBean>? _data;

  TreadList copyWith({
    List<TreadBean>? data,
  }) =>
      TreadList(
        data: data ?? _data,
      );

  List<TreadBean>? get data => _data;

}

/// id : 22903
/// uid : 164027
/// content : "11***11"
/// type : 1
/// mt : 0

class TreadBean {
  TreadBean({
    num? id,
    num? uid,
    String? content,
    num? type,
    num? mt,
  }) {
    _id = id;
    _uid = uid;
    _content = content;
    _type = type;
    _mt = mt;
  }

  TreadBean.fromJson(dynamic json) {
    _id = json['id'];
    _uid = json['uid'];
    _content = json['content'];
    _type = json['type'];
    _mt = json['mt'];
  }

  num? _id;
  num? _uid;
  String? _content;
  num? _type;
  num? _mt;

  TreadBean copyWith({
    num? id,
    num? uid,
    String? content,
    num? type,
    num? mt,
  }) =>
      TreadBean(
        id: id ?? _id,
        uid: uid ?? _uid,
        content: content ?? _content,
        type: type ?? _type,
        mt: mt ?? _mt,
      );

  num? get id => _id;

  num? get uid => _uid;

  String? get content => _content;

  num? get type => _type;

  num? get mt => _mt;
}
