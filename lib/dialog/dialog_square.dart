import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:metting/database/get_storage_manager.dart';
import 'package:metting/dialog/my_dialog.dart';
import 'package:metting/tool/log.dart';
import 'package:metting/widget/loading.dart';
import 'package:metting/widget/my_toast.dart';

import '../core/common_configure.dart';
import '../network/bean/topic_list_res.dart';
import '../network/http_helper.dart';
import '../widget/custom_text.dart';

class CreateSquare {
  final TextEditingController _controller = TextEditingController();
  int _priceVoice = 10;
  int _priceVideo = 20;
  bool _isVideo = false;
  int _time = 1;
  List<TopicBean> list = getTopicListFGS()?.data ?? [];
  String _topicType = '';

  Future<bool?> showDialog() {
    return Get.dialog(
      Align(
        alignment: Alignment.center,
        child: Container(
          height: 480.h,
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          margin: EdgeInsets.symmetric(horizontal: 20.w),
          decoration: BoxDecoration(
            color: const Color(0xff13181E),
            borderRadius: BorderRadius.all(Radius.circular(12.w)),
          ),
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(vertical: 12.h),
                child: Text(
                  '通话发布',
                  style: TextStyle(color: C.FEC693, fontSize: 14.sp),
                ),
              ),
              _item1(),
              _item2(),
              _item3(),
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.only(top: 24.h, bottom: 12.h),
                  child: Text(
                    '简介：',
                    textAlign: TextAlign.start,
                    style: TextStyle(color: Color(0xffFDFCDD), fontSize: 12.sp),
                  ),
                ),
              ),
              _inputContent(),
              const Expanded(child: SizedBox()),
              _textButtonSure(() {
                _pullSquare();
              }),
              SizedBox(height: 18.h),
            ],
          ),
        ),
      ),
      barrierColor: Color(0x00000000),
      barrierDismissible: true,
    );
  }

  Widget _item1() {
    if (_topicType.isEmpty) {
      if (list.isNotEmpty) {
        _topicType = list[Random().nextInt(list.length)].title ?? "";
      }
    }
    return StatefulBuilder(builder: (context, state) {
      return Container(
        height: 40.h,
        child: Column(
          children: [
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '通话类型：',
                    style: TextStyle(color: Color(0xffFDFCDD), fontSize: 12.sp),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        _choiceTopic(_topicType).then((value) {
                          if (value != null) {
                            _topicType = value;
                            state(() {});
                          }
                        });
                      },
                      child: Text(
                        _topicType,
                        textAlign: TextAlign.end,
                        style: TextStyle(color: Colors.white, fontSize: 12.sp),
                      ),
                    ),
                  )
                ],
              ),
            ),
            SizedBox(
              height: 4.h,
            ),
            Container(
              height: 1.h,
              color: Color(0xffF2F2F2),
            )
          ],
        ),
      );
    });
  }

  Widget _item2() {
    return Container(
        height: 80.h,
        child: StatefulBuilder(builder: (context, state) {
          return Column(
            children: [
              SizedBox(
                height: 40.h,
                child: Column(
                  children: [
                    Expanded(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            '通话出价：',
                            style: TextStyle(
                                color: Color(0xffFDFCDD), fontSize: 12.sp),
                          ),
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                if (_isVideo) {
                                  showVideoPriceDialog(price: _priceVideo)
                                      .then((value) {
                                    logger.i(value);
                                    if (value != null) {
                                      _priceVideo = value;
                                      state(() {});
                                    }
                                  });
                                } else {
                                  showVoicePriceDialog(price: _priceVoice)
                                      .then((value) {
                                    if (value != null) {
                                      _priceVoice = value;
                                      state(() {});
                                    }
                                  });
                                }
                              },
                              child: Text(
                                '${_isVideo ? _priceVideo : _priceVoice}金币/分钟',
                                textAlign: TextAlign.end,
                                style: TextStyle(
                                    color: Colors.white, fontSize: 12.sp),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 4.h,
                    ),
                    Container(
                      height: 1.h,
                      color: Color(0xffF2F2F2),
                    )
                  ],
                ),
              ),
              Container(
                height: 40.h,
                child: Column(
                  children: [
                    Expanded(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            '通话方式：',
                            style: TextStyle(
                                color: Color(0xffFDFCDD), fontSize: 12.sp),
                          ),
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                _choiceChatTypeDialog().then((value) {
                                  if (value != null) {
                                    _isVideo = value;
                                    state(() {});
                                  }
                                });
                              },
                              child: Text(
                                _isVideo ? '视频通话' : '语音通话',
                                textAlign: TextAlign.end,
                                style: TextStyle(
                                    color: Colors.white, fontSize: 12.sp),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 4.h,
                    ),
                    Container(
                      height: 1.h,
                      color: Color(0xffF2F2F2),
                    )
                  ],
                ),
              )
            ],
          );
        }));
  }

  Widget _item3() {
    return StatefulBuilder(builder: (context, state) {
      return SizedBox(
        height: 40.h,
        child: Column(
          children: [
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '等待时间：',
                    style: TextStyle(color: Color(0xffFDFCDD), fontSize: 12.sp),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        showWaitTimeDialog(_time).then((value) {
                          if (value != null) {
                            _time = value;
                            state(() {});
                          }
                        });
                      },
                      child: Text(
                        '${_time}小时',
                        textAlign: TextAlign.end,
                        style: TextStyle(color: Colors.white, fontSize: 12.sp),
                      ),
                    ),
                  )
                ],
              ),
            ),
            SizedBox(
              height: 4.h,
            ),
            Container(
              height: 1.h,
              color: Color(0xffF2F2F2),
            )
          ],
        ),
      );
    });
  }

  Widget _inputContent() {
    return Container(
      height: 140.h,
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
      decoration: BoxDecoration(
          color: const Color(0xffF2F2F2),
          borderRadius: BorderRadius.all(Radius.circular(5.w))),
      child: _textField(_controller),
    );
  }

  Widget _textField(TextEditingController controller) {
    return TextField(
      style: TextStyle(
        fontSize: 15.sp,
        color: Color(0xff333333),
      ),
      maxLines: null,
      decoration: InputDecoration(
        filled: false,
        contentPadding: const EdgeInsets.symmetric(vertical: 4.0),
        counterText: '',
        //此处控制最大字符是否显示
        alignLabelWithHint: true,
        hintText: '请用一句话表达你当前的心情.',
        hintStyle: TextStyle(
          fontSize: 14.sp,
          color: Color(0x33333333),
        ),
        enabledBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: Color(0x00FEC693), width: 0)),
        focusedBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: Color(0x00FEC693), width: 0)),
      ),
      controller: controller,
    );
  }

  Widget _textButtonSure(VoidCallback? onPressed) {
    return Container(
      height: 43.h,
      width: 200.w,
      margin: EdgeInsets.symmetric(horizontal: 10.w),
      child: TextButton(
          onPressed: onPressed,
          child: Text(
            '发  布',
            style: TextStyle(color: Color(0xff292929), fontSize: 20.sp),
          ),
          style: ButtonStyle(
              enableFeedback: false,
              backgroundColor: MaterialStateProperty.all(Color(0xffFEC693)),
              shape: MaterialStateProperty.all(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(21.w),
                ),
              ))),
    );
  }

  Future<String?> _choiceTopic(String choiceTopic) {
    final topic = getTopicListFGS()?.data ?? [];
    return Get.dialog(
      barrierColor: Color(0x00000000),
      barrierDismissible: true,
      useSafeArea: false,
      Stack(
        children: [
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(21.w),
                      topRight: Radius.circular(21.w))),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Align(
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 12.h),
                      child: Text(
                        '选择话题',
                        style: TextStyle(color: C.FEC693, fontSize: 16.sp),
                      ),
                    ),
                  ),
                  Container(
                    height: 180.h,
                    alignment: Alignment.center,
                    child: StatefulBuilder(builder: (context, state) {
                      final list = <Widget>[];
                      for (int i = 0; i < topic.length; i++) {
                        final title = topic[i].title ?? "";
                        final isChecked = choiceTopic == title;
                        list.add(
                          _lT(title, () {
                            choiceTopic = title;
                            state(() {});
                          }, isChecked),
                        );
                      }
                      return SingleChildScrollView(
                        child: Wrap(
                          spacing: 12.w,
                          children: list,
                        ),
                      );
                    }),
                  ),
                  SizedBox(
                    height: 12.h,
                  ),
                  _tvBtnSure(() {
                    Get.back(result: choiceTopic);
                  }),
                  SizedBox(
                    height: 30.h,
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _lT(String str, GestureTapCallback? callback, bool isChecked) {
    var bgColor = Color(0xFF000000);
    if (isChecked) {
      bgColor = Color(0xFFFEC693);
    }
    return InkWell(
      onTap: callback,
      child: Container(
        height: 28.h,
        padding: EdgeInsets.symmetric(horizontal: 8.w),
        margin: EdgeInsets.only(bottom: 8.h),
        decoration: BoxDecoration(
            color: bgColor,
            border: Border.all(color: Color(0xFFFEC693), width: 1.w),
            borderRadius: BorderRadius.all(Radius.circular(5.w))),
        child: FractionallySizedBox(
          widthFactor: null,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                str,
                maxLines: 1,
                style: TextStyle(color: Colors.white, fontSize: 12.sp),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _tvBtnSure(VoidCallback? onPressed) {
    return Container(
      height: 43.h,
      width: 200.w,
      margin: EdgeInsets.symmetric(horizontal: 10.w),
      child: TextButton(
          onPressed: onPressed,
          child: Text(
            '确 定',
            style: TextStyle(color: Color(0xff292929), fontSize: 20.sp),
          ),
          style: ButtonStyle(
              enableFeedback: false,
              backgroundColor: MaterialStateProperty.all(Color(0xffFEC693)),
              shape: MaterialStateProperty.all(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(21.w),
                ),
              ))),
    );
  }

  void _pullSquare() async {
    final des = _controller.text.toString();
    if (des.isEmpty) {
      MyToast.show('请简要介绍一下您的广场');
      return;
    }
    LoadingUtils.showLoading(msg: '发布中');
    final res = await addSquare([_topicType], _isVideo ? 2 : 1,
        _isVideo ? _priceVideo : _priceVoice, des, _time);
    if (res.isOk()) {
      MyToast.show('发布成功');
      Get.back(result: true);
    } else {
      MyToast.show(res.msg);
    }
    LoadingUtils.dismiss();
  }

  Future<bool?> _choiceChatTypeDialog() {
    final textStyle =
        TextStyle(fontSize: 16.sp, color: const Color(0xff666666));
    return Get.dialog(
        Container(
            alignment: Alignment.bottomCenter,
            child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Container(
                      width: double.infinity,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: C.bottomDialogBgColor,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(24.w),
                            topRight: Radius.circular(24.w)),
                      ),
                      child: Column(children: <Widget>[
                        TextButton(
                            onPressed: () {
                              Get.back(result: true);
                            },
                            child: CustomText(
                                text: '视频通话',
                                textAlign: Alignment.center,
                                padding: EdgeInsets.symmetric(vertical: 8.h),
                                textStyle: textStyle)),
                        const Divider(
                          height: 1,
                          color: C.bottomDialogDividerColor,
                        ),
                        TextButton(
                            onPressed: () {
                              Get.back(result: false);
                            },
                            child: CustomText(
                                text: '语音通话',
                                textAlign: Alignment.center,
                                padding: EdgeInsets.symmetric(vertical: 8.h),
                                textStyle: textStyle)),
                        Container(
                          height: 4.h,
                          color: C.bottomDialogDividerColor,
                        ),
                        TextButton(
                            onPressed: () {
                              Get.back();
                            },
                            child: CustomText(
                                text: '取消',
                                textAlign: Alignment.center,
                                padding: EdgeInsets.symmetric(vertical: 8.h),
                                textStyle: textStyle)),
                      ]))
                ])),
        useSafeArea: false);
  }
}
