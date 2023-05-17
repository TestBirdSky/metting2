/// data : {"list":[{"id":2,"uid":164033,"number":700,"money":"50.00","order_no":null,"time":"2023-05-16 20:32","status":"待审核"},{"id":1,"uid":164033,"number":700,"money":"50.00","order_no":null,"time":"2023-04-13 10:38","status":"提现成功"}],"sum":50}

class WithdrawalHistoryRes {
  WithdrawalHistoryRes({
    WithdrawalHistoryBean? data,
  }) {
    _data = data;
  }

  WithdrawalHistoryRes.fromJson(dynamic json) {
    _data = json != null ? WithdrawalHistoryBean.fromJson(json) : null;
  }

  WithdrawalHistoryBean? _data;

  WithdrawalHistoryRes copyWith({
    WithdrawalHistoryBean? data,
  }) =>
      WithdrawalHistoryRes(
        data: data ?? _data,
      );

  WithdrawalHistoryBean? get data => _data;
}

/// list : [{"id":2,"uid":164033,"number":700,"money":"50.00","order_no":null,"time":"2023-05-16 20:32","status":"待审核"},{"id":1,"uid":164033,"number":700,"money":"50.00","order_no":null,"time":"2023-04-13 10:38","status":"提现成功"}]
/// sum : 50

class WithdrawalHistoryBean {
  WithdrawalHistoryBean({
    List<WithdrawalBean>? list,
    num? sum,
  }) {
    _list = list;
    _sum = sum;
  }

  WithdrawalHistoryBean.fromJson(dynamic json) {
    if (json['list'] != null) {
      _list = [];
      json['list'].forEach((v) {
        _list?.add(WithdrawalBean.fromJson(v));
      });
    }
    _sum = json['sum'];
  }

  List<WithdrawalBean>? _list;
  num? _sum;

  WithdrawalHistoryBean copyWith({
    List<WithdrawalBean>? list,
    num? sum,
  }) =>
      WithdrawalHistoryBean(
        list: list ?? _list,
        sum: sum ?? _sum,
      );

  List<WithdrawalBean>? get list => _list;

  num? get sum => _sum;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (_list != null) {
      map['list'] = _list?.map((v) => v.toJson()).toList();
    }
    map['sum'] = _sum;
    return map;
  }
}

/// id : 2
/// uid : 164033
/// number : 700
/// money : "50.00"
/// order_no : null
/// time : "2023-05-16 20:32"
/// status : "待审核"

class WithdrawalBean {
  WithdrawalBean({
    num? id,
    num? uid,
    num? number,
    String? money,
    dynamic orderNo,
    String? time,
    String? status,
  }) {
    _id = id;
    _uid = uid;
    _number = number;
    _money = money;
    _orderNo = orderNo;
    _time = time;
    _status = status;
  }

  WithdrawalBean.fromJson(dynamic json) {
    _id = json['id'];
    _uid = json['uid'];
    _number = json['number'];
    _money = json['money'];
    _orderNo = json['order_no'];
    _time = json['time'];
    _status = json['status'];
  }

  num? _id;
  num? _uid;
  num? _number;
  String? _money;
  dynamic _orderNo;
  String? _time;
  String? _status;

  WithdrawalBean copyWith({
    num? id,
    num? uid,
    num? number,
    String? money,
    dynamic orderNo,
    String? time,
    String? status,
  }) =>
      WithdrawalBean(
        id: id ?? _id,
        uid: uid ?? _uid,
        number: number ?? _number,
        money: money ?? _money,
        orderNo: orderNo ?? _orderNo,
        time: time ?? _time,
        status: status ?? _status,
      );

  num? get id => _id;

  num? get uid => _uid;

  num? get number => _number;

  String? get money => _money;

  dynamic get orderNo => _orderNo;

  String? get time => _time;

  String? get status => _status;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['uid'] = _uid;
    map['number'] = _number;
    map['money'] = _money;
    map['order_no'] = _orderNo;
    map['time'] = _time;
    map['status'] = _status;
    return map;
  }
}
