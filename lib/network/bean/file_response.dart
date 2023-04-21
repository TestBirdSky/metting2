/// url : "http://moshengapp.oss-cn-beijing.aliyuncs.com/2023/04/12/66e4e202304122023535049.jpg"

class FileResponse {
  FileResponse({
    String? url,
  }) {
    _url = url;
  }

  FileResponse.fromJson(dynamic json) {
    _url = json['url'];
  }

  String? _url;

  FileResponse copyWith({
    String? url,
  }) =>
      FileResponse(
        url: url ?? _url,
      );

  String? get url => _url;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['url'] = _url;
    return map;
  }
}
