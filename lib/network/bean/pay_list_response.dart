/// data : [{"diamondQuantity":80,"describe":"80","money":12,"iosKey":"recharge_12"},{"diamondQuantity":210,"describe":"210","money":30,"iosKey":"recharge_30"},{"diamondQuantity":450,"describe":"450","money":68,"iosKey":"recharge_68"},{"diamondQuantity":750,"describe":"750","money":108,"iosKey":"recharge_108"},{"diamondQuantity":1870,"describe":"1870","money":268,"iosKey":"recharge_268"},{"diamondQuantity":4100,"describe":"4100","money":588,"iosKey":"recharge_588"}]

class PayListResponse {
  PayListResponse({
      List<RechargeBean>? data,}){
    _data = data;
}

  PayListResponse.fromJson(dynamic json) {
    if (json != null) {
      _data = [];
      json.forEach((v) {
        _data?.add(RechargeBean.fromJson(v));
      });
    }
  }
  List<RechargeBean>? _data;
PayListResponse copyWith({  List<RechargeBean>? data,
}) => PayListResponse(  data: data ?? _data,
);
  List<RechargeBean>? get data => _data;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (_data != null) {
      map['data'] = _data?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

/// diamondQuantity : 80
/// describe : "80"
/// money : 12
/// iosKey : "recharge_12"

class RechargeBean {
  RechargeBean({
      num? diamondQuantity, 
      String? describe, 
      num? money, 
      String? iosKey,}){
    _diamondQuantity = diamondQuantity;
    _describe = describe;
    _money = money;
    _iosKey = iosKey;
}

  RechargeBean.fromJson(dynamic json) {
    _diamondQuantity = json['diamondQuantity'];
    _describe = json['describe'];
    _money = json['money'];
    _iosKey = json['iosKey'];
  }
  num? _diamondQuantity;
  String? _describe;
  num? _money;
  String? _iosKey;
RechargeBean copyWith({  num? diamondQuantity,
  String? describe,
  num? money,
  String? iosKey,
}) => RechargeBean(  diamondQuantity: diamondQuantity ?? _diamondQuantity,
  describe: describe ?? _describe,
  money: money ?? _money,
  iosKey: iosKey ?? _iosKey,
);
  num? get diamondQuantity => _diamondQuantity;
  String? get describe => _describe;
  num? get money => _money;
  String? get iosKey => _iosKey;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['diamondQuantity'] = _diamondQuantity;
    map['describe'] = _describe;
    map['money'] = _money;
    map['iosKey'] = _iosKey;
    return map;
  }

}