import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:metting/base/BaseController.dart';
import 'package:metting/base/BaseUiPage.dart';
import 'package:metting/tool/view_tools.dart';
import 'package:metting/widget/loading.dart';

import '../../core/common_configure.dart';
import '../../dialog/wallet_dialog.dart';
import '../../network/bean/pay_list_response.dart';
import '../../network/http_helper.dart';

class WalletPage extends BaseUiPage<WalletController> {
  WalletPage() : super(title: '我的钱包');
  WalletDialog? walletDialog;

  @override
  Widget createBody(BuildContext context) {
    return Padding(
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
                child: GetBuilder<WalletController>(
                    id: "money",
                    builder: (context) {
                      return Text(
                        controller.money,
                        style: TextStyle(color: C.FEC693, fontSize: 26.sp),
                      );
                    }),
              ),
              const Expanded(child: SizedBox()),
              _btn()
            ],
          )
        ],
      ),
    );
  }

  Widget _btn() {
    return Container(
      height: 35.w,
      child: TextButton(
          onPressed: () async {
            walletDialog ??= WalletDialog();
            final list = await controller.getRechargeList();
            walletDialog?.showDialog(list, controller.money);
          },
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
            '去充值',
            style: TextStyle(color: Colors.white, fontSize: 14.sp),
          )),
    );
  }

  @override
  WalletController initController() => WalletController();

  @override
  List<Widget>? action() {
    return [
      TextButton(
          onPressed: () {},
          child: Text(
            "须知",
            style: TextStyle(color: Colors.white, fontSize: 16.sp),
          ))
    ];
  }
}

class WalletController extends BaseController {
  String money = "0";

  final List<RechargeBean> _list = [];

  Future<List<RechargeBean>> getRechargeList() async {
    if (_list.isEmpty) {
      LoadingUtils.showLoading();
      final data = await getPayList();
      if (data.isOk()) {
        _list.addAll(data.data?.data ?? []);
      }
      LoadingUtils.dismiss();
      return _list;
    } else {
      return _list;
    }
  }

  @override
  void onInit() {
    super.onInit();
    _getMBalance();
  }

  void _getMBalance() async {
    final data = await getMyBalance();
    if (data.isOk()) {
      money = data.data?.balance ?? "0";
      update(['money']);
    }
  }
}
