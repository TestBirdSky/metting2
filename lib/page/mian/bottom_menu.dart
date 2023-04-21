import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../tool/view_tools.dart';

class MainBottomMenu extends StatelessWidget {
  final ValueChanged<int>? onTap;
  int index;

  MainBottomMenu(this.index, this.onTap) : super();

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 56.h,
        margin: EdgeInsets.symmetric(horizontal: 16.w,vertical: 24.h),
        decoration: BoxDecoration(
            border: Border.all(color: Color(0xff82361B),width: 1.h),
            color: Color(0xb313181e),
            borderRadius: BorderRadius.all(Radius.circular(16.w))),
        child: Row(
          children: [
            Expanded(
                child: InkWell(
              onTap: () {
                onTap?.call(0);
              },
              child: getItemWidget(0),
            )),
            Expanded(
                child: InkWell(
              onTap: () {
                onTap?.call(1);
              },
              child: getItemWidget(1),
            )),
            Expanded(
                child: InkWell(
              onTap: () {
                onTap?.call(2);
              },
              child: getItemWidget(2),
            )),
            Expanded(
                child: InkWell(
              onTap: () {
                onTap?.call(3);
              },
              child: getItemWidget(3),
            )),
          ],
        ));
  }

  Widget getItemWidget(int curIndex) {
    if (index == curIndex) {
      return _selectedItem[curIndex];
    } else {
      return _unSelectedItem[curIndex];
    }
  }

  final List<Widget> _selectedItem = [
    Image.asset(
      getImagePath("home_selected"),
    ),
    Image.asset(
      getImagePath("heart_selected"),
    ),
    Image.asset(
      getImagePath("message_selected"),
    ),
    Image.asset(
      getImagePath("mine_selected"),
    ),
  ];
  final List<Widget> _unSelectedItem = [
    Image.asset(
      getImagePath("ic_home_unselected"),
    ),
    Image.asset(
      getImagePath("heart_unselected"),
    ),
    Image.asset(
      getImagePath("message_unselected"),
    ),
    Image.asset(
      getImagePath("mine_un"),
    ),
  ];
}
