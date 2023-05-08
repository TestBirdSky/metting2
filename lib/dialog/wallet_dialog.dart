import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:metting/tool/view_tools.dart';

import '../core/common_configure.dart';
import '../network/bean/pay_list_response.dart';

class WalletDialog {
  int curSelectedItem = 1;

  Future<dynamic> showDialog(List<RechargeBean> list, int money) {
    return Get.dialog(
      barrierColor: Color(0x00000000),
      barrierDismissible: true,
      useSafeArea: false,
      Align(
        alignment: Alignment.bottomCenter,
        child: Container(
          height: 270.h,
          decoration: BoxDecoration(
            color: C.bottomDialogBgColor,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12.w),
                topRight: Radius.circular(12.w)),
          ),
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.only(top: 16.h),
                child: Text(
                  '金币充值',
                  style: TextStyle(color: Colors.black, fontSize: 16.sp),
                ),
              ),
              SizedBox(
                height: 10.h,
              ),
              Row(
                children: [
                  Text(
                    '余额',
                    style: TextStyle(color: Colors.black, fontSize: 12.sp),
                  ),
                  Text(
                    '$money',
                    style: TextStyle(color: C.FEC693, fontSize: 12.sp),
                  ),
                  Text(
                    '金币',
                    style: TextStyle(color: Colors.black, fontSize: 12.sp),
                  ),
                ],
              ),
              SizedBox(
                height: 10.h,
              ),
              StatefulBuilder(builder: (context, state) {
                return GridView.count(
                  crossAxisCount: 3,
                  crossAxisSpacing: 10.w,
                  mainAxisSpacing: 12.h,
                  children: _list(list, state),
                );
              }),
              const Expanded(child: SizedBox()),
              _payBtn(),
              SizedBox(
                height: 24.h,
              )
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _list(List<RechargeBean> listBean, state) {
    final list = <Widget>[];
    for (int i = 0; i < listBean.length; i++) {
      RechargeBean bean = listBean[i];
      list.add(GestureDetector(
        onTap: () {
          curSelectedItem = i;
          state(() {});
        },
        child: _item(bean, i == curSelectedItem),
      ));
    }
    return list;
  }

  Widget _item(RechargeBean bean, bool isChecked) {
    return Container(
      height: 46.w,
      width: 72.w,
      child: Stack(
        children: [
          Image.asset(
            getImagePath(
                isChecked ? 'ic_wallete_checked' : 'ic_wallete_unchecked'),
            height: 46.w,
            width: 72.w,
          ),
          Column(
            children: [
              SizedBox(
                height: 8.h,
              ),
              Row(
                children: [
                  Text(
                    '${bean.diamondQuantity}',
                    style: TextStyle(color: Colors.black, fontSize: 12.sp),
                  ),
                  Text(
                    '金币',
                    style: TextStyle(color: Colors.grey, fontSize: 10.sp),
                  ),
                ],
              ),
              SizedBox(
                height: 16.h,
              ),
              Text(
                '¥${bean.money}',
                style: TextStyle(color: Colors.grey, fontSize: 10.sp),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _payBtn() {
    return Container(
      height: 40.w,
      child: TextButton(
          onPressed: () {},
          child: Text(
            '立即支付',
            style: TextStyle(color: Colors.white, fontSize: 14.sp),
          ),
          style: ButtonStyle(
              enableFeedback: false,
              backgroundColor: MaterialStateProperty.all(Color(0xffFEC693)),
              shape: MaterialStateProperty.all(
                RoundedRectangleBorder(
                  // side: BorderSide(   Padding(padding: EdgeInsets.only(top: 16.h)),
                  //   width: 0.5,
                  //   color: MyColor.BtnNormalColor,
                  // ),
                  borderRadius: BorderRadius.circular(24),
                ),
              ))),
    );
  }
}
