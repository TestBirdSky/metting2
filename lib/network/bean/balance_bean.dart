/// balance : "9980.00"

class BalanceBean {
  BalanceBean({
      String? balance,}){
    _balance = balance;
}

  BalanceBean.fromJson(dynamic json) {
    _balance = json['balance'];
  }
  String? _balance;
BalanceBean copyWith({  String? balance,
}) => BalanceBean(  balance: balance ?? _balance,
);
  String? get balance => _balance;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['balance'] = _balance;
    return map;
  }

}