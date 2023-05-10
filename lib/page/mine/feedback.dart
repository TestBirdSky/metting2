import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:metting/base/BaseController.dart';
import 'package:metting/tool/view_tools.dart';

import '../../base/BaseUiPage.dart';
import '../../core/common_configure.dart';
import '../../network/http_helper.dart';
import '../../tool/gallery.dart';
import '../../widget/bottom_popup.dart';
import '../../widget/my_toast.dart';

class FeedbackPage extends BaseUiPage<FeedbackC> {
  FeedbackPage() : super(title: "意见反馈");

  @override
  Widget createBody(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            height: 300.h,
            padding: EdgeInsets.all(12.w),
            margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
            decoration: BoxDecoration(
                color: Color(0xffCFCFCF),
                borderRadius: BorderRadius.all(Radius.circular(5.w))),
            child: _textFieldInput(),
          ),
          Container(
            height: 90.w,
            padding: EdgeInsets.symmetric(horizontal: 14.w),
            child: GetBuilder<FeedbackC>(
                id: 'picture',
                builder: (context) {
                  return ListView(
                    scrollDirection: Axis.horizontal,
                    children: getPictureSWidget(),
                  );
                }),
          ),
          _finishBtn()
        ],
      ),
    );
  }

  final TextEditingController _controllerInput = TextEditingController();

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
        hintText: '请输入反馈内容',
        hintStyle: TextStyle(
          fontSize: 14.sp,
          color: C.whiteFFFFFF,
        ),
        enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Color(0x00FEC693), width: 0)),
        focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Color(0x00FEC693), width: 0)),
      ),
      controller: _controllerInput,
    );
  }

  @override
  FeedbackC initController() => FeedbackC();

  List<Widget> getPictureSWidget() {
    final list = <Widget>[];
    controller.paths.forEach((element) {
      list.add(_picture(element));
    });
    if (list.length < 4) {
      list.add(_addWidget());
    }
    return list;
  }

  Widget _picture(String path) {
    return Container(
      width: 85.w,
      height: 85.w,
      margin: EdgeInsets.only(right: 16.w),
      child: Stack(
        children: [
          Align(
            alignment: Alignment.center,
            child: Container(
              width: 85.w,
              height: 85.w,
              child: Image.file(
                File(path),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Align(
            alignment: Alignment.topRight,
            child: GestureDetector(
              onTap: () {
                controller.removePicture(path);
              },
              child: ClipOval(
                child: Container(
                  width: 20.w,
                  height: 20.w,
                  color: Colors.red,
                  child: Align(
                    alignment: Alignment.center,
                    child: Icon(
                      Icons.remove,
                      color: Colors.white,
                      size: 20.w,
                    ),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _addWidget() {
    return GestureDetector(
      onTap: _showChoicePicture,
      child: Container(
        width: 85.w,
        height: 85.w,
        child: Image.asset(
          getImagePath('ic_add_picture'),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  void _showChoicePicture() {
    showBottomImageSource(mContext, () async {
      final file = await takePhoto();
      if (file != null) controller.addPicture(file.path);
    }, () async {
      final file = await getImageFromGallery();
      if (file != null) controller.addPicture(file.path);
    });
  }

  Widget _finishBtn() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 50.h),
      child: TextButton(
          onPressed: () async {
            EasyLoading.show(status: "保存中...");
            await controller.commit(_controllerInput.text);
            EasyLoading.dismiss();
            Get.back();
          },
          style: ButtonStyle(
              enableFeedback: false,
              backgroundColor: MaterialStateProperty.all(Color(0xffFEC693)),
              shape: MaterialStateProperty.all(
                RoundedRectangleBorder(
                  side: const BorderSide(
                    width: 0.5,
                    color: Color(0xffFEC693),
                  ),
                  borderRadius: BorderRadius.circular(5),
                ),
              )),
          child: Text(
            '提交',
            style: TextStyle(color: Color(0xff292929), fontSize: 22.sp),
          )),
    );
  }
}

class FeedbackC extends BaseController {
  List<String> paths = [];

  void addPicture(String path) {
    paths.insert(0, path);
    update(['picture']);
  }

  void removePicture(String path) {
    paths.remove(path);
    update(['picture']);
  }

  Future<void> commit(String context) async {
    final data = await addFeedback(context, paths);
    if (data.isOk()) {
      MyToast.show("提交成功");
    } else {
      MyToast.show("${data.msg}");
    }
  }
}
