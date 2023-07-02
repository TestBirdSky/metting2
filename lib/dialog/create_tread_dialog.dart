import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:metting/network/http_helper.dart';
import 'package:metting/tool/log.dart';
import 'package:metting/tool/record_helper.dart';
import 'package:metting/tool/view_tools.dart';
import 'package:metting/widget/loading.dart';
import 'package:metting/widget/my_toast.dart';

import '../core/common_configure.dart';

class CreateTreadDialog {
  RecordAudioHelper? _recordAudioHelper;
  final TextEditingController _controllerInput = TextEditingController();
  late StateSetter _dialogState;
  late StateSetter _recordState;
  int _itemIndex = 0;
  String _voiceCTips = "长按开始录入语音";
  bool _isCollectVoice = false;
  bool _isCanPutTread = false;
  double start = 0.0;
  double offset = 0.0;
  bool isUpCancel = false;
  bool isRecordingVoice = false;
  bool isSelectedCancel = false;

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
                return Align(
                  alignment: Alignment.center,
                  child: SizedBox(
                    height: 336.h,
                    child: Stack(children: [
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.end,
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
                                _closeDialog(isSuccess: false);
                              },
                            ),
                          ),
                          SizedBox(
                            height: 16.h,
                          ),
                          Container(
                            padding: EdgeInsets.all(14.w),
                            width: double.infinity,
                            height: 154.h,
                            decoration: BoxDecoration(
                                color: Colors.black,
                                border: Border.all(
                                    color: Colors.white, width: 1.5.w),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8.w))),
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
                      ),
                      _recordWidget(),
                    ]),
                  ),
                );
              }),
            ],
          ),
        )).then((value) => {logger.i('dialog')});
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
        contentPadding: const EdgeInsets.symmetric(vertical: 0),
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
            _setCanPutTread(_recordAudioHelper?.isHaveRecordFile() == true);
          }
        },
        onVerticalDragStart: (details) {
          logger.i("onVerticalDragStart");
          isUpCancel = false;
          start = details.globalPosition.dy;
        },
        onVerticalDragEnd: (details) {
          logger.i("onVerticalDragEnd $isUpCancel");
          if (isUpCancel) {
            _recordAudioHelper?.cancelRecording();
          } else {
            _recordEnd();
          }
          isRecordingVoice = false;
          isSelectedCancel = false;
          _recordState(() {});
        },
        onVerticalDragUpdate: (details) {
          logger.i("onVerticalDragUpdate $start  $offset");
          offset = details.globalPosition.dy;
          isUpCancel = start - offset > 60.h ? true : false;
          // controller.updateCancleStatus(isUpCancel);
          if (isUpCancel != isSelectedCancel) {
            isSelectedCancel = isUpCancel;
            _recordState(() {});
          }
        },
        onLongPress: () {
          logger.i('messageon LongPress');
          if (_itemIndex == 1) {
            _recordAudioHelper ??= RecordAudioHelper();
            _recordAudioHelper?.startRecorder();
            isRecordingVoice = true;
            _recordState(() {});
          }
        },
        // onLongPressUp: () {
        //   logger.i('onLongPressUp');
        //   _isCollectVoice = false;
        //   _dialogState(() {});
        //   _recordAudioHelper?.stopRecording1().then((value) =>
        //       _setCanPutTread(_recordAudioHelper?.isHaveRecordFile() == true));
        // },
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

  void _recordEnd() async {
    isRecordingVoice = false;
    final filePath = await _recordAudioHelper?.stopRecording();
    if (filePath != null) {
      LoadingUtils.showLoading(msg: "发布中...");
      final data = await addVoiceTrends(_recordAudioHelper!.recordAudioFile!,
          _recordAudioHelper!.recorderTime);
      if (data.isOk()) {
        MyToast.show('发布成功');
        _closeDialog();
      } else {
        MyToast.show('发布失败');
      }
      LoadingUtils.dismiss();
    }
  }

  Widget _recordWidget() {
    return StatefulBuilder(builder: (context, state) {
      _recordState = state;
      return isRecordingVoice
          ? Stack(
              children: [
                Padding(
                  padding: EdgeInsets.only(bottom: 140.h),
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          isSelectedCancel ? "松开 取消" : '',
                          style:
                              TextStyle(color: Colors.white, fontSize: 16.sp),
                        ),
                        SizedBox(
                          height: 10.h,
                        ),
                        ClipOval(
                          child: isSelectedCancel
                              ? Container(
                                  width: 100.h,
                                  height: 100.h,
                                  color: Colors.white,
                                  child: Icon(
                                    Icons.clear,
                                    color: Colors.black,
                                    size: 40.h,
                                  ),
                                )
                              : Container(
                                  width: 80.h,
                                  height: 80.h,
                                  color: Colors.grey,
                                  child: Icon(Icons.clear,
                                      color: Colors.white, size: 36.h),
                                ),
                        ),
                      ],
                    ),
                  ),
                ),
                // Align(
                //     alignment: Alignment.bottomCenter,
                //     child: Column(
                //       mainAxisSize: MainAxisSize.min,
                //       crossAxisAlignment: CrossAxisAlignment.center,
                //       children: [
                //         Text(
                //           isSelectedCancel ? '' : "松开 发送",
                //           style:
                //               TextStyle(color: Colors.white, fontSize: 16.sp),
                //         ),
                //         SizedBox(
                //           height: 10.h,
                //         ),
                //         Container(
                //           width: double.infinity,
                //           height: 106.h,
                //           padding: EdgeInsets.only(top: 10.h),
                //           alignment: Alignment.topCenter,
                //           child: Text(
                //             "录音中...",
                //             style:
                //                 TextStyle(color: Colors.black, fontSize: 22.sp),
                //           ),
                //           decoration: BoxDecoration(
                //             color: Colors.white,
                //             borderRadius: BorderRadius.only(
                //                 topRight: Radius.circular(56.w),
                //                 topLeft: Radius.circular(56.w)),
                //           ),
                //         ),
                //       ],
                //     ))
              ],
            )
          : Text('');
    });
  }

  Widget _viewBtn(String path) {
    return Expanded(
      flex: 1,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 10.w),
        width: 80.h,
        height: 80.h,
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
        _closeDialog();
      } else {
        MyToast.show('发布失败');
      }
      LoadingUtils.dismiss();
    } /*else if (_recordAudioHelper?.recordAudioFile != null) {
      LoadingUtils.showSaveLoading();
      final data = await addVoiceTrends(_recordAudioHelper!.recordAudioFile!,
          _recordAudioHelper!.recorderTime);
      if (data.isOk()) {
        MyToast.show('发布成功');
        _closeDialog();
      } else {
        MyToast.show('发布失败');
      }
      LoadingUtils.dismiss();
    }*/
  }

  void _closeDialog({bool isSuccess = true}) {
    _recordAudioHelper?.destroy();
    _isCollectVoice = false;
    _itemIndex = 0;
    if (isSuccess) initV();
    Get.back();
  }

  void initV() {
    _isCanPutTread = false;
    _controllerInput.clear();
  }
}
