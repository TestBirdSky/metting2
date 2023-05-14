import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:metting/base/BaseUiPage.dart';
import 'package:metting/widget/my_toast.dart';

import '../../base/BaseController.dart';
import '../../core/common_configure.dart';
import '../../network/bean/withdrawal_list.dart';
import '../../network/http_helper.dart';
import '../../tool/view_tools.dart';

class WithdrawalPage extends BaseUiPage<WithdrawalController> {
  WithdrawalPage() : super(title: '提现');

  @override
  Widget createBody(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "我的余额",
                style: TextStyle(color: Colors.white, fontSize: 16.sp),
              ),
              Row(
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 10.h),
                    child: Image.asset(
                      getImagePath('ic_wallete_icon'),
                      fit: BoxFit.fill,
                      width: 35.w,
                      height: 35.w,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 8.w, top: 12.h),
                    child: GetBuilder<WithdrawalController>(
                        id: "money",
                        builder: (context) {
                          return Text(
                            controller.money,
                            style: TextStyle(color: C.FEC693, fontSize: 26.sp),
                          );
                        }),
                  ),
                  const Expanded(child: SizedBox()),
                ],
              )
            ],
          ),
        ),
        Container(
          height: 190.h,
          width: double.infinity,
          margin: EdgeInsets.symmetric(vertical: 12.h),
          child: GetBuilder<WithdrawalController>(
              id: 'selected',
              builder: (c) {
                return GridView.count(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  primary: false,
                  crossAxisCount: 3,
                  crossAxisSpacing: 8.w,
                  mainAxisSpacing: 10.h,
                  childAspectRatio: 1.5,
                  shrinkWrap: true,
                  children: _list(controller.list),
                );
              }),
        ),
        _info(),
        Expanded(child: Text('')),
        Padding(
          padding: EdgeInsets.only(bottom: 48.h),
          child: Align(
            alignment: Alignment.bottomCenter,
            child: _btn(),
          ),
        ),
      ],
    );
  }

  @override
  WithdrawalController initController() => WithdrawalController();

  List<Widget> _list(List<WithdrawalBean> listBean) {
    final list = <Widget>[];
    for (int i = 0; i < listBean.length; i++) {
      WithdrawalBean bean = listBean[i];
      list.add(GestureDetector(
        onTap: () {
          controller.curSelectedIndex = i;
          controller.update(['selected']);
        },
        child: _item(bean, i == controller.curSelectedIndex),
      ));
    }
    return list;
  }

  Widget _item(WithdrawalBean bean, bool isChecked) {
    return Align(
      alignment: Alignment.topCenter,
      child: Container(
        decoration: BoxDecoration(
            color: Color(0xFFEEEEEE),
            border: Border.all(
                color: isChecked ? C.FEC693 : Color(0xFFD7D7D7), width: 1.5.w),
            borderRadius: BorderRadius.all(Radius.circular(5.w))),
        child: Stack(
          children: [
            Align(
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 8.h,
                  ),
                  Text(
                    '${bean.money}RMB',
                    style: TextStyle(
                        color: !isChecked ? Color(0xff515151) : C.FEC693,
                        fontSize: 16.sp),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(
                    height: 8.h,
                  ),
                  Text(
                    '${bean.number}金币',
                    style: TextStyle(
                        color: !isChecked ? Color(0xff515151) : C.FEC693,
                        fontSize: 14.sp),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  String _accountName = "";
  String _account = "";

  Widget _info() {
    return Column(
      children: [
        Container(
          height: 90.h,
          padding: EdgeInsets.symmetric(horizontal: 10.w),
          margin: EdgeInsets.symmetric(horizontal: 16.w),
          decoration: BoxDecoration(
              color: Color(0xFFEEEEEE),
              borderRadius: BorderRadius.all(Radius.circular(5.w))),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '提现到支付宝',
                style: TextStyle(color: Color(0xff515151), fontSize: 18.sp),
                textAlign: TextAlign.start,
              ),
              SizedBox(height: 4.h,),
              Row(
                children: [
                  Text(
                    '收款人户名：',
                    style: TextStyle(color: Color(0xff515151), fontSize: 14.sp),
                  ),
                  Text(
                    _accountName,
                    style: TextStyle(color: Color(0xff515151), fontSize: 14.sp),
                  ),
                ],
              ),  Row(
                children: [
                  Text(
                    '收款账号：',
                    style: TextStyle(color: Color(0xff515151), fontSize: 14.sp),
                  ),
                  Text(
                    _account,
                    style: TextStyle(color: Color(0xff515151), fontSize: 14.sp),
                  ),
                ],
              ),
            ],
          ),
        ),
        SizedBox(height:12.h),
        _btnSetAccount(),
      ],
    );
  }

  @override
  List<Widget>? action() {
    return [
      TextButton(
          onPressed: () {},
          child: Text(
            "提现记录",
            style: TextStyle(color: Colors.white, fontSize: 16.sp),
          ))
    ];
  }

  Widget _btnSetAccount() {
    return Container(
      height: 40.w,
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 24.w),
      child: TextButton(
          onPressed: () {},
          style: ButtonStyle(
              enableFeedback: false,
              backgroundColor: MaterialStateProperty.all(Color(0xffFEC693)),
              shape: MaterialStateProperty.all(
                RoundedRectangleBorder(
                  // side: BorderSide(   Padding(padding: EdgeInsets.only(top: 16.h)),
                  //   width: 0.5,
                  //   color: MyColor.BtnNormalColor,
                  // ),
                  borderRadius: BorderRadius.circular(24),
                ),
              )),
          child: Text(
            '设置支付宝账号',
            style: TextStyle(color: Colors.white, fontSize: 14.sp),
          )),
    );
  }

  Widget _btn() {
    return Container(
      height: 40.w,
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 24.w),
      child: TextButton(
          onPressed: () {},
          style: ButtonStyle(
              enableFeedback: false,
              backgroundColor: MaterialStateProperty.all(Color(0xffFEC693)),
              shape: MaterialStateProperty.all(
                RoundedRectangleBorder(
                  // side: BorderSide(   Padding(padding: EdgeInsets.only(top: 16.h)),
                  //   width: 0.5,
                  //   color: MyColor.BtnNormalColor,
                  // ),
                  borderRadius: BorderRadius.circular(24),
                ),
              )),
          child: Text(
            '提现',
            style: TextStyle(color: Colors.white, fontSize: 14.sp),
          )),
    );
  }
}

class WithdrawalController extends BaseController {
  String money = "0";
  int curSelectedIndex = 0;
  List<WithdrawalBean> list = [];

  @override
  void onInit() {
    super.onInit();
    initData();
  }

  void initData() async {
    final data = await getWithdrawalList();
    if (data.isOk()) {
      list = data.data?.data ?? [];
      update(['selected']);
    } else {
      MyToast.show(data.msg);
    }
  }
}
