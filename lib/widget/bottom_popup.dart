import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../core/common_configure.dart';
import 'custom_text.dart';

void showBottomImageSource(
  BuildContext context,
  VoidCallback? action1,
  VoidCallback? action2, {
  String title = "选择照片来源",
  String action1Str = "拍照",
  String action2Str = "从相册中选择",
}) {
  final textStyle = TextStyle(fontSize: 18.sp, color: const Color(0xff666666));
  showModalBottomSheet(
      enableDrag: false,
      elevation: 0,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      context: context,
      builder: (context) {
        return Container(
            alignment: Alignment.bottomCenter,
            child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Expanded(
                    child: Container(child: GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                    )),
                  ),
                  Container(
                      padding: EdgeInsets.only(bottom: 20.0, top: 16),
                      width: double.infinity,
                      alignment: Alignment.center,
                      decoration: const BoxDecoration(
                        color: C.bottomDialogBgColor,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(30.0),
                            topRight: Radius.circular(30.0)),
                      ),
                      child: Column(children: <Widget>[
                        CustomText(
                            text: title,
                            textAlign: Alignment.center,
                            padding: EdgeInsets.only(bottom: 16),
                            textStyle: textStyle),
                        Divider(
                          height: 1,
                          color: C.bottomDialogDividerColor,
                        ),
                        TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                              action1?.call();
                            },
                            child: CustomText(
                                text: action1Str,
                                textAlign: Alignment.center,
                                padding: EdgeInsets.symmetric(vertical: 10.h),
                                textStyle: textStyle)),
                        Divider(
                          height: 1,
                          color: C.bottomDialogDividerColor,
                        ),
                        TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                              action2?.call();
                            },
                            child: CustomText(
                                text: action2Str,
                                textAlign: Alignment.center,
                                padding: EdgeInsets.symmetric(vertical: 10.h),
                                textStyle: textStyle)),
                        Container(
                          height: 4.h,
                          color: C.bottomDialogDividerColor,
                        ),
                        TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: CustomText(
                                text: "取消",
                                textAlign: Alignment.center,
                                padding: EdgeInsets.symmetric(vertical: 10.h),
                                textStyle: textStyle)),
                      ]))
                ]));
      });
}

void showBottomVideoOrVoiceChoice(
  VoidCallback? action1,
  VoidCallback? action2, {
  String action1Str = "视频通话(50金币/分钟)",
  String action2Str = "语音通话(50金币/分钟)",
}) {
  final textStyle = TextStyle(fontSize: 16.sp, color: const Color(0xff666666));
  Get.dialog(
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
                            Get.back();
                            action1?.call();
                          },
                          child: CustomText(
                              text: action1Str,
                              textAlign: Alignment.center,
                              padding: EdgeInsets.symmetric(vertical: 8.h),
                              textStyle: textStyle)),
                      const Divider(
                        height: 1,
                        color: C.bottomDialogDividerColor,
                      ),
                      TextButton(
                          onPressed: () {
                            Get.back();
                            action2?.call();
                          },
                          child: CustomText(
                              text: action2Str,
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

void showDeleteMsgDialog(VoidCallback? action1) {
  Get.dialog(
      Container(
          alignment: Alignment.bottomCenter,
          child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Container(
                    width: double.infinity,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Color(0xff3C4349),
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(24.w),
                          topRight: Radius.circular(24.w)),
                    ),
                    child: Column(children: <Widget>[
                      Container(
                        height: 52.h,
                        alignment: Alignment.center,
                        child: Text('是否删除该条消息?',
                            style:
                                TextStyle(fontSize: 16.sp, color: Colors.white70)),
                      ),
                      const Divider(
                        height: 1,
                        color: Colors.black54,
                      ),
                      TextButton(
                          onPressed: () {
                            Get.back();
                            action1?.call();
                          },
                          child: CustomText(
                              text: "确定",
                              textAlign: Alignment.center,
                              padding: EdgeInsets.symmetric(vertical: 8.h),
                              textStyle: TextStyle(
                                  fontSize: 20.sp, color: Colors.redAccent))),
                      const Divider(
                        height: 1,
                        color: C.bottomDialogDividerColor,
                      ),
                      Container(
                        height: 6.h,
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
                              textStyle: TextStyle(
                                  fontSize: 20.sp, color: Colors.white))),
                      SizedBox(
                        height: 10.h,
                      )
                    ]))
              ])),
      useSafeArea: false);
}
