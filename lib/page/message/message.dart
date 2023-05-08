import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../base/BaseController.dart';
import '../../base/BaseUiPage.dart';
import '../../core/common_configure.dart';

class MessagePage extends BaseUiPage<MessagePageC> {
  MessagePage() : super(title: "消息");

  @override
  Widget? backWidget() {
    return null;
  }

  @override
  Widget createBody(BuildContext context) {
    return Center(
      child: Text("Home$title"),
    );
  }

  @override
  MessagePageC initController() => MessagePageC();

  @override
  List<Widget>? action() {
    return [
      GetBuilder<MessagePageC>(
          id: "switch",
          builder: (c) {
            return Padding(
              padding:  EdgeInsets.symmetric(horizontal: 16.w),
              child: CupertinoSwitch(
                  activeColor: C.FEC693,
                  value: c.isOpenMessageNotification,
                  onChanged: (onChanged) async {

                  }),
            );
          })
    ];
  }
}

class MessagePageC extends BaseController {
  bool isOpenMessageNotification = false;

}
