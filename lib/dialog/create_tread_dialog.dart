import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:metting/network/http_helper.dart';
import 'package:metting/tool/record_helper.dart';
import 'package:metting/tool/view_tools.dart';
import 'package:metting/widget/loading.dart';
import 'package:metting/widget/my_toast.dart';

import '../core/common_configure.dart';

class CreateTreadDialog {
  int _itemIndex = 0;
  final TextEditingController _controllerInput = TextEditingController();
  late StateSetter _dialogState;
  String _voiceCTips = "长按开始录入语音";
  bool _isCollectVoice = false;
  bool _isCanPutTread = false;
  File? audioFile;

  void _setInputListener() {
    _controllerInput.addListener(() {
      _setCanPutTread(_controllerInput.text.isNotEmpty);
    });
  }

  void _setCanPutTread(bool isCanPut) {
    if (_isCanPutTread != isCanPut) {
      _isCanPutTread = isCanPut;
      _dialogState(() {});
    }
  }

  void showDialog() {
    _setInputListener();
    Get.dialog(
        // barrierColor: const Color(0x00000000),
        barrierDismissible: false,
        useSafeArea: false,
        Padding(
          padding: EdgeInsets.all(16.w),
          child: Stack(
            children: [
              StatefulBuilder(builder: (context, state) {
                _dialogState = state;
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Align(
                      alignment: Alignment.centerRight,
                      child: GestureDetector(
                        child: Image.asset(
                          getImagePath('ic_tread_close'),
                          width: 40.h,
                          height: 40.h,
                        ),
                        onTap: () {
                          Get.back();
                        },
                      ),
                    ),
                    SizedBox(
                      height: 16.h,
                    ),
                    Container(
                      padding: EdgeInsets.all(14.w),
                      width: double.infinity,
                      height: 155.h,
                      decoration: BoxDecoration(
                          color: Colors.black,
                          border: Border.all(color: Colors.white, width: 1.5.w),
                          borderRadius: BorderRadius.all(Radius.circular(8.w))),
                      child: _itemIndex == 0
                          ? _inputTextTread()
                          : _inputVoiceTread(),
                    ),
                    SizedBox(
                      height: 16.h,
                    ),
                    Container(
                      height: 100.h,
                      margin: EdgeInsets.symmetric(horizontal: 16.w),
                      width: double.infinity,
                      decoration: BoxDecoration(
                          color: Color(0xff1A1B20),
                          border: Border.all(
                              color: Color(0xFF8F3947), width: 1.5.w),
                          borderRadius:
                              BorderRadius.all(Radius.circular(36.w))),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: _widget(),
                      ),
                    )
                  ],
                );
              }),
            ],
          ),
        ));
  }

  Widget _inputTextTread() {
    return Container(
      height: 128.h,
      padding: EdgeInsets.symmetric(vertical: 6.h, horizontal: 12.w),
      decoration: BoxDecoration(
          color: Color(0xffCFCFCF),
          borderRadius: BorderRadius.all(Radius.circular(5.w))),
      child: _textFieldInput(),
    );
  }

  Widget _inputVoiceTread() {
    return SizedBox(
      height: 128.h,
      child: Column(
        children: [
          Text(
            _voiceCTips,
            style: TextStyle(color: Colors.white, fontSize: 16.sp),
          ),
          Container(
            height: 78.h,
            child: Image.asset(getImagePath('ic_voice_icon')),
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
        enabledBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: Color(0x00FEC693), width: 0)),
        focusedBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: Color(0x00FEC693), width: 0)),
      ),
      controller: _controllerInput,
    );
  }

  List<Widget> _widget() {
    List<Widget> widget = [];
    widget.add(GestureDetector(
        onTap: () {
          if (_itemIndex != 0) {
            _itemIndex = 0;
            _dialogState(() {});
            _setCanPutTread(_controllerInput.text.isNotEmpty);
          }
        },
        child: _viewBtn(
          getImagePath(_itemIndex == 0
              ? "ic_tread_message_selected"
              : "ic_tread_message_unselected"),
        )));
    widget.add(GestureDetector(
        onTap: () {
          if (_itemIndex != 1) {
            _itemIndex = 1;
            _dialogState(() {});
            audioFile?.length().then((value) => _setCanPutTread(value > 0));
          }
        },
        onLongPress: () {
          if (_itemIndex == 1) {
            _isCollectVoice = true;
            RecordAudioHelper.startRecording()
                .then((value) => audioFile = value);
          }
        },
        onLongPressCancel: () {
          _isCollectVoice = false;
          RecordAudioHelper.stopRecording();
        },
        child: _viewBtn(getImagePath(_isCollectVoice
            ? "ic_tread_voice_collect"
            : _itemIndex == 1
                ? "ic_tread_voice_selected"
                : "ic_tread_voice_unselected"))));
    widget.add(GestureDetector(
        onTap: () {
          if (_isCanPutTread) {
            _pullTread();
          }
        },
        child: _viewBtn(getImagePath(
            _isCanPutTread ? "ic_tread_enable" : "ic_tread_unenable"))));
    return widget;
  }

  Widget _viewBtn(String path) {
    return Expanded(
      flex: 1,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 10.w),
        width: 100.h,
        height: 100.h,
        child: Image.asset(
          path,
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  void _pullTread() async {
    if (_itemIndex == 0) {
      LoadingUtils.showSaveLoading();
      final data = await addTextTrends(_controllerInput.text.toString());
      if (data.isOk()) {
        MyToast.show('发布成功');
        Get.back();
      } else {
        MyToast.show('发布失败');
      }
      LoadingUtils.dismiss();
    } else if (audioFile != null) {
      LoadingUtils.showSaveLoading();
      final data = await addVoiceTrends(audioFile!, 2);
      if (data.isOk()) {
        MyToast.show('发布成功');
        Get.back();
      } else {
        MyToast.show('发布失败');
      }
      LoadingUtils.dismiss();
    }
  }
}
