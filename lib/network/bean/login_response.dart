/// uid : 164027
/// status : 0
/// token : "Z61MGSySvrjmwlv0LCT8qAmHsw9XDGCj"
/// cname : "null"
/// avatar : "null"
/// birthday : "0000-00-00"
/// sex : 0
/// balance : "0.00"
/// region : "null"
/// age : 0
/// svip : 0
/// constellation : "null"
/// show_sex1 : 1
/// show_sex2 : 1
/// video_call : 20
/// voice_call : 10
/// lang : ["四川","四川"]
/// comment : ["四川","四川"]
/// chat_content : ["四川","四川"]
/// messages_receiving : 1

class LoginResponse {
  LoginResponse({
    int? uid,
    int? status,
    String? token,
    String? cname,
    String? avatar,
    String? birthday,
    num? sex,
    String? balance,
    String? region,
    num? age,
    num? svip,
    String? constellation,
    num? showSex1,
    num? showSex2,
    num? videoCall,
    num? voiceCall,
    List<String>? lang,
    List<String>? comment,
    List<String>? chatContent,
    num? messagesReceiving,
  }) {
    _uid = uid;
    _status = status;
    _token = token;
    _cname = cname;
    _avatar = avatar;
    _birthday = birthday;
    _sex = sex;
    _balance = balance;
    _region = region;
    _age = age;
    _svip = svip;
    _constellation = constellation;
    _showSex1 = showSex1;
    _showSex2 = showSex2;
    _videoCall = videoCall;
    _voiceCall = voiceCall;
    _lang = lang;
    _comment = comment;
    _chatContent = chatContent;
    _messagesReceiving = messagesReceiving;
  }

  LoginResponse.fromJson(dynamic json) {
    _uid = json['uid'];
    _status = json['status'];
    _token = json['token'];
    _cname = json['cname'];
    _avatar = json['avatar'];
    _birthday = json['birthday'];
    _sex = json['sex'];
    _balance = json['balance'];
    _region = json['region'];
    _age = json['age'];
    _svip = json['svip'];
    _constellation = json['constellation'];
    _showSex1 = json['show_sex1'];
    _showSex2 = json['show_sex2'];
    _videoCall = json['video_call'];
    _voiceCall = json['voice_call'];
    _lang = json['lang'] != null ? json['lang'].cast<String>() : [];
    _comment = json['comment'] != null ? json['comment'].cast<String>() : [];
    _chatContent =
        json['chat_content'] != null ? json['chat_content'].cast<String>() : [];
    _messagesReceiving = json['messages_receiving'];
  }
  int? _uid;
  int? _status;
  String? _token;
  String? _cname;
  String? _avatar;
  String? _birthday;
  num? _sex;
  String? _balance;
  String? _region;
  num? _age;
  num? _svip;
  String? _constellation;
  num? _showSex1;
  num? _showSex2;
  num? _videoCall;
  num? _voiceCall;
  List<String>? _lang;
  List<String>? _comment;
  List<String>? _chatContent;
  num? _messagesReceiving;

  LoginResponse copyWith({
    int? uid,
    int? status,
    String? token,
    String? cname,
    String? avatar,
    String? birthday,
    num? sex,
    String? balance,
    String? region,
    num? age,
    num? svip,
    String? constellation,
    num? showSex1,
    num? showSex2,
    num? videoCall,
    num? voiceCall,
    List<String>? lang,
    List<String>? comment,
    List<String>? chatContent,
    num? messagesReceiving,
  }) =>
      LoginResponse(
        uid: uid ?? _uid,
        status: status ?? _status,
        token: token ?? _token,
        cname: cname ?? _cname,
        avatar: avatar ?? _avatar,
        birthday: birthday ?? _birthday,
        sex: sex ?? _sex,
        balance: balance ?? _balance,
        region: region ?? _region,
        age: age ?? _age,
        svip: svip ?? _svip,
        constellation: constellation ?? _constellation,
        showSex1: showSex1 ?? _showSex1,
        showSex2: showSex2 ?? _showSex2,
        videoCall: videoCall ?? _videoCall,
        voiceCall: voiceCall ?? _voiceCall,
        lang: lang ?? _lang,
        comment: comment ?? _comment,
        chatContent: chatContent ?? _chatContent,
        messagesReceiving: messagesReceiving ?? _messagesReceiving,
      );

  int? get uid => _uid;

  int? get status => _status;

  String? get token => _token;

  String? get cname => _cname;

  String? get avatar => _avatar;

  String? get birthday => _birthday;

  num? get sex => _sex;

  String? get balance => _balance;

  String? get region => _region;

  num? get age => _age;

  num? get svip => _svip;

  String? get constellation => _constellation;

  num? get showSex1 => _showSex1;

  num? get showSex2 => _showSex2;

  num? get videoCall => _videoCall;

  num? get voiceCall => _voiceCall;

  List<String>? get lang => _lang;

  List<String>? get comment => _comment;

  List<String>? get chatContent => _chatContent;

  num? get messagesReceiving => _messagesReceiving;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['uid'] = _uid;
    map['status'] = _status;
    map['token'] = _token;
    map['cname'] = _cname;
    map['avatar'] = _avatar;
    map['birthday'] = _birthday;
    map['sex'] = _sex;
    map['balance'] = _balance;
    map['region'] = _region;
    map['age'] = _age;
    map['svip'] = _svip;
    map['constellation'] = _constellation;
    map['show_sex1'] = _showSex1;
    map['show_sex2'] = _showSex2;
    map['video_call'] = _videoCall;
    map['voice_call'] = _voiceCall;
    map['lang'] = _lang;
    map['comment'] = _comment;
    map['chat_content'] = _chatContent;
    map['messages_receiving'] = _messagesReceiving;
    return map;
  }
}
