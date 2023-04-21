import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../tool/view_tools.dart';

void showInfoDialog() {
  Get.dialog(Container(
    margin: EdgeInsets.symmetric(vertical: 64.h, horizontal: 20.w),
    decoration: BoxDecoration(
      color: const Color(0xff13181E),
      borderRadius: BorderRadius.all(Radius.circular(12.w)),
    ),
    child: Stack(
      children: [
        SizedBox(
          height: 360.h,
          child: Container(
            color: Colors.amberAccent,
          ),
          // child: CachedNetworkImage(
          //   fit: BoxFit.cover,
          //   imageUrl: 'url',
          // )
        ),
        Container(
            width: 203.w,
            height: 203.h,
            margin: EdgeInsets.only(top: 157.h),
            padding: EdgeInsets.all(8.w),
            decoration: BoxDecoration(
              color: Color(0x8013181E),
              borderRadius: BorderRadius.all(Radius.circular(5.w)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 4.h,
                ),
                Text(
                  '交流评语:',
                  style: TextStyle(
                      color: Color(0xffF7BB76),
                      fontSize: 12.sp,
                      decoration: TextDecoration.none),
                ),
                SizedBox(
                  height: 2.h,
                ),
                Text(
                  '人很好 很随和  声音好听  声音好听   声音好听',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 10.sp,
                      decoration: TextDecoration.none),
                ),
                SizedBox(
                  height: 4.h,
                ),
                Text(
                  '聊天话题:',
                  style: TextStyle(
                      color: Color(0xffF7BB76),
                      fontSize: 12.sp,
                      decoration: TextDecoration.none),
                ),
                SizedBox(
                  height: 2.h,
                ),
                Text(
                  '情感  家庭  生活  生活  生活  生活  生活   生活  生活  生活  生活  生活  生活  生活   生活',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 10.sp,
                      decoration: TextDecoration.none),
                ),
                SizedBox(
                  height: 6.h,
                ),
                _widgetDialect([
                  "1",
                  "2",
                  "1222",
                  "2333",
                  "1111",
                  "2333",
                ]),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '姓名',
                      style: TextStyle(
                          color: Color(0xffB5B4B4),
                          fontSize: 16.sp,
                          decoration: TextDecoration.none),
                    ),
                    Text(
                      '32-女',
                      style: TextStyle(
                          color: Color(0xffB5B4B4),
                          fontSize: 12.sp,
                          decoration: TextDecoration.none),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Text('成都市双流区',
                        style: TextStyle(
                            color: Color(0xffB5B4B4),
                            fontSize: 12.sp,
                            decoration: TextDecoration.none))
                  ],
                )
              ],
            )),
        Align(
          alignment: Alignment.centerRight,
          child: GestureDetector(
            onTap: () {},
            child: Image.asset(
              getImagePath('mine_phone'),
              width: 52.w,
              height: 52.w,
            ),
          ),
        ),

      ],
    ),
  ));
}

Widget _widgetDialect(List<String> dialectList) {
  final list = <Widget>[];
  for (var element in dialectList) {
    list.add(Container(
      decoration: BoxDecoration(
          color: Color(0xFFFEC693),
          // border: Border.all(color: Colors.white, width: 1.w),
          borderRadius: BorderRadius.all(Radius.circular(2.w))),
      margin: EdgeInsets.only(right: 6.w, bottom: 4.h),
      padding: EdgeInsets.symmetric(horizontal: 4.w),
      child: Text(element,
          style: TextStyle(
              fontSize: 10.sp,
              color: Colors.black,
              decoration: TextDecoration.none)),
    ));
  }
  return Wrap(
    spacing: 4.w,
    children: list,
  );
}
