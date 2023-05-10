import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:metting/tool/view_tools.dart';

import '../core/common_configure.dart';

class CreateTreadDialog {
  int _itemIndex = 0;
  final TextEditingController _controllerInput = TextEditingController();
  late StateSetter contentState;
  String _voiceCTips = "长按开始录入语音";

  void showDialog() {
    Get.dialog(
        barrierColor: const Color(0x00000000),
        barrierDismissible: false,
        useSafeArea: false,
        Stack(
          children: [
            Column(
              children: [
                Image.asset(getImagePath('ic_tread_close')),
                SizedBox(
                  height: 16.h,
                ),
                Container(
                  padding: EdgeInsets.all(14.w),
                  width: double.infinity,
                  height: 155.h,
                  child: StatefulBuilder(builder: (context, state) {
                    contentState = state;
                    return _itemIndex == 0
                        ? _inputTextTread()
                        : _inputVoiceTread();
                  }),
                ),
                SizedBox(
                  height: 16.h,
                ),
                Container(
                  height: 100.h,
                  width: double.infinity,
                  child: Row(
                    children: [],
                  ),
                  decoration: BoxDecoration(
                      color: Color(0xff1A1B20),
                      border:
                          Border.all(color: Color(0xFF8F3947), width: 1.5.w),
                      borderRadius: BorderRadius.all(Radius.circular(36.w))),
                )
              ],
            ),
          ],
        ));
  }

  Widget _inputTextTread() {
    return Container(
      height: 128.h,
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
          color: Color(0xffCFCFCF),
          borderRadius: BorderRadius.all(Radius.circular(5.w))),
      child: _textFieldInput(),
    );
  }

  Widget _inputVoiceTread() {
    return Container(
      height: 128.h,
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
          color: Color(0xffCFCFCF),
          borderRadius: BorderRadius.all(Radius.circular(5.w))),
      child: Column(
        children: [
          Text(
            _voiceCTips,
            style: TextStyle(color: Colors.white, fontSize: 16.sp),
          ),
          Container(
            height: 78.h,
            child: Image.asset('ic_voice_icon'),
          )
        ],
      ),
    );
  }

  Widget _textFieldInput() {
    return TextField(
      style: TextStyle(
        fontSize: 14.sp,
        color: C.whiteFFFFFF,
      ),
      maxLength: 400,
      maxLines: null,
      decoration: InputDecoration(
        filled: false,
        contentPadding: EdgeInsets.symmetric(vertical: 4.0),
        counterText: '',
        //此处控制最大字符是否显示
        alignLabelWithHint: true,
        hintText: '快来分享您的生活趣事吧！',
        hintStyle: TextStyle(
          fontSize: 14.sp,
          color: Colors.white,
        ),
        enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Color(0x00FEC693), width: 0)),
        focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Color(0x00FEC693), width: 0)),
      ),
      controller: _controllerInput,
    );
  }
}
