/// id : 22893
/// content : "八月你好"
/// type : 1
/// mt : 0
/// uid : 163844
/// avatar : "http://moshengapp.oss-cn-beijing.aliyuncs.com/2022/07/12/1bf67202207122143523241.jpg"
/// cname : "南京囡囡"
/// sex : 2
/// age : 21
/// lang : [""]
/// video_call : 30
/// voice_call : 20
/// isAnchor : 1
/// province : "江苏省"
/// region : "南京市"

class FrontResponse {
  FrontResponse({
      num? id, 
      String? content, 
      num? type, 
      num? mt, 
      num? uid, 
      String? avatar, 
      String? cname, 
      num? sex, 
      num? age, 
      List<String>? lang, 
      num? videoCall, 
      num? voiceCall, 
      num? isAnchor, 
      String? province, 
      String? region,}){
    _id = id;
    _content = content;
    _type = type;
    _mt = mt;
    _uid = uid;
    _avatar = avatar;
    _cname = cname;
    _sex = sex;
    _age = age;
    _lang = lang;
    _videoCall = videoCall;
    _voiceCall = voiceCall;
    _isAnchor = isAnchor;
    _province = province;
    _region = region;
}

  List<FrontResponse>? _data;
  List<FrontResponse>? get data => _data;

  FrontResponse.fromListJson(dynamic json) {
    if (json!= null) {
       _data = [];
      json.forEach((v) {
        _data?.add(FrontResponse.fromJson(v));
      });
    }
  }

  FrontResponse.fromJson(dynamic json) {
    _id = json['id'];
    _content = json['content'];
    _type = json['type'];
    _mt = json['mt'];
    _uid = json['uid'];
    _avatar = json['avatar'];
    _cname = json['cname'];
    _sex = json['sex'];
    _age = json['age'];
    _lang = json['lang'] != null ? json['lang'].cast<String>() : [];
    _videoCall = json['video_call'];
    _voiceCall = json['voice_call'];
    _isAnchor = json['isAnchor'];
    _province = json['province'];
    _region = json['region'];
  }
  num? _id;
  String? _content;
  num? _type;
  num? _mt;
  num? _uid;
  String? _avatar;
  String? _cname;
  num? _sex;
  num? _age;
  List<String>? _lang;
  num? _videoCall;
  num? _voiceCall;
  num? _isAnchor;
  String? _province;
  String? _region;
FrontResponse copyWith({  num? id,
  String? content,
  num? type,
  num? mt,
  num? uid,
  String? avatar,
  String? cname,
  num? sex,
  num? age,
  List<String>? lang,
  num? videoCall,
  num? voiceCall,
  num? isAnchor,
  String? province,
  String? region,
}) => FrontResponse(  id: id ?? _id,
  content: content ?? _content,
  type: type ?? _type,
  mt: mt ?? _mt,
  uid: uid ?? _uid,
  avatar: avatar ?? _avatar,
  cname: cname ?? _cname,
  sex: sex ?? _sex,
  age: age ?? _age,
  lang: lang ?? _lang,
  videoCall: videoCall ?? _videoCall,
  voiceCall: voiceCall ?? _voiceCall,
  isAnchor: isAnchor ?? _isAnchor,
  province: province ?? _province,
  region: region ?? _region,
);
  num? get id => _id;
  String? get content => _content;
  num? get type => _type;
  num? get mt => _mt;
  num? get uid => _uid;
  String? get avatar => _avatar;
  String? get cname => _cname;
  num? get sex => _sex;
  num? get age => _age;
  List<String>? get lang => _lang;
  num? get videoCall => _videoCall;
  num? get voiceCall => _voiceCall;
  num? get isAnchor => _isAnchor;
  String? get province => _province;
  String? get region => _region;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['content'] = _content;
    map['type'] = _type;
    map['mt'] = _mt;
    map['uid'] = _uid;
    map['avatar'] = _avatar;
    map['cname'] = _cname;
    map['sex'] = _sex;
    map['age'] = _age;
    map['lang'] = _lang;
    map['video_call'] = _videoCall;
    map['voice_call'] = _voiceCall;
    map['isAnchor'] = _isAnchor;
    map['province'] = _province;
    map['region'] = _region;
    return map;
  }

}