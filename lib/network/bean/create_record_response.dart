/// id : "533467"

class CreateRecordResponse {
  CreateRecordResponse({
      String? id,}){
    _id = id;
}

  CreateRecordResponse.fromJson(dynamic json) {
    _id = json['id'];
  }
  String? _id;
CreateRecordResponse copyWith({  String? id,
}) => CreateRecordResponse(  id: id ?? _id,
);
  String? get id => _id;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    return map;
  }

}