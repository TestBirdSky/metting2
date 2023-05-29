import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:metting/base/BaseController.dart';
import 'package:metting/base/BaseStatelessPage.dart';
import 'package:metting/base/base_chat_page.dart';
import 'package:metting/tool/log.dart';
import 'package:metting/tool/view_tools.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:scroll_date_picker/scroll_date_picker.dart';

import '../../base/base_chat_controller.dart';
import '../../tool/agora_helper.dart';
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
        _remoteVideo(),
        _mineVideo(),
        _title(),
        _bottomBtn(),
      ],
    );
  }

  Widget _title() {
    return GetBuilder<VideoChatController>(
        id: 'title',
        builder: (c) {
          return Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: EdgeInsets.only(top: 90.h),
              child: Text(
                '正在呼叫...',
                style: TextStyle(color: Colors.white, fontSize: 14.sp),
              ),
            ),
          );
        });
  }

  Widget _bottomBtn() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        height: 160.h,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _videoButton(),
            SizedBox(
              width: 30.w,
            ),
            GestureDetector(
              onTap: () {
                _onBack();
              },
              child: Image.asset(
                getImagePath('ic_disconnect_call'),
                width: 95.w,
                height: 36.h,
              ),
            ),
            SizedBox(
              width: 30.w,
            ),
            _mircButton()
          ],
        ),
      ),
    );
  }

  Widget _videoButton() {
    return StatefulBuilder(builder: (context, state) {
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
    });
  }

  Widget _mircButton() {
    return StatefulBuilder(builder: (context, state) {
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
    });
  }

  void _onBack() {
    Get.back();
  }

  @override
  VideoChatController initController() => VideoChatController(callBean);

  Widget _mineVideo() {
    return Align(
      alignment: Alignment.topRight,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 90.h, horizontal: 24.w),
        width: 120.w,
        height: 180.h,
        child: GetBuilder<VideoChatController>(
            id: 'mineVideo',
            builder: (c) {
              return Center(
                child: controller.isOpenVideo && controller.localUserJoined
                    ? AgoraVideoView(
                        controller: VideoViewController(
                          rtcEngine: controller.engine,
                          canvas: VideoCanvas(uid: 0),
                        ),
                      )
                    : Container(
                        color: Colors.black,
                      ),
              );
            }),
      ),
    );
  }

  Widget _remoteVideo() {
    return Container(
      width: double.infinity,
      height: double.infinity,
      child: GetBuilder<VideoChatController>(
          id: 'remoteVideo',
          builder: (c) {
            if (c.remoteUid != null) {
              return AgoraVideoView(
                controller: VideoViewController.remote(
                  rtcEngine: c.engine,
                  canvas: VideoCanvas(uid: c.remoteUid!),
                  connection: const RtcConnection(channelId: channel),
                ),
              );
            } else {
              return const Align(
                alignment: Alignment.center,
                child: Text(
                  'Please wait for remote user to join',
                  textAlign: TextAlign.center,
                ),
              );
            }
          }),
    );
  }
}

class VideoChatController extends BaseChatController {
  VideoChatController(this.callBean);

  late CallBean callBean;
  bool isOpenVideo = true;
  bool isOpenMirc = true;
  bool localUserJoined = false;
  int? remoteUid;
  int? localUid;

  void changeVideoStatus() {
    isOpenVideo = !isOpenVideo;
    engine.enableLocalVideo(isOpenVideo);
    update(['mineVideo']);
  }

  void changeMircStatus() {
    isOpenMirc = !isOpenMirc;
    engine.enableLocalAudio(isOpenMirc);
  }

  @override
  void initAgoraFinish() async {
    await [Permission.microphone, Permission.camera].request();
    await engine.enableVideo();
    await engine.startPreview();
    engine.joinChannel(
      token: callBean.token,
      channelId: callBean.channelId,
      // token: token,
      // channelId: channel,
      options: const ChannelMediaOptions(
          clientRoleType: ClientRoleType.clientRoleBroadcaster),
      uid: 0,
    );
    logger.i('initAgoraFinish${callBean.token}--${callBean.channelId}');
  }

  @override
  void onMineJoinChannelSuccess(RtcConnection connection, int elapsed) {
    super.onMineJoinChannelSuccess(connection, elapsed);
    localUid = connection.localUid;
    localUserJoined = true;
    update(['mineVideo']);
  }

  @override
  void onUserJoinChannelSuccess(RtcConnection connection, int uid) {
    super.onUserJoinChannelSuccess(connection, uid);
    remoteUid = uid;
    update(['remoteVideo']);
  }

  @override
  void onUserOffline(RtcConnection connection, int uid) {
    super.onUserOffline(connection, uid);
    remoteUid = null;
    update(['remoteVideo']);
  }
}
