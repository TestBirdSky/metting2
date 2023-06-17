import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:metting/base/BaseStatelessPage.dart';
import 'package:metting/page/call/video_chat_controller.dart';
import 'package:metting/tool/view_tools.dart';
import '../../widget/image_m.dart';
import 'call_bean.dart';

class VideoChatPage extends BaseStatelessPage<VideoChatController> {
  VideoChatPage({
    required this.callBean,
  });

  late CallBean callBean;

  @override
  Widget createBody(BuildContext context) {
    return Stack(
      children: [
        _video(),
        _tips(),
        _timer(),
        _bottomBtn(),
      ],
    );
  }

  Widget _tips() {
    return GetBuilder<VideoChatController>(
        id: 'remoteVideo',
        builder: (c) {
          return Stack(children: [
            Align(
              alignment: Alignment.center,
              child: c.remoteUid == null && callBean.isReceive
                  ? _widgetPersonIcon()
                  : Text(''),
            ),
            Align(
              alignment: Alignment.topCenter,
              child: Padding(
                padding: EdgeInsets.only(top: 90.h),
                child: c.remoteUid == null
                    ? Text(
                        callBean.isReceive ? '' : '正在呼叫...',
                        style: TextStyle(color: Colors.white, fontSize: 14.sp),
                      )
                    : Text(''),
              ),
            )
          ]);
        });
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
          "${callBean.userName} 邀请您视频通话",
          style: TextStyle(color: Colors.white, fontSize: 16.sp),
        ),
        Expanded(flex: 3, child: Text('')),
      ],
    );
  }

  Widget _timer() {
    return GetBuilder<VideoChatController>(
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
    return GetBuilder<VideoChatController>(
        id: 'videoJoin',
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
                        Expanded(flex: 3, child: Text('')),
                        _videoButton(),
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
                getImagePath('ic_agree_video'),
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

  Widget _videoButton() {
    return SizedBox(
      width: 44.h,
      height: 44.h,
      child: StatefulBuilder(builder: (context, state) {
        return GestureDetector(
          onTap: () {
            controller.changeVideoStatus();
            state(() {});
          },
          child: Column(
            children: [
              Image.asset(
                getImagePath(
                    controller.isOpenVideo ? "ic_video_on" : "ic_video_off"),
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
                getImagePath(
                    controller.isOpenMirc ? "ic_mir_on" : "ic_mir_off"),
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

  @override
  VideoChatController initController() => VideoChatController(callBean);

  Widget _video() {
    return GetBuilder<VideoChatController>(
        id: "videoToggle",
        builder: (c) {
          return c.isCenterMine
              ? Stack(
                  children: [
                    _mineVideo(),
                    _remoteVideo(),
                  ],
                )
              : Stack(
                  children: [
                    _remoteVideo(),
                    _mineVideo(),
                  ],
                );
        });
  }

  Widget _mineVideo() {
    return Align(
      alignment: Alignment.topRight,
      child: GetBuilder<VideoChatController>(
          id: 'mineVideo',
          builder: (c) {
            return Container(
              margin: c.isCenterMine
                  ? EdgeInsets.all(0)
                  : EdgeInsets.symmetric(vertical: 90.h, horizontal: 24.w),
              width: !c.isCenterMine ? 120.w : double.infinity,
              height: !c.isCenterMine ? 180.h : double.infinity,
              child: Center(
                child: controller.isOpenVideo && controller.localUserJoined
                    ? GestureDetector(
                        onTap: () {
                          if (!c.isCenterMine) {
                            controller.toggleCenterVideo();
                          }
                        },
                        child: AgoraVideoView(
                          controller: VideoViewController(
                            rtcEngine: controller.engine,
                            canvas: VideoCanvas(uid: 0),
                          ),
                        ),
                      )
                    : Container(
                        color: Colors.transparent,
                      ),
              ),
            );
          }),
    );
  }

  Widget _remoteVideo() {
    return Align(
      alignment: Alignment.topRight,
      child: GetBuilder<VideoChatController>(
          id: 'remoteVideo',
          builder: (c) {
            if (c.remoteUid != null) {
              return Container(
                margin: c.isCenterMine
                    ? EdgeInsets.symmetric(vertical: 90.h, horizontal: 24.w)
                    : EdgeInsets.all(0),
                width: c.isCenterMine ? 120.w : double.infinity,
                height: c.isCenterMine ? 180.h : double.infinity,
                child: GestureDetector(
                  onTap: () {
                    if (c.isCenterMine) {
                      controller.toggleCenterVideo();
                    }
                  },
                  child: AgoraVideoView(
                    controller: VideoViewController.remote(
                      rtcEngine: c.engine,
                      canvas: VideoCanvas(uid: c.remoteUid!),
                      connection: RtcConnection(channelId: callBean.channelId),
                    ),
                  ),
                ),
              );
            } else {
              return const Text('');
            }
          }),
    );
  }
}
