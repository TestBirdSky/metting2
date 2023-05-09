import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:metting/tool/view_tools.dart';

class CreateTreadDialog {
  int _itemIndex = 0;

  void showDialog() {
    Get.dialog(
        Column(
      children: [Image.asset(getImagePath('name')), Container()],
    ));
  }
}
