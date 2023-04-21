import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:metting/core/common_configure.dart';

abstract class BaseStatelessPage<T> extends StatelessWidget {
  late T controller;
  late BuildContext mContext;

  BaseStatelessPage({super.key});

  @factory
  T initController();

  Widget createBody(BuildContext context);

  AppBar? appBarWidget() {
    return null;
  }

  @override
  Widget build(BuildContext context) {
    controller = Get.put(initController());
    mContext = context;
    return _createWidget(context);
  }

  Widget _createWidget(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget(),
      backgroundColor: C.PAGE_THEME_BG,
      body: createBody(context),
    );
  }
}
