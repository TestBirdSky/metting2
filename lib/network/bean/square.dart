/// data : [{"id":3,"type":1,"describe":"aaaaaaa","price":30,"topic":["四川话","普通话"],"uid":164027,"avatar":"http://moshengapp.oss-cn-beijing.aliyuncs.com/2023/04/12/33a7c202304122146596721.jpg","cname":"Aa**aa","sex":3,"age":33,"lang":["北京话"],"province":"四川省","region":"成都市"}]

class SquareRes {
  SquareRes({
      List<SquareBean>? data,}){
    _data = data;
}

  SquareRes.fromJson(dynamic json) {
    if (json!= null) {
      _data = [];
      json.forEach((v) {
        _data?.add(SquareBean.fromJson(v));
      });
    }
  }
  List<SquareBean>? _data;
SquareRes copyWith({  List<SquareBean>? data,
}) => SquareRes(  data: data ?? _data,
);
  List<SquareBean>? get data => _data;


}

/// id : 3
/// type : 1
/// describe : "aaaaaaa"
/// price : 30
/// topic : ["四川话","普通话"]
/// uid : 164027
/// avatar : "http://moshengapp.oss-cn-beijing.aliyuncs.com/2023/04/12/33a7c202304122146596721.jpg"
/// cname : "Aa**aa"
/// sex : 3
/// age : 33
/// lang : ["北京话"]
/// province : "四川省"
/// region : "成都市"

class SquareBean {
  SquareBean({
      num? id, 
      num? type, 
      String? describe, 
      num? price, 
      List<String>? topic, 
      num? uid, 
      String? avatar, 
      String? cname, 
      num? sex, 
      num? age, 
      List<String>? lang, 
      String? province, 
      String? region,}){
    _id = id;
    _type = type;
    _describe = describe;
    _price = price;
    _topic = topic;
    _uid = uid;
    _avatar = avatar;
    _cname = cname;
    _sex = sex;
    _age = age;
    _lang = lang;
    _province = province;
    _region = region;
}

  SquareBean.fromJson(dynamic json) {
    _id = json['id'];
    _type = json['type'];
    _describe = json['describe'];
    _price = json['price'];
    _topic = json['topic'] != null ? json['topic'].cast<String>() : [];
    _uid = json['uid'];
    _avatar = json['avatar'];
    _cname = json['cname'];
    _sex = json['sex'];
    _age = json['age'];
    _lang = json['lang'] != null ? json['lang'].cast<String>() : [];
    _province = json['province'];
    _region = json['region'];
  }
  num? _id;
  num? _type;
  String? _describe;
  num? _price;
  List<String>? _topic;
  num? _uid;
  String? _avatar;
  String? _cname;
  num? _sex;
  num? _age;
  List<String>? _lang;
  String? _province;
  String? _region;
SquareBean copyWith({  num? id,
  num? type,
  String? describe,
  num? price,
  List<String>? topic,
  num? uid,
  String? avatar,
  String? cname,
  num? sex,
  num? age,
  List<String>? lang,
  String? province,
  String? region,
}) => SquareBean(  id: id ?? _id,
  type: type ?? _type,
  describe: describe ?? _describe,
  price: price ?? _price,
  topic: topic ?? _topic,
  uid: uid ?? _uid,
  avatar: avatar ?? _avatar,
  cname: cname ?? _cname,
  sex: sex ?? _sex,
  age: age ?? _age,
  lang: lang ?? _lang,
  province: province ?? _province,
  region: region ?? _region,
);
  num? get id => _id;
  num? get type => _type;
  String? get describe => _describe;
  num? get price => _price;
  List<String>? get topic => _topic;
  num? get uid => _uid;
  String? get avatar => _avatar;
  String? get cname => _cname;
  num? get sex => _sex;
  num? get age => _age;
  List<String>? get lang => _lang;
  String? get province => _province;
  String? get region => _region;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['type'] = _type;
    map['describe'] = _describe;
    map['price'] = _price;
    map['topic'] = _topic;
    map['uid'] = _uid;
    map['avatar'] = _avatar;
    map['cname'] = _cname;
    map['sex'] = _sex;
    map['age'] = _age;
    map['lang'] = _lang;
    map['province'] = _province;
    map['region'] = _region;
    return map;
  }

}