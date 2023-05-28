import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../core/common_configure.dart';

BoxDecoration shape() {
  return BoxDecoration(
      color: Color(0xFFFEC693),
      border: Border.all(color: Color(0xFFFEC693), width: 1.w),
      borderRadius: BorderRadius.all(Radius.circular(5.w)));
}
void test(){
  final TextEditingController _controllerCode = TextEditingController();

  TextField(
    maxLength: 4,
    keyboardType: TextInputType.number,
    style: TextStyle(
      fontSize: 18.sp,
      color: C.whiteFFFFFF,
    ),
    decoration: InputDecoration(
      filled: false,
      contentPadding: const EdgeInsets.symmetric(vertical: 4.0),
      counterText: '',
//此处控制最大字符是否显示
      alignLabelWithHint: true,
      hintText: '请输入验证码',
      hintStyle: TextStyle(
        fontSize: 18.sp,
        color: C.grey8C8C8C,
      ),
      enabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Color(0xffFEC693), width: 1)),
      focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Color(0xffFEC693), width: 1)),
    ),
    onChanged: (value) {},
    // controller: _controllerCode,
  ) ;
}
