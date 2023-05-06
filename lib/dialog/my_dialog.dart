import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

Future<int?> showVoice(List<int> listMoney) {
  return _showDialogChoiceLevel(listMoney).then<int?>((value) =>(){

  });
}

Future<int?> _showDialogChoiceLevel(List<int> listMoney) {
  final list = <Widget>[];
  for (int i = 0; i < listMoney.length; i++) {
    list.add(
      Container(
        height: 40.h,
        child: Align(alignment: Alignment.center, child: Text('$i')),
      ),
    );
  }
  FixedExtentScrollController hourScrollController =
      FixedExtentScrollController(initialItem: 10);
  return Get.dialog(
    barrierColor: Color(0x00000000),
    barrierDismissible: true,
    Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        height: 160.h,
        child: Column(
          children: [
            Container(
              height: 40.h,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Row(
                  children: [
                    GestureDetector(
                      child: Text(
                        '取消',
                        style: TextStyle(color: Colors.black, fontSize: 16.sp),
                      ),
                      onTap: () {
                        Get.back();
                      },
                    ),
                    Expanded(
                        child: Text('',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.black, fontSize: 18.sp))),
                    GestureDetector(
                      child: Text('确定',
                          style: TextStyle(
                              color: Color(0xffFEC693), fontSize: 16.sp)),
                      onTap: () {
                        Get.back(result: hourScrollController.selectedItem);
                      },
                    ),
                  ],
                ),
              ),
            ),
            Container(
              height: 120.h,
              color: Colors.grey.shade100,
              child: Stack(
                children: [
                  Align(
                    child: Container(
                      height: 40.h,
                      color: Colors.grey,
                    ),
                  ),
                  ListWheelScrollView(
                    controller: hourScrollController,
                    physics: FixedExtentScrollPhysics(
                      parent: BouncingScrollPhysics(),
                    ),
                    itemExtent: 40.h,
                    children: list,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
