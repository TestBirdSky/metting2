import 'package:get/get.dart';

import '../tool/log.dart';

abstract class BaseController extends GetxController {
  @override
  void onReady() {
    logger.i("onReady${this.runtimeType}");
    super.onReady();
  }
}

class NullController extends BaseController{

}
