import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:metting/base/BaseStatelessPage.dart';

import '../core/common_configure.dart';

abstract class BaseUiPage<T> extends BaseStatelessPage<T> {
  String title;

  BaseUiPage({super.key, required this.title});

  @override
  AppBar? appBarWidget() {
    return AppBar(
      centerTitle: true,
      leading: backWidget(),
      actions: action(),
      title: titleWidget(),
      backgroundColor: C.blackColor,
    );
  }

  Widget? titleWidget() {
    return Text(
      title,
      style: TextStyle(color: C.whiteFFFFFF, fontSize: 18.sp),
    );
  }

  Widget? backWidget() {
    return IconButton(
        icon: Icon(Icons.chevron_left, size: 38.h, color: Colors.white),
        onPressed: onBack);
  }

  void onBack() {
    Get.back();
  }

  List<Widget>? action(){
    return null;
  }
}
