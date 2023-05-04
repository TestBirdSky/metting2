import 'dart:io';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:metting/network/bean/login_response.dart';
import 'package:metting/page/mian/main.dart';
import 'package:metting/page/web_view.dart';
import 'package:metting/tool/log.dart';
import 'package:metting/widget/my_toast.dart';

import '../../base/BaseController.dart';
import '../../base/BaseStatelessPage.dart';
import '../../core/common_configure.dart';
import '../../database/get_storage_manager.dart';
import '../../network/http_helper.dart';
import '../../tool/input_filter.dart';
import '../../tool/view_tools.dart';
import '../../widget/ClickSpecifiedStringText.dart';
import 'basic_info.dart';

class LoginPage extends BaseStatelessPage<LoginC> {
  final TextEditingController _controllerPhone =
      TextEditingController(text: getLastLoginAccount());
  final TextEditingController _controllerCode = TextEditingController();

  @override
  Widget createBody(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            width: double.infinity,
            height: double.infinity,
            color: C.pageBgColor,
          ),
          ConstrainedBox(
            constraints: const BoxConstraints.expand(),
            child: Image.asset(
              getImagePath("ic_login_bg"),
              fit: Platform.isIOS ? BoxFit.cover : BoxFit.fill,
            ),
          ),
          Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(26.w),
                child: GetBuilder<LoginC>(
                  id: 'codeLogin',
                  builder: (c) {
                    if (!c.isShowCodeLogin) {
                      return login2Widget();
                    }
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '登录/注册',
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            color: C.whiteFFFFFF,
                            fontSize: 34.sp,
                          ),
                        ),
                        Padding(padding: EdgeInsets.only(top: 140.h)),
                        textFieldPhone(),
                        Padding(padding: EdgeInsets.only(top: 30.h)),
                        textFieldCode(),
                        Padding(padding: EdgeInsets.only(top: 60.h)),
                        textButtonLogin(),
                        Padding(padding: EdgeInsets.only(top: 16.h)),
                        privacyWidget(),
                        Padding(padding: EdgeInsets.only(top: 30.h)),
                      ],
                    );
                  },
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget textFieldPhone() {
    return TextField(
      keyboardType: TextInputType.number,
      style: TextStyle(
        fontSize: 15.sp,
        color: C.whiteFFFFFF,
      ),
      maxLength: 11,
      inputFormatters: [numFilter],
      decoration: InputDecoration(
        filled: false,
        contentPadding: const EdgeInsets.symmetric(vertical: 4.0),
        counterText: '',
        //此处控制最大字符是否显示
        alignLabelWithHint: true,
        hintText: '请输入手机号',
        hintStyle: TextStyle(
          fontSize: 18.sp,
          color: C.grey8C8C8C,
        ),
        enabledBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: Color(0xffFEC693), width: 1)),
        focusedBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: Color(0xffFEC693), width: 1)),
      ),
      controller: _controllerPhone,
    );
  }

  Widget textFieldCode() {
    return Stack(
      children: [
        TextField(
          maxLength: 4,
          keyboardType: TextInputType.number,
          style: TextStyle(
            fontSize: 18.sp,
            color: C.whiteFFFFFF,
          ),
          inputFormatters: [numFilter],
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
          controller: _controllerCode,
        ),
        Align(
          alignment: Alignment.centerRight,
          child: GetBuilder<LoginC>(
            id: "code",
            builder: (c) {
              return TextButton(
                onPressed: () {
                  if (!c.isSendSmsCode) {
                    String phone = _controllerPhone.value.text;
                    if (phone.isNotEmpty) {
                      c.getSmsCode(phone);
                    }
                  }
                },
                child: Text(
                  c.isSendSmsCode ? '验证码已发送' : '获取验证码',
                  style: TextStyle(color: Color(0xffDFDFDF), fontSize: 14.sp),
                ),
              );
            },
          ),
        )
      ],
    );
  }

  Widget privacyWidget() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        GetBuilder<LoginC>(builder: (c) {
          return Checkbox(
              side: BorderSide(color: Colors.white),
              activeColor: Color(0xffFEC693),
              checkColor: C.whiteFFFFFF,
              value: c.isCheckPrivacy,
              onChanged: (bool? c) {
                controller.isCheckPrivacy = c ?? false;
                controller.update();
              });
        }),
        ClickSpecifiedStringText(
          textAlign: TextAlign.start,
          fontSize: 14.sp,
          originalStr: const ['注册/登录即表示同意', '和'],
          clickStr: const ['《用户协议》', '《隐私条款》'],
          onTaps: [
            TapGestureRecognizer()
              ..onTap = () {
                _clickProtocol();
              },
            TapGestureRecognizer()
              ..onTap = () {
                _clickPrivacy();
              },
          ],
        )
      ],
    );
  }

  void _login() {
    String phone = _controllerPhone.value.text;
    String code = _controllerCode.value.text;
    if (phone.isNotEmpty && code.isNotEmpty) {
      controller.login(phone, code);
    }
  }

  Widget textButtonLogin() {
    return TextButton(
        onPressed: () {
          _login();
        },
        child: Text(
          '登 录',
          style: TextStyle(color: Color(0xff292929), fontSize: 22.sp),
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
                borderRadius: BorderRadius.circular(5),
              ),
            )));
  }

  Widget login2Widget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          '晚上好',
          textAlign: TextAlign.start,
          style: TextStyle(
            color: C.whiteFFFFFF,
            fontSize: 34.sp,
          ),
        ),
        Padding(padding: EdgeInsets.only(top: 14.h)),
        Text(
          '我有故事 你有酒吗',
          textAlign: TextAlign.start,
          style: TextStyle(
            color: Color(0xffC3C2C2),
            fontSize: 23.sp,
          ),
        ),
        Padding(padding: EdgeInsets.only(top: 140.h)),
        TextButton(
            onPressed: () {
              controller.ownPhoneLogin();
            },
            child: Text(
              '本机号码一键登录',
              style: TextStyle(color: Color(0xff292929), fontSize: 22.sp),
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
                    borderRadius: BorderRadius.circular(5),
                  ),
                ))),
        Padding(padding: EdgeInsets.only(top: 30.h)),
        TextButton(
            onPressed: () {
              controller.showCodeLogin();
            },
            child: Text(
              '其他手机号登录',
              style: TextStyle(color: Colors.white, fontSize: 22.sp),
            ),
            style: ButtonStyle(
                enableFeedback: false,
                backgroundColor: MaterialStateProperty.all(Color(0xff414141)),
                shape: MaterialStateProperty.all(
                  RoundedRectangleBorder(
                    side: BorderSide(
                      width: 0.5,
                      color: Color(0xffFEC693),
                    ),
                    borderRadius: BorderRadius.circular(5),
                  ),
                ))),
        Padding(padding: EdgeInsets.only(top: 14.h)),
        privacyWidget(),
        Padding(padding: EdgeInsets.only(top: 30.h)),
      ],
    );
  }

  void _clickProtocol() {
    Get.to(WebViewPage(title: '用户协议', url: 'http://www.sancun.vip/yhxy'));
    // Get.toNamed(webViewPName,
    //     arguments: {'url': 'http://www.sancun.vip/yhxy', 'title': '用户协议'});
  }

  void _clickPrivacy() {
    Get.to(WebViewPage(title: '隐私声明', url: 'http://www.sancun.vip/ysxy'));
    // Get.toNamed(webViewPName,
    //     arguments: {'url': 'http://www.sancun.vip/ysxy', 'title': '隐私声明'});
  }

  @override
  LoginC initController() => LoginC();
}

class LoginC extends BaseController {
  var isSendSmsCode = false;
  var isShowCodeLogin = false;
  var isCheckPrivacy = false;

  void getSmsCode(phone) async {
    isSendSmsCode = true;

    final data = await sendSms(phone);
    if (data.isOk()) {
      MyToast.show('发送成功');
    } else {
      isSendSmsCode = false;
      MyToast.show(data.msg);
    }
    update(['code']);
  }

  void showCodeLogin() {
    isShowCodeLogin = true;
    update(['codeLogin']);
  }

  void login(String phone, String code) async {
    if (!isCheckPrivacy) {
      MyToast.show("请先确定用户协议和隐私条款！");
      return;
    }
    EasyLoading.show(status: "登录中...");
    final res = await loginPhone(phone, code);
    if (res.isOk() && res.data != null) {
      _next(res.data!);
      saveLoginAccount(phone);
    } else {
      MyToast.show(res.msg);
    }
    EasyLoading.dismiss();
  }

  void ownPhoneLogin() {}

  void _next(LoginResponse res) {
    if (res.sex == 0) {
      Get.off(BasicInfoPage());
    } else {
      Get.off(MainPage());
    }
  }
}
