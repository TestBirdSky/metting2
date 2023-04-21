/// chat_lang : ["普通话","英语","北京话","杭州话","河南话","苏州话","上海话","武汉话","天津话","闽南话","广东话","山东话","四川话","西安话","东北话","南京话","长沙话","南昌话","梅县话","江东话","江南话","江浙话","客家话","白话","广府话","福州话","湖南话","江西话","江浙话"]

class ChatLang {
  ChatLang({
      List<String>? chatLang,}){
    _chatLang = chatLang;
}

  ChatLang.fromJson(dynamic json) {
    _chatLang = json['chat_lang'] != null ? json['chat_lang'].cast<String>() : [];
  }
  List<String>? _chatLang;
ChatLang copyWith({  List<String>? chatLang,
}) => ChatLang(  chatLang: chatLang ?? _chatLang,
);
  List<String>? get chatLang => _chatLang;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['chat_lang'] = _chatLang;
    return map;
  }

}