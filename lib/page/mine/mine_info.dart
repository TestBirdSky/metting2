import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:metting/page/mine/edit_info.dart';
import 'package:metting/page/mine/setting.dart';
import 'package:metting/page/mine/withdrawal_page.dart';
import 'package:metting/tool/view_tools.dart';

import '../../core/common_configure.dart';
import '../../dialog/my_dialog.dart';
import 'bug_vip.dart';
import 'mine.dart';
import 'mine_wallet.dart';

class MineInfo extends StatelessWidget {
  MineInfo(this.controller);

  late MineC controller;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "我的信息",
            style: TextStyle(color: Colors.white, fontSize: 20.sp),
          ),
          SizedBox(
            height: 10.h,
          ),
          Container(
              padding: EdgeInsets.symmetric(vertical: 10.h),
              decoration: BoxDecoration(
                  color: Color(0x5013181E),
                  borderRadius: BorderRadius.all(Radius.circular(5.w))),
              child: Row(
                children: [
                  _item1('mine_wallet', '我的钱包', () {
                    Get.to(WalletPage());
                  }),
                  _item1('mine_listener_p', '倾听者', () {
                    Get.to(WithdrawalPage());
                  }),
                  _item1('mine_vip', '我的会员', () {
                    Get.to(() => BuyVipPage());
                  }),
                  _item1('mine_edit_info', '编辑资料', () {
                    Get.to(EditInfoPage());
                  }),
                ],
              )),
          SizedBox(
            height: 12.h,
          ),
          Container(
              padding: EdgeInsets.all(10.w),
              decoration: BoxDecoration(
                  color: Color(0xFF13181E),
                  borderRadius: BorderRadius.all(Radius.circular(5.w))),
              child: Column(
                children: [
                  _item2(
                    Row(
                      children: [
                        Image.asset(
                          getImagePath('mine_setting'),
                          width: 26.w,
                          height: 26.w,
                        ),
                        SizedBox(width: 8.w),
                        Expanded(
                            child: Text(
                          '系统设置',
                          textAlign: TextAlign.start,
                          style:
                              TextStyle(color: Colors.white, fontSize: 15.sp),
                        )),
                        Icon(
                          Icons.navigate_next,
                          color: Colors.white,
                          size: 13.w,
                        )
                      ],
                    ),
                    () {
                      Get.to(SettingPage());
                    },
                  ),
                  _item2(
                      Row(
                        children: [
                          Image.asset(
                            getImagePath('mine_sex_woman'),
                            width: 26.w,
                            height: 26.w,
                          ),
                          SizedBox(width: 8.w),
                          Expanded(
                              child: Text(
                            '显示女性信息',
                            textAlign: TextAlign.start,
                            style:
                                TextStyle(color: Colors.white, fontSize: 15.sp),
                          )),
                          GetBuilder<MineC>(
                              id: "mine_info",
                              builder: (c) {
                                return CupertinoSwitch(
                                    activeColor: C.FEC693,
                                    value: c.isShowWomanInfo,
                                    onChanged: (onChanged) async {
                                      controller.setWoman(onChanged);
                                    });
                              })
                        ],
                      ),
                      () {}),
                  _item2(
                      Row(
                        children: [
                          Image.asset(
                            getImagePath('mine_sex_man'),
                            width: 26.w,
                            height: 26.w,
                          ),
                          SizedBox(width: 8.w),
                          Expanded(
                              child: Text(
                            '显示男性信息',
                            textAlign: TextAlign.start,
                            style:
                                TextStyle(color: Colors.white, fontSize: 15.sp),
                          )),
                          GetBuilder<MineC>(
                              id: "mine_info",
                              builder: (c) {
                                return CupertinoSwitch(
                                    activeColor: C.FEC693,
                                    value: c.isShowManInfo,
                                    onChanged: (onChanged) {
                                      controller.setMan(onChanged);
                                    });
                              })
                        ],
                      ),
                      () {}),
                  _item2(
                      Row(
                        children: [
                          Image.asset(
                            getImagePath('mine_voideo'),
                            width: 26.w,
                            height: 26.w,
                          ),
                          SizedBox(width: 8.w),
                          Text(
                            '视屏通话设置',
                            textAlign: TextAlign.start,
                            style:
                                TextStyle(color: Colors.white, fontSize: 15.sp),
                          ),
                          Expanded(
                            child: GetBuilder<MineC>(
                                id: 'price',
                                builder: (context) {
                                  return Text(
                                    '${controller.videoPrice}金币/分钟',
                                    textAlign: TextAlign.end,
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 15.sp),
                                  );
                                }),
                          ),
                        ],
                      ), () {
                    showVideoPriceDialog(price: controller.videoPrice)
                        .then((value) {
                      if (value != null) {
                        controller.setVideo(value);
                      }
                    });
                  }),
                  _item2(
                      Row(
                        children: [
                          Image.asset(
                            getImagePath('mine_voice'),
                            width: 26.w,
                            height: 26.w,
                          ),
                          SizedBox(width: 8.w),
                          Text(
                            '语音通话设置',
                            textAlign: TextAlign.start,
                            style:
                                TextStyle(color: Colors.white, fontSize: 15.sp),
                          ),
                          Expanded(
                            child: GetBuilder<MineC>(
                                id: 'price',
                                builder: (context) {
                                  return Text(
                                    '${controller.voicePrice}金币/分钟',
                                    textAlign: TextAlign.end,
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 15.sp),
                                  );
                                }),
                          ),
                        ],
                      ), () {
                    showVideoPriceDialog(price: controller.voicePrice)
                        .then((value) {
                      if (value != null) {
                        controller.setVoice(value);
                      }
                    });
                  }),
                  _item2(
                      Row(
                        children: [
                          Image.asset(
                            getImagePath('mine_invit'),
                            width: 26.w,
                            height: 26.w,
                          ),
                          SizedBox(width: 8.w),
                          Expanded(
                              child: Text(
                            '邀请好友',
                            textAlign: TextAlign.start,
                            style:
                                TextStyle(color: Colors.white, fontSize: 15.sp),
                          )),
                          Icon(
                            Icons.navigate_next,
                            color: Colors.white,
                            size: 13.w,
                          )
                        ],
                      ),
                      () {}),
                ],
              )),
        ],
      ),
    );
  }

  Widget _item2(Widget child, GestureTapCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10.w),
        margin: EdgeInsets.symmetric(vertical: 4.h),
        height: 40.h,
        child: child,
      ),
    );
  }

  Widget _item1(String iconName, String itemName, GestureTapCallback callback) {
    return Expanded(
        child: Column(
      children: [
        InkWell(
          onTap: callback,
          child: Image.asset(
            getImagePath(iconName),
            width: 46.w,
            height: 46.w,
          ),
        ),
        SizedBox(
          height: 8.h,
        ),
        Text(
          itemName,
          style: TextStyle(color: Colors.white, fontSize: 13.sp),
        )
      ],
    ));
  }
}
