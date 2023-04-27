/// nicName : "娇气演变戒指"

class RandomNickname {
  RandomNickname({
      String? nicName,}){
    _nicName = nicName;
}

  RandomNickname.fromJson(dynamic json) {
    _nicName = json['nicName'];
  }
  String? _nicName;
RandomNickname copyWith({  String? nicName,
}) => RandomNickname(  nicName: nicName ?? _nicName,
);
  String? get nicName => _nicName;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['nicName'] = _nicName;
    return map;
  }

}