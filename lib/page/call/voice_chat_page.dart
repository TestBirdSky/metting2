import 'dart:async';
import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:metting/page/call/voice_chat_controller.dart';
import 'package:metting/widget/image_m.dart';

import '../../base/BaseStatelessPage.dart';
import '../../base/base_chat_controller.dart';
import '../../network/http_helper.dart';
import '../../tool/emc_helper.dart';
import '../../tool/log.dart';
import '../../tool/view_tools.dart';
import '../../widget/my_toast.dart';
import 'call_bean.dart';

class VoiceChatPage extends BaseStatelessPage<VoiceChatController> {
  VoiceChatPage({
    required this.callBean,
  });

  late CallBean callBean;

  @override
  Widget createBody(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [_widgetPersonIcon(), _topInfo(), _timer(), _bottomBtn()],
    );
  }

  @override
  VoiceChatController initController() => VoiceChatController(callBean);

  Widget _timer() {
    return GetBuilder<VoiceChatController>(
        id: "connectedTime",
        builder: (builder) {
          return Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              margin: EdgeInsets.only(bottom: 190.h),
              child: Text(
                controller.mConnectedTime,
                style: TextStyle(color: Colors.white, fontSize: 14.sp),
              ),
            ),
          );
        });
  }

  Widget _bottomBtn() {
    return GetBuilder<VoiceChatController>(
        id: 'join',
        builder: (c) {
          return c.callBean.isReceive && !c.isAllowJoin
              ? _receiveView()
              : Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    height: 180.h,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Expanded(flex: 3, child: Text('')),
                        _hfButton(),
                        Expanded(flex: 2, child: Text('')),
                        GestureDetector(
                          onTap: () {
                            controller.disconnected();
                            _onBack();
                          },
                          child: Image.asset(
                            getImagePath('ic_disconnect_call'),
                            width: 95.w,
                            height: 36.h,
                          ),
                        ),
                        Expanded(flex: 2, child: Text('')),
                        _mircButton(),
                        Expanded(flex: 3, child: Text('')),
                      ],
                    ),
                  ),
                );
        });
  }

  Widget _receiveView() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        height: 180.h,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Expanded(flex: 2, child: Text('')),
            GestureDetector(
              onTap: () {
                controller.disAllow();
                _onBack();
              },
              child: Image.asset(
                getImagePath('ic_refuse_chat'),
                width: 60.w,
                height: 60.w,
              ),
            ),
            const Expanded(flex: 3, child: Text('')),
            GestureDetector(
              onTap: () {
                controller.allow();
              },
              child: Image.asset(
                getImagePath('ic_agree_audio'),
                width: 60.w,
                height: 60.w,
              ),
            ),
            const Expanded(flex: 2, child: Text('')),
          ],
        ),
      ),
    );
  }



  Widget _hfButton() {
    return SizedBox(
      width: 44.h,
      height: 44.h,
      child: StatefulBuilder(builder: (context, state) {
        return GestureDetector(
          onTap: () {
            controller.changeHFStatus();
            state(() {});
          },
          child: Column(
            children: [
              Image.asset(
                getImagePath(controller.isOpenHF ? "ic_hf_open" : "ic_hf_close"),
                width: 44.h,
                height: 44.h,
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _mircButton() {
    return SizedBox(
      width: 44.h,
      height: 44.h,
      child: StatefulBuilder(builder: (context, state) {
        return GestureDetector(
          onTap: () {
            controller.changeMircStatus();
            state(() {});
          },
          child: Column(
            children: [
              Image.asset(
                getImagePath(controller.isOpenMirc ? "ic_mir_on" : "ic_mir_off"),
                width: 44.h,
                height: 44.h,
              ),
            ],
          ),
        );
      }),
    );
  }

  void _onBack() {
    Get.back();
  }

  Widget _widgetPersonIcon() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(flex: 1, child: Text('')),
        Container(
          height: 248.w,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Image.asset(
                getImagePath(
                  'ic_red_circle',
                ),
                fit: BoxFit.fill,
                width: 248.w,
                height: 248.w,
              ),
              Padding(
                padding: EdgeInsets.all(0.h),
                child: ClipOval(
                  child: Container(
                    width: 115.w,
                    height: 115.w,
                    padding: EdgeInsets.all(1.w),
                    child:
                        circleNetworkWidget(callBean.userAvator, 115.w, 115.w),
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 15.h,
        ),
        Text(
          callBean.userName,
          style: TextStyle(color: Colors.white, fontSize: 16.sp),
        ),
        Expanded(flex: 3, child: Text('')),
      ],
    );
  }

  Widget _topInfo() {
    return GetBuilder<VoiceChatController>(
        id: 'page',
        builder: (c) {
          return Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: EdgeInsets.only(top: 90.h),
              child: Text(
                c.getTitle(),
                style: TextStyle(color: Colors.white, fontSize: 14.sp),
              ),
            ),
          );
        });
  }
}
