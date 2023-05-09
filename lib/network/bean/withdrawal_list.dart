/// data : [{"id":1,"number":290,"money":"20.00","status":1},{"id":2,"number":700,"money":"50.00","status":1},{"id":3,"number":1400,"money":"100.00","status":1},{"id":4,"number":2800,"money":"200.00","status":1},{"id":5,"number":6750,"money":"500.00","status":1},{"id":6,"number":13500,"money":"1000.00","status":1}]
class WithdrawalList {
  WithdrawalList({
      List<WithdrawalBean>? data,}){
    _data = data;
}

  WithdrawalList.fromJson(dynamic json) {
    if (json != null) {
      _data = [];
      json.forEach((v) {
        _data?.add(WithdrawalBean.fromJson(v));
      });
    }
  }
  List<WithdrawalBean>? _data;
WithdrawalList copyWith({  List<WithdrawalBean>? data,
}) => WithdrawalList(  data: data ?? _data,
);
  List<WithdrawalBean>? get data => _data;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (_data != null) {
      map['data'] = _data?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

/// id : 1
/// number : 290
/// money : "20.00"
/// status : 1

class WithdrawalBean {
  WithdrawalBean({
      num? id, 
      num? number, 
      String? money, 
      num? status,}){
    _id = id;
    _number = number;
    _money = money;
    _status = status;
}

  WithdrawalBean.fromJson(dynamic json) {
    _id = json['id'];
    _number = json['number'];
    _money = json['money'];
    _status = json['status'];
  }
  num? _id;
  num? _number;
  String? _money;
  num? _status;
WithdrawalBean copyWith({  num? id,
  num? number,
  String? money,
  num? status,
}) => WithdrawalBean(  id: id ?? _id,
  number: number ?? _number,
  money: money ?? _money,
  status: status ?? _status,
);
  num? get id => _id;
  num? get number => _number;
  String? get money => _money;
  num? get status => _status;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['number'] = _number;
    map['money'] = _money;
    map['status'] = _status;
    return map;
  }

}