import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:metting/base/BaseController.dart';
import 'package:metting/tool/view_tools.dart';

import '../../base/BaseStatelessPage.dart';
import '../../core/common_configure.dart';

class BuyVipPage extends BaseStatelessPage<BuyVipController> {
  @override
  Widget createBody(BuildContext context) {
    return Stack(
      children: [
        Image.asset(
          getImagePath('ic_vip_top_bg'),
          height: 209.h,
          fit: BoxFit.fitWidth,
        ),
        Scaffold(
          appBar: _appBarWidget(),
          backgroundColor: C.TRANSPORT,
          body: Column(
            children: [
              Text('data'),
            ],
          ),
        )
      ],
    );
  }

  @override
  BuyVipController initController() => BuyVipController();

  AppBar _appBarWidget() {
    return AppBar(
      centerTitle: true,
      leading: backWidget(),
      title: Text(
        '成为VIP会员',
        style: TextStyle(color: C.whiteFFFFFF, fontSize: 18.sp),
      ),
      backgroundColor: C.TRANSPORT,
    );
  }

  Widget backWidget() {
    return IconButton(
        icon: Icon(Icons.chevron_left, size: 38.h, color: Colors.white),
        onPressed: onBack);
  }

  void onBack() {
    Get.back();
  }
}

class BuyVipController extends BaseController {}