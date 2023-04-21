import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../base/BaseController.dart';
import '../../base/BaseUiPage.dart';
import '../../tool/log.dart';
import '../../widget/image_m.dart';

class MessagePage extends BaseUiPage<MessagePageC> {
  MessagePage() : super(title: "消息");

  @override
  Widget? backWidget() {
    return null;
  }

  @override
  Widget createBody(BuildContext context) {
    logger.i("Home$title");
    return Center(
      child: Text("Home$title"),
    );
  }

  @override
  MessagePageC initController() => MessagePageC();

  Widget _item(String url, String title, String content, String time) {
    return Container(
      height: 56.h,
      child: Row(
        children: [
          cardNetworkImage(url, 46.w, 46.w),
          Expanded(child:    Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                title,
                style: TextStyle(color: Colors.white, fontSize: 18.sp),
              ),
              SizedBox(
                height: 5.h,
              ),
              Text(
                content,
                style: TextStyle(color: Colors.white, fontSize: 14.sp),
              ),
            ],
          )),
          Text(time,
            style: TextStyle(color: Colors.white, fontSize: 12.sp),)
        ],
      ),
      padding: EdgeInsets.symmetric(horizontal: 16.w),
    );
  }
}

class MessagePageC extends BaseController {}
