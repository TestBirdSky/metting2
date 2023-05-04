import 'package:flutter_easyloading/flutter_easyloading.dart';

class LoadingUtils {


  static Future<void> showLoading({String msg = '加载中...'}) {
    return EasyLoading.show(status: msg);
  }

  static Future<void> showSaveLoading() {
    return EasyLoading.show(status: '保存中...');
  }

  static Future<void> dismiss() {
    return EasyLoading.dismiss();
  }
}
