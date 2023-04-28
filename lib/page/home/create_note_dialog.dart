import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:metting/network/http_helper.dart';
import 'package:metting/widget/loading.dart';
import 'package:metting/widget/my_toast.dart';

void showCreateNoteDialog(BuildContext context) {
  showDialog(
      context: context,
      builder: (context) {
        final TextEditingController _controller = TextEditingController();
        return Container(
          margin: EdgeInsets.symmetric(horizontal: 16.w),
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 16.h),
          decoration: BoxDecoration(
              color: Color(0xff333333),
              border: Border.all(color: Color(0xff82361B), width: 1.h),
              borderRadius: BorderRadius.all(Radius.circular(5.w))),
          child: Column(
            children: [
              Text(
                '添加日记',
                style: TextStyle(fontSize: 16.sp, color: Colors.white),
              ),
              Container(
                height: 300.h,
                margin: EdgeInsets.symmetric(horizontal: 16.w),
                padding: EdgeInsets.all(10.w),
                decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Color(0xff82361B), width: 1.h),
                    borderRadius: BorderRadius.all(Radius.circular(5.w))),
                child: textField(_controller),
              ),
              textButtonLogin(() async {
                final content = _controller.text;
                if (content.isEmpty) return;
                LoadingUtils.showLoading();
                final data = await addNote(content);
                if (data.isOk()) {
                  MyToast.show('添加成功');
                  Get.back();
                }
                LoadingUtils.dismiss();
              })
            ],
          ),
        );
      });
}

Widget textField(TextEditingController controller) {
  return TextField(
    keyboardType: TextInputType.number,
    style: TextStyle(
      fontSize: 15.sp,
      color: Color(0xff333333),
    ),
    decoration: InputDecoration(
      filled: false,
      contentPadding: const EdgeInsets.symmetric(vertical: 4.0),
      counterText: '',
      //此处控制最大字符是否显示
      alignLabelWithHint: true,
      hintText: '请输入日记内容',
      hintStyle: TextStyle(
        fontSize: 14.sp,
        color: Color(0x33333333),
      ),
      enabledBorder: null,
      focusedBorder: null,
    ),
    controller: controller,
  );
}

Widget textButtonLogin(VoidCallback? onPressed) {
  return TextButton(
      onPressed: onPressed,
      child: Text(
        '完成',
        style: TextStyle(color: Color(0xff292929), fontSize: 20.sp),
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
              borderRadius: BorderRadius.circular(21.w),
            ),
          )));
}
