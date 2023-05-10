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
          body: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: SizedBox(
              height: 648.h,
              child: Stack(
                children: [
                  Image.asset(
                    getImagePath('ic_vip_bg_c'),
                    height: 648.h,
                    fit: BoxFit.fitWidth,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    child: Column(
                      children: [
                        SizedBox(
                          height: 12.h,
                        ),
                        Row(
                          children: [
                            SizedBox(
                              width: 12.w,
                            ),
                            Text(
                              '会员用户',
                              style: TextStyle(
                                  color: Colors.white, fontSize: 20.sp),
                            ),
                            Expanded(child: SizedBox()),
                            Text(
                              '${controller.time}',
                              style: TextStyle(
                                  color: Color(0xffE9CFA4), fontSize: 22.sp),
                            ),
                            SizedBox(
                              width: 12.w,
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 36.h,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '开通会员',
                              style: TextStyle(
                                  color: Color(0xff616161), fontSize: 16.sp),
                            ),
                            Text(
                              '限时特惠68元/年',
                              style: TextStyle(
                                  color: Color(0xff616161), fontSize: 28.sp),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 36.h,
                        ),
                        Text(
                          '成为VIP会员领取特权',
                          style: TextStyle(
                              color: Color(0xffAD874D), fontSize: 22.sp),
                        ),
                        SizedBox(
                          height: 10.h,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              getImagePath('ic_vip_icon'),
                              width: 19.w,
                              height: 10.h,
                            ),
                            Text(
                              '开通会员可享以下特权',
                              style: TextStyle(
                                  color: Color(0xff5E5D5B), fontSize: 14.sp),
                            ),
                            Image.asset(
                              getImagePath('ic_vip_icon'),
                              width: 19.w,
                              height: 10.h,
                            ),
                          ],
                        ),
                        Container(
                          height: 240.h,
                          width: 400.w,
                          margin: EdgeInsets.only(top: 16.h),
                          child: GridView.count(
                            crossAxisCount: 3,
                            primary: false,
                            padding: EdgeInsets.symmetric(horizontal: 10.w),
                            children: [
                              _itemFunction('ic_vip_video', '视频', '视频畅聊'),
                              _itemFunction('ic_vip_voice', '语音', '语音畅聊'),
                              _itemFunction('ic_vip_message', '消息', '消息畅聊'),
                              _itemFunction('ic_vip_record', '记忆', '日记分享'),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      height: 60.h,
                      margin: EdgeInsets.symmetric(
                          horizontal: 24.w, vertical: 26.h),
                      child: GestureDetector(
                        onTap: () {},
                        child: Stack(children: [
                          Image.asset(getImagePath('ic_vip_btn')),
                          Align(
                            alignment: Alignment.center,
                            child: Padding(
                              padding: EdgeInsets.only(top: 10.h),
                              child: Text(
                                '${controller.btnText}',
                                style: TextStyle(
                                    color: Colors.black, fontSize: 24.sp),
                              ),
                            ),
                          )
                        ]),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        )
      ],
    );
  }

  Widget _itemFunction(String icon, String title, String content) {
    return Column(
      children: [
        Image.asset(
          getImagePath(icon),
          width: 29.w,
          height: 21.h,
        ),
        Text(
          title,
          style: TextStyle(color: Color(0xff5E5D5B), fontSize: 18.sp),
        ),
        Text(
          content,
          style: TextStyle(color: Color(0xff999999), fontSize: 14.sp),
        ),
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

class BuyVipController extends BaseController {
  String time = "2023-12-26";
  String btnText = '立即开通';



}
