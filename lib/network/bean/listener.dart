/// uid : 163881
/// avatar : "http://moshengapp.oss-cn-beijing.aliyuncs.com/2022/07/25/08603202207250432167382.jpg"
/// cname : "阿猴我就"
/// sex : 1
/// age : 18
/// lang : [""]
/// comment : [""]
/// chat_content : [""]
/// video_call : 30
/// voice_call : 20
/// province : "福建省"
/// region : "莆田市"

class ListenerList {
  ListenerList({
    List<ListenerRes>? data,}) {
    _data = data;
  }

  ListenerList.fromJson(dynamic json) {
    if (json != null) {
      _data = [];
      json.forEach((v) {
        _data?.add(ListenerRes.fromJson(v));
      });
    }
  }

  List<ListenerRes>? _data;

  ListenerList copyWith({ List<ListenerRes>? data,
  }) =>
      ListenerList(data: data ?? _data,
      );

  List<ListenerRes>? get data => _data;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (_data != null) {
      map['data'] = _data?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

class ListenerRes {
  ListenerRes({
    num? uid,
    String? avatar,
    String? cname,
    num? sex,
    num? age,
    List<String>? lang,
    List<String>? comment,
    List<String>? chatContent,
    num? videoCall,
    num? voiceCall,
    String? province,
    String? region,}) {
    _uid = uid;
    _avatar = avatar;
    _cname = cname;
    _sex = sex;
    _age = age;
    _lang = lang;
    _comment = comment;
    _chatContent = chatContent;
    _videoCall = videoCall;
    _voiceCall = voiceCall;
    _province = province;
    _region = region;
  }

  ListenerRes.fromJson(dynamic json) {
    _uid = json['uid'];
    _avatar = json['avatar'];
    _cname = json['cname'];
    _sex = json['sex'];
    _age = json['age'];
    _lang = json['lang'] != null ? json['lang'].cast<String>() : [];
    _comment = json['comment'] != null ? json['comment'].cast<String>() : [];
    _chatContent =
    json['chat_content'] != null ? json['chat_content'].cast<String>() : [];
    _videoCall = json['video_call'];
    _voiceCall = json['voice_call'];
    _province = json['province'];
    _region = json['region'];
  }

  num? _uid;
  String? _avatar;
  String? _cname;
  num? _sex;
  num? _age;
  List<String>? _lang;
  List<String>? _comment;
  List<String>? _chatContent;
  num? _videoCall;
  num? _voiceCall;
  String? _province;
  String? _region;

  ListenerRes copyWith({ num? uid,
    String? avatar,
    String? cname,
    num? sex,
    num? age,
    List<String>? lang,
    List<String>? comment,
    List<String>? chatContent,
    num? videoCall,
    num? voiceCall,
    String? province,
    String? region,
  }) =>
      ListenerRes(
        uid: uid ?? _uid,
        avatar: avatar ?? _avatar,
        cname: cname ?? _cname,
        sex: sex ?? _sex,
        age: age ?? _age,
        lang: lang ?? _lang,
        comment: comment ?? _comment,
        chatContent: chatContent ?? _chatContent,
        videoCall: videoCall ?? _videoCall,
        voiceCall: voiceCall ?? _voiceCall,
        province: province ?? _province,
        region: region ?? _region,
      );

  num? get uid => _uid;

  String? get avatar => _avatar;

  String? get cname => _cname;

  num? get sex => _sex;

  num? get age => _age;

  List<String>? get lang => _lang;

  List<String>? get comment => _comment;

  List<String>? get chatContent => _chatContent;

  num? get videoCall => _videoCall;

  num? get voiceCall => _voiceCall;

  String? get province => _province;

  String? get region => _region;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['uid'] = _uid;
    map['avatar'] = _avatar;
    map['cname'] = _cname;
    map['sex'] = _sex;
    map['age'] = _age;
    map['lang'] = _lang;
    map['comment'] = _comment;
    map['chat_content'] = _chatContent;
    map['video_call'] = _videoCall;
    map['voice_call'] = _voiceCall;
    map['province'] = _province;
    map['region'] = _region;
    return map;
  }

  String getSexString() {
    if (sex == 1) {
      return "男";
    } else {
      return "女";
    }
  }
}