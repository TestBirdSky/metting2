/// id : "533514"
/// token : "006dc744c21ab3f44789cee343d95b69ac0IABeCXK2ToKUyAAHt5Ijeyq0wNzzwAEjW3t6u1vW8nF3wth2IyTYdiMkIgBOqgAAW0x0ZAQAAQDAqAAAAwDAqAAAAgDAqAAABADAqAAA"

class ChatIdBean {
  ChatIdBean({
      String? id, 
      String? token,}){
    _id = id;
    _token = token;
}

  ChatIdBean.fromJson(dynamic json) {
    _id = json['id'];
    _token = json['token'];
  }
  String? _id;
  String? _token;
ChatIdBean copyWith({  String? id,
  String? token,
}) => ChatIdBean(  id: id ?? _id,
  token: token ?? _token,
);
  String? get id => _id;
  String? get token => _token;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['token'] = _token;
    return map;
  }

}