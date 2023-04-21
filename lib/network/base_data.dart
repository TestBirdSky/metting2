const respCodeSuccess = 1;
const errorCodeNetworkError = 404;

class BasePageData<T> {
  BasePageData(this.code, this.msg, this.data);

  num code = 100;
  String msg = '';
  T? data;

  bool isOk() {
    return code == respCodeSuccess;
  }

  @override
  String toString() {
    return 'BasePageData {code=$code  msg=$msg  data=${data.toString()}}';
  }
}

class BaseResp {
  BaseResp({
    dynamic data,
    String? msg,
    num? code,
  }) {
    _data = data;
    _msg = msg;
    _code = code;
  }

  BaseResp.fromJson(dynamic json) {
    _data = json['data'];
    _msg = json['msg'];
    _code = json['code'];
  }

  dynamic _data;
  String? _msg;
  num? _code;

  BaseResp copyWith({
    dynamic data,
    String? msg,
    num? code,
  }) =>
      BaseResp(
        data: data ?? _data,
        msg: msg ?? _msg,
        code: code ?? _code,
      );

  dynamic get data => _data;

  String get msg => _msg ?? "";

  num get code => _code ?? 0;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['data'] = _data;
    map['msg'] = _msg;
    map['code'] = _code;
    return map;
  }

  bool isOk() {
    return code == respCodeSuccess;
  }
}
