/// svip : 0
/// svipEndTime : ""

class VipBean {
  VipBean({
      num? svip, 
      String? svipEndTime,}){
    _svip = svip;
    _svipEndTime = svipEndTime;
}

  VipBean.fromJson(dynamic json) {
    _svip = json['svip'];
    _svipEndTime = json['svipEndTime'];
  }
  num? _svip;
  String? _svipEndTime;
VipBean copyWith({  num? svip,
  String? svipEndTime,
}) => VipBean(  svip: svip ?? _svip,
  svipEndTime: svipEndTime ?? _svipEndTime,
);
  num? get svip => _svip;
  String? get svipEndTime => _svipEndTime;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['svip'] = _svip;
    map['svipEndTime'] = _svipEndTime;
    return map;
  }

}