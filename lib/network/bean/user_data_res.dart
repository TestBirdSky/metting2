/// uid : 164027
/// cname : "Aces"
/// avatar : "null"
/// birthday : "0000-00-00"
/// sex : 0
/// region : "成都市"
/// age : 0
/// svip : 0
/// constellation : "null"
/// video_call : 20
/// voice_call : 10
/// lang : ["222"]
/// comment : ["222"]
/// chat_content : ["111"]
/// isAnchor : 0

class UserDataRes {
  UserDataRes({
      num? uid, 
      String? cname, 
      String? avatar, 
      String? birthday, 
      num? sex, 
      String? region, 
      num? age, 
      num? svip, 
      String? constellation, 
      num? videoCall, 
      num? voiceCall, 
      List<String>? lang, 
      List<String>? comment, 
      List<String>? chatContent, 
      num? isAnchor,}){
    _uid = uid;
    _cname = cname;
    _avatar = avatar;
    _birthday = birthday;
    _sex = sex;
    _region = region;
    _age = age;
    _svip = svip;
    _constellation = constellation;
    _videoCall = videoCall;
    _voiceCall = voiceCall;
    _lang = lang;
    _comment = comment;
    _chatContent = chatContent;
    _isAnchor = isAnchor;
}

  UserDataRes.fromJson(dynamic json) {
    _uid = json['uid'];
    _cname = json['cname'];
    _avatar = json['avatar'];
    _birthday = json['birthday'];
    _sex = json['sex'];
    _region = json['region'];
    _age = json['age'];
    _svip = json['svip'];
    _constellation = json['constellation'];
    _videoCall = json['video_call'];
    _voiceCall = json['voice_call'];
    _lang = json['lang'] != null ? json['lang'].cast<String>() : [];
    _comment = json['comment'] != null ? json['comment'].cast<String>() : [];
    _chatContent = json['chat_content'] != null ? json['chat_content'].cast<String>() : [];
    _isAnchor = json['isAnchor'];
  }
  num? _uid;
  String? _cname;
  String? _avatar;
  String? _birthday;
  num? _sex;
  String? _region;
  num? _age;
  num? _svip;
  String? _constellation;
  num? _videoCall;
  num? _voiceCall;
  List<String>? _lang;
  List<String>? _comment;
  List<String>? _chatContent;
  num? _isAnchor;
UserDataRes copyWith({  num? uid,
  String? cname,
  String? avatar,
  String? birthday,
  num? sex,
  String? region,
  num? age,
  num? svip,
  String? constellation,
  num? videoCall,
  num? voiceCall,
  List<String>? lang,
  List<String>? comment,
  List<String>? chatContent,
  num? isAnchor,
}) => UserDataRes(  uid: uid ?? _uid,
  cname: cname ?? _cname,
  avatar: avatar ?? _avatar,
  birthday: birthday ?? _birthday,
  sex: sex ?? _sex,
  region: region ?? _region,
  age: age ?? _age,
  svip: svip ?? _svip,
  constellation: constellation ?? _constellation,
  videoCall: videoCall ?? _videoCall,
  voiceCall: voiceCall ?? _voiceCall,
  lang: lang ?? _lang,
  comment: comment ?? _comment,
  chatContent: chatContent ?? _chatContent,
  isAnchor: isAnchor ?? _isAnchor,
);
  num? get uid => _uid;
  String? get cname => _cname;
  String? get avatar => _avatar;
  String? get birthday => _birthday;
  num? get sex => _sex;
  String? get region => _region;
  num? get age => _age;
  num? get svip => _svip;
  String? get constellation => _constellation;
  num? get videoCall => _videoCall;
  num? get voiceCall => _voiceCall;
  List<String>? get lang => _lang;
  List<String>? get comment => _comment;
  List<String>? get chatContent => _chatContent;
  num? get isAnchor => _isAnchor;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['uid'] = _uid;
    map['cname'] = _cname;
    map['avatar'] = _avatar;
    map['birthday'] = _birthday;
    map['sex'] = _sex;
    map['region'] = _region;
    map['age'] = _age;
    map['svip'] = _svip;
    map['constellation'] = _constellation;
    map['video_call'] = _videoCall;
    map['voice_call'] = _voiceCall;
    map['lang'] = _lang;
    map['comment'] = _comment;
    map['chat_content'] = _chatContent;
    map['isAnchor'] = _isAnchor;
    return map;
  }

}