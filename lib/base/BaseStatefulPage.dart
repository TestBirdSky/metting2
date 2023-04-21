import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'BaseController.dart';

abstract class BaseStatefulPage extends StatefulWidget{

  @override
  BaseStatefulState createState() => getState();

  ///getState
  BaseStatefulState getState();
}

///基础 state
abstract class BaseStatefulState<T extends BaseStatefulPage, C extends BaseController> extends State<T> {
  late C controller;
  late BuildContext mContext;
  ///initState
  @override
  void initState() {
    initDefaultState();
    super.initState();
  }

  ///dispose
  @override
  void dispose() {
    super.dispose();
    initDefaultDispose();
  }

  @factory
  C initController();


  ///build
  @override
  Widget build(BuildContext context) {
    controller = Get.put(initController());
    mContext = context;
    return initDefaultBuild(context);
  }

  ///界面进入
  void initDefaultState() {

  }

  ///界面销毁
  void initDefaultDispose() {

  }

  ///界面构建
  Widget initDefaultBuild(BuildContext context);
}
