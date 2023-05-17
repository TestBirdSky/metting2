/// id : "533467"

class ChatIdBean {
  ChatIdBean({
      String? id,}){
    _id = id;
}

  ChatIdBean.fromJson(dynamic json) {
    _id = json['id'];
  }
  String? _id;
ChatIdBean copyWith({  String? id,
}) => ChatIdBean(  id: id ?? _id,
);
  String? get id => _id;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    return map;
  }

}