import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:metting/page/login/login.dart';

import '../tool/account_utils.dart';
import '../widget/dialog_alert.dart';

Future<int?> showVideoPriceDialog({int price = 40}) {
  List<int> listMoney = [];
  int index = 2;
  for (int i = 20; i <= 100; i += 10) {
    listMoney.add(i);
    if (price == i) {
      index = listMoney.length - 1;
    }
  }
  return _showDialogChoicePrice(listMoney, index)
      .then((value) => value == null ? value : listMoney[value]);
}

Future<int?> showVoicePriceDialog({int price = 30}) {
  List<int> listMoney = [];
  int index = 2;
  for (int i = 10; i <= 80; i += 10) {
    listMoney.add(i);
    if (price == i) {
      index = listMoney.length - 1;
    }
  }
  return _showDialogChoicePrice(listMoney, index)
      .then((value) => value == null ? value : listMoney[value]);
}

Future<int?> _showDialogChoicePrice(List<int> listMoney, int index) {
  final list = <Widget>[];
  for (int i = 0; i < listMoney.length; i++) {
    list.add(
      Container(
        height: 40.h,
        child: Align(
            alignment: Alignment.center, child: Text('${listMoney[i]}金币')),
      ),
    );
  }
  return _showListWheelDialog(list, index, title: '选择价格');
}

Future<int?> showWaitTimeDialog(int time) {
  final list = <Widget>[];
  int index = 0;
  final listInt = [1, 2, 4, 8, 12, 24, 48];
  for (int i = 0; i < listInt.length; i++) {
    final cur = listInt[i];
    if (cur == time) index = i;
    list.add(
      Container(
        height: 40.h,
        child: Align(alignment: Alignment.center, child: Text('$cur小时')),
      ),
    );
  }
  return _showListWheelDialog(list, index)
      .then((value) => value == null ? null : listInt[value]);
}

Future<int?> _showListWheelDialog(List<Widget> list, int index,
    {String title = ''}) {
  FixedExtentScrollController hourScrollController =
      FixedExtentScrollController(initialItem: index);
  return Get.dialog(
    barrierColor: Color(0x00000000),
    barrierDismissible: true,
    useSafeArea: false,
    Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        height: 260.h,
        color: Colors.grey.shade100,
        child: Column(
          children: [
            Container(
              height: 40.h,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Row(
                  children: [
                    InkWell(
                      child: Text(
                        '取消',
                        style: TextStyle(color: Colors.black, fontSize: 16.sp),
                      ),
                      onTap: () {
                        Get.back();
                      },
                    ),
                    Expanded(
                        child: Text(title,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.black, fontSize: 18.sp))),
                    InkWell(
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
            SizedBox(
              height: 20.h,
            ),
            Container(
              height: 150.h,
              child: Stack(
                children: [
                  Align(
                    child: Container(
                      height: 40.h,
                      color: Color(0x18fec693),
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

void showAccountOfflineDialog() {
  final context = Get.context;
  if (context != null) {
    commonAlertD(context, "你的账号已在其它设备登录", "确认", title: "下线通知",
        positiveCall: () {
      Get.offAll(LoginPage());
    });
  }
}
