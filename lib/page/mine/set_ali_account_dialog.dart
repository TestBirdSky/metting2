import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:metting/widget/loading.dart';

import '../../core/common_configure.dart';
import '../../network/http_helper.dart';
import '../../widget/my_toast.dart';

class SetAliAccountDialog {
  final TextEditingController _controllerName = TextEditingController();
  final TextEditingController _controllerPhone = TextEditingController();

  Future<dynamic> showDialog() {
    return Get.dialog(
      Align(
        alignment: Alignment.bottomCenter,
        child: Container(
          height: 198.h,
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(12.w),
                  topRight: Radius.circular(12.w))),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '户名：',
                    style: TextStyle(color: Color(0xff333333)),
                  ),
                  Expanded(child: _etAliAccountName()),
                ],
              ),
              Container(
                height: 1.h,
                margin: EdgeInsets.symmetric(vertical: 4.h),
                color: Color(0xff515151),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '账号：',
                    style: TextStyle(color: Color(0xff333333)),
                  ),
                  Expanded(child: _etAliAccount()),
                ],
              ),
              Container(
                height: 1.h,
                margin: EdgeInsets.symmetric(vertical: 4.h),
                color: Color(0xff515151),
              ),
              SizedBox(
                width: double.infinity,
                child: TextButton(
                    onPressed: () {
                      _postData();
                    },
                    child: Align(
                      alignment: Alignment.center,
                      child: Text(
                        '确定',
                        style: TextStyle(
                            color: Color(0xff515151), fontSize: 16.sp),
                      ),
                    )),
              )
            ],
          ),
        ),
      ),
      useSafeArea: false,
      barrierDismissible: true,
    );
  }

  Widget _etAliAccount() {
    return Container(
      height: 40.h,
      child: Align(
        alignment: Alignment.centerLeft,
        child: TextField(
          textAlignVertical: TextAlignVertical(y: -0.7),
          style: TextStyle(
            fontSize: 14.sp,
            color: Colors.black,
          ),
          decoration: InputDecoration(
            filled: false,
            contentPadding: EdgeInsets.symmetric(horizontal: 4.0.w),
            counterText: '',
            //此处控制最大字符是否显示
            alignLabelWithHint: true,
            hintText: '支付宝收款账号',
            hintStyle: TextStyle(
              fontSize: 14.sp,
              color: C.grey8C8C8C,
            ),
            enabledBorder: const UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.transparent, width: 0)),
            focusedBorder: const UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.transparent, width: 0)),
          ),
          controller: _controllerPhone,
        ),
      ),
    );
  }

  Widget _etAliAccountName() {
    return SizedBox(
      height: 40.h,
      child: TextField(
        textAlignVertical: TextAlignVertical(y: -0.7),
        style: TextStyle(
          fontSize: 14.sp,
          color: Colors.black,
        ),
        decoration: InputDecoration(
          filled: false,
          contentPadding: EdgeInsets.symmetric(horizontal: 4.0.w),
          counterText: '',
          //此处控制最大字符是否显示
          alignLabelWithHint: true,
          hintText: '支付宝收款人姓名',
          hintStyle: TextStyle(
            fontSize: 14.sp,
            color: C.grey8C8C8C,
          ),
          enabledBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.transparent, width: 0)),
          focusedBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.transparent, width: 0)),
        ),
        controller: _controllerName,
      ),
    );
  }

  void _postData() async {
    String phone = _controllerPhone.text;
    String name = _controllerName.text;
    if (phone.isEmpty || name.isEmpty) {
      return;
    }
    LoadingUtils.showSaveLoading();
    final a = await addAliUser(phone, name);
    if (a.isOk()) {
      Get.back(result: {
        "phone": phone,
        "name": name,
      });
    } else {
      MyToast.show('${a.msg}');
    }
    LoadingUtils.dismiss();
  }
}
