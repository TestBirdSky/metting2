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

  void onInit(){

  }

  @override
  Widget build(BuildContext context) {
    controller = Get.put(initController());
    mContext = context;
    onInit();
    return _createWidget(context);
  }

  Widget _createWidget(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget(),
      backgroundColor: pageBackgroundColor(),
      body: createBody(context),
    );
  }

  Color pageBackgroundColor(){
    return C.PAGE_THEME_BG;
  }
}
