import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:metting/base/BaseController.dart';
import 'package:metting/base/BaseUiPage.dart';
import 'package:metting/widget/loading.dart';

import '../../../network/http_helper.dart';
import '../../../widget/my_toast.dart';

class CardVerifiedPage extends BaseUiPage<CardVerifiedController> {
  CardVerifiedPage() : super(title: "实名认证");

  @override
  Widget createBody(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          SizedBox(
            height: 30.h,
          ),
          Image.asset(
            'assets/images/card_verified_bg.png',
          ),
          SizedBox(
            height: 10.h,
          ),
          Stack(
            children: [
              Container(
                margin: EdgeInsets.only(left: 34, right: 16),
                child: Text(
                  '我们承诺保障您的隐私安全，且只会用于实名认证。',
                  textAlign: TextAlign.start,
                  style: TextStyle(fontSize: 14, color: Colors.white),
                ),
              )
            ],
          ),
          _textFieldCardNum(),
          SizedBox(
            height: 10.h,
          ),
          _textFieldName(),
          GestureDetector(
            onTap: () {
              controller.pullInfo();
            },
            child: GetBuilder<CardVerifiedController>(
                id: 'btnStatus',
                builder: (c) {
                  return Container(
                    width: 214,
                    height: 40,
                    margin: EdgeInsets.only(top: 26.h),
                    alignment: Alignment.center,
                    decoration: new BoxDecoration(
                      color: controller.isCanPull?Color(0xFFFEC693):Color(0xffB9B9B9),
                      borderRadius: BorderRadius.all(Radius.circular(40.0)),
                    ),
                    child: Text('提交认证',
                        style: TextStyle(
                            color:  Colors.white,
                            fontSize: 17)),
                  );
                }),
          ),
        ],
      ),
    );
  }

  @override
  CardVerifiedController initController() => CardVerifiedController();

  Widget _textFieldCardNum() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.h,horizontal: 16.w),
      child: TextField(
        maxLines: 1,
        //最多多少行
        style: TextStyle(
          fontSize: ScreenUtil().setSp(14),
          color: Color(0xff2B313E),
        ),
        onChanged: (text) {
          controller.setBtnStatus();
        },
        decoration: InputDecoration(
          // 设置背景色
          fillColor: Color(0xffD5D5D5),
          filled: true,
          contentPadding:
              const EdgeInsets.symmetric(vertical: 0, horizontal: 10.0),
          focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Color(0xffD5D5D5), width: 1)),
          enabledBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Color(0xffD5D5D5), width: 1)),
          counterText: '',
          //此处控制最大字符是否显示
          alignLabelWithHint: true,
          hintText: '请输入您的身份证号',
          hintStyle: TextStyle(
            fontSize: ScreenUtil().setSp(14),
            color: Color(0xff2B313E),
          ),
        ),
        controller: controller.controllerInfo,
      ),
    );
  }

  Widget _textFieldName() {
    return Padding(
        padding: EdgeInsets.symmetric(vertical: 4.h,horizontal: 16.w),
        child: TextField(
          maxLines: 1,
          //最多多少行
          minLines: 1,
          //最多多少行
          style: TextStyle(
            fontSize: ScreenUtil().setSp(14),
            color: Color(0xff2B313E),
          ),
          decoration: InputDecoration(
            // 设置背景色
            fillColor: Color(0xffD5D5D5),
            filled: true,
            contentPadding:
                const EdgeInsets.symmetric(vertical: 0, horizontal: 10.0),
            focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Color(0xffD5D5D5), width: 1)),
            enabledBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Color(0xffD5D5D5), width: 1)),
            counterText: '',
            //此处控制最大字符是否显示
            alignLabelWithHint: true,
            hintText: '请输入您的姓名',
            hintStyle: TextStyle(
              fontSize: ScreenUtil().setSp(14),
              color: Color(0xff2B313E),
            ),
          ),
          onChanged: (text) {
            controller.setBtnStatus();
          },
          controller: controller.controllerName,
        ));
  }
}

class CardVerifiedController extends BaseController {
  var isCanPull = false;
  final _regExp =
      r"^[1-9]\d{5}(18|19|20|(3\d))\d{2}((0[1-9])|(1[0-2]))(([0-2][1-9])|10|20|30|31)\d{3}[0-9Xx]$";
  final TextEditingController controllerInfo = TextEditingController();

  final TextEditingController controllerName = TextEditingController();

  void setBtnStatus() {
    if (controllerName.text.isNotEmpty && controllerInfo.text.isNotEmpty) {
      if (!isCanPull) {
        isCanPull = true;
        update(['btnStatus']);
      }
    } else {
      if (isCanPull) {
        isCanPull = false;
        update(['btnStatus']);
      }
    }
  }

  void pullInfo() async {
    final idCard = controllerInfo.value.text.toString();
    if (!RegExp(_regExp).hasMatch(idCard)) {
      MyToast.show('无效证件，请核对后再次重试!');
      return;
    }
    LoadingUtils.showLoading(msg: '提交中...');
    final name = controllerName.value.text.toString();
    final da=await addCertification(2, files: [idCard, name]);
    if(da.isOk()){
      LoadingUtils.dismiss();
      MyToast.show(da.msg);
      Get.back();
    }else{
      MyToast.show(da.msg);
    }
  }
}
