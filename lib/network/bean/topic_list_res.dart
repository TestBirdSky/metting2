/// id : 11
/// title : "title"
/// color : "ffffffff"

class TopicRes{
  List<TopicBean>? _data;
  List<TopicBean>? get data => _data;

  TopicRes.fromJson(dynamic json) {
    if (json != null) {
      _data = [];
      json.forEach((v) {
        _data?.add(TopicBean.fromJson(v));
      });
    }
  }
}

class TopicBean {
  TopicBean({
    num? id,
    String? title,
    String? color,
  }) {
    _id = id;
    _title = title;
    _color = color;
  }

  TopicBean.fromJson(dynamic json) {
    _id = json['id'];
    _title = json['title'];
    _color = json['color'];
  }

  num? _id;
  String? _title;
  String? _color;

  TopicBean copyWith({
    num? id,
    String? title,
    String? color,
  }) =>
      TopicBean(
        id: id ?? _id,
        title: title ?? _title,
        color: color ?? _color,
      );

  num? get id => _id;

  String? get title => _title;

  String? get color => _color;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['title'] = _title;
    map['color'] = _color;
    return map;
  }


}
