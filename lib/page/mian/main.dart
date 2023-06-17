import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:metting/page/listener/listener.dart';
import 'package:metting/page/message/message.dart';
import 'package:metting/tool/emc_helper.dart';

import '../../base/BaseController.dart';
import '../../base/BaseStatelessPage.dart';
import '../home/home.dart';
import '../mine/mine.dart';
import 'bottom_menu.dart';

class MainPage extends BaseStatelessPage<MainC> {
  final List<Widget> _pageList = [
    HomePage(),
    ListenerPage(),
    MessagePage(),
    MinePage(),
  ];

  @override
  Widget createBody(BuildContext context) {
    return GetBuilder<MainC>(
        id: "select",
        builder: (c) {
          return Stack(
            children: [
              IndexedStack(
                index: controller.curSelected,
                children: _pageList,
              ),
              Expanded(
                  child: Align(
                alignment: Alignment.bottomCenter,
                child: MainBottomMenu(controller.curSelected, (int index) {
                  c.setSelected(index);
                }),
              ))
            ],
          );
        });
  }

  @override
  MainC initController() => MainC();
}

class MainC extends BaseController {
  var curSelected = 0;

  @override
  void onInit() {
    super.onInit();
    EmcHelper.addGlobalEmcMessageListener();
  }

  @override
  void onClose() {
    super.onClose();
    EmcHelper.removeGlobalMessageListener();
  }

  void setSelected(int index) {
    curSelected = index;
    update(['select']);
  }
}
