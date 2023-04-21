import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'mine.dart';

class MineStory extends GetView<MineC> {
  @override
  String? get tag => "MineC";

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "我的动态",
            textAlign: TextAlign.start,
            style: TextStyle(color: Colors.white, fontSize: 20.sp),
          ),
        ],
      ),
    );
  }
}