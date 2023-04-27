import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:metting/base/BaseUiPage.dart';
import 'package:metting/core/common_configure.dart';
import 'package:metting/page/login/login.dart';
import 'package:metting/page/mine/feedback.dart';

import '../../base/BaseController.dart';
import '../../network/http_helper.dart';
import '../../widget/dialog_alert.dart';
import '../../widget/my_toast.dart';

class SettingPage extends BaseUiPage<SettingC> {
  SettingPage() : super(title: "设置");

  @override
  Widget createBody(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      color: C.PAGE_THEME_BG,
      child: Column(
        children: [
          SizedBox(
            height: 30.h,
          ),
          _Item('隐私政策', () {}),
          _Item('用户协议', () {}),
          _Item('关于我们', () {}),
          _Item('意见反馈', () {
            Get.to(FeedbackPage());
          }),
          _Item('清除缓存', () {}),
          _Item('随手好评', () {}),
          SizedBox(
            height: 50.h,
          ),
          _buttonLogout(),
          SizedBox(
            height: 32.h,
          ),
          _clearAccount(),
        ],
      ),
    );
  }

  Widget _Item(String text, GestureTapCallback onTap) {
    return Container(
      height: 56.h,
      margin: EdgeInsets.symmetric(horizontal: 8.w),
      child: GestureDetector(
        onTap: onTap,
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                    child: Text(
                  text,
                  style: TextStyle(color: Color(0xffE3E3E3), fontSize: 16.sp),
                )),
                Icon(
                  Icons.navigate_next,
                  color: Colors.white,
                  size: 14.w,
                )
              ],
            ),
            SizedBox(
              height: 8.h,
            ),
            Container(
              height: 1.h,
              color: Colors.white,
            )
          ],
        ),
      ),
    );
  }

  Widget _buttonLogout() {
    return Row(
      children: [
        Expanded(
            child: TextButton(
                onPressed: () {
                  controller.logout();
                },
                child: Text(
                  '退出登录',
                  style: TextStyle(color: Color(0xff292929), fontSize: 22.sp),
                ),
                style: ButtonStyle(
                    enableFeedback: false,
                    backgroundColor:
                        MaterialStateProperty.all(Color(0xffFEC693)),
                    shape: MaterialStateProperty.all(
                      RoundedRectangleBorder(
                        // side: BorderSide(   Padding(padding: EdgeInsets.only(top: 16.h)),
                        //   width: 0.5,
                        //   color: MyColor.BtnNormalColor,
                        // ),
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ))))
      ],
    );
  }

  Widget _clearAccount() {
    return Row(
      children: [
        Expanded(
            child: TextButton(
                onPressed: () {
                  _showDelTips();
                },
                child: Text(
                  '注销账号',
                  style: TextStyle(color: Colors.white, fontSize: 22.sp),
                ),
                style: ButtonStyle(
                    enableFeedback: false,
                    backgroundColor:
                        MaterialStateProperty.all(Color(0xff999999)),
                    shape: MaterialStateProperty.all(
                      RoundedRectangleBorder(
                        // side: BorderSide(   Padding(padding: EdgeInsets.only(top: 16.h)),
                        //   width: 0.5,
                        //   color: MyColor.BtnNormalColor,
                        // ),
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ))))
      ],
    );
  }

  void _showDelTips() {
    commonAlertD(mContext, "账号注销后该账号的相关数据都会被清空，请确认是否注销?", "注销",
        title: "账号注销", negativeStr: "取消", positiveCall: () {
      controller.clear();
    });
  }

  @override
  SettingC initController() => SettingC();
}

class SettingC extends BaseController {
  void logout() {
    Get.offAll(LoginPage());
  }

  void clear() async {
    final data = await delMineAccount();
    if (data.isOk()) {
      Get.offAll(LoginPage());
    } else {
      MyToast.show(data.msg);
    }
  }
}
