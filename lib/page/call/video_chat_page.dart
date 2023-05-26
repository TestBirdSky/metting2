import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:metting/base/BaseController.dart';
import 'package:metting/base/base_chat_page.dart';
import 'package:metting/tool/view_tools.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:scroll_date_picker/scroll_date_picker.dart';

import '../../tool/agora_helper.dart';
import 'call_bean.dart';

class VideoChatPage extends BaseChatPage<VideoChatController> {
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
      }
    );
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

  var _isOpenVideo = true;
  var _isOpenMirc = true;

  Widget _videoButton() {
    return StatefulBuilder(builder: (context, state) {
      return GestureDetector(
        onTap: () {
          _isOpenVideo = !_isOpenVideo;
          state(() {});
          engine.enableLocalVideo(_isOpenVideo);
          controller.update(['mineVideo']);
        },
        child: Column(
          children: [
            Image.asset(
              getImagePath(_isOpenVideo ? "ic_video_on" : "ic_video_off"),
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
          _isOpenMirc = !_isOpenMirc;
          state(() {});
          engine.enableLocalAudio(_isOpenMirc);
        },
        child: Column(
          children: [
            Image.asset(
              getImagePath(_isOpenMirc ? "ic_mir_on" : "ic_mir_off"),
              width: 44.h,
              height: 44.h,
            ),
          ],
        ),
      );
    });
  }

  void _onBack() {
    engine.disableVideo();
    engine.disableAudio();
    engine.leaveChannel();
    Get.back();
  }

  @override
  VideoChatController initController() => VideoChatController();

  @override
  void initAgoraFinish() async {
    await [Permission.microphone, Permission.camera].request();
    _registerEventHandler();
    await engine.enableVideo();
    await engine.startPreview();
    // 加入频道，设置用户角色为主播
    await engine.joinChannel(
      token: token,
      channelId: channel,
      options: const ChannelMediaOptions(
          clientRoleType: ClientRoleType.clientRoleBroadcaster),
      uid: 0,
    );
  }

  void _registerEventHandler() {
    engine.registerEventHandler(
      RtcEngineEventHandler(
        onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
          debugPrint("local user ${connection.localUid} joined");
          _localUser(true);
        },
        onUserJoined: (RtcConnection connection, int remoteUid, int elapsed) {
          debugPrint("remote user $remoteUid joined");
          _updateRemoteUid(remoteUid);
        },
        onUserOffline: (RtcConnection connection, int remoteUid,
            UserOfflineReasonType reason) {
          debugPrint("remote user $remoteUid left channel");
          _updateRemoteUid(null);
        },
      ),
    );
  }

  void _updateRemoteUid(int? uid) {
    _remoteUid = null;
    controller.update(['video']);
  }

  void _localUser(bool isJoined) {
    _localUserJoined = isJoined;
    controller.update(['mineVideo']);
  }

  bool _localUserJoined = false;

  int? _remoteUid;

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
                child: _isOpenVideo && _localUserJoined
                    ? AgoraVideoView(
                        controller: VideoViewController(
                          rtcEngine: engine,
                          canvas: const VideoCanvas(uid: 0),
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
          id: 'video',
          builder: (c) {
            if (_remoteUid != null) {
              return AgoraVideoView(
                controller: VideoViewController.remote(
                  rtcEngine: engine,
                  canvas: VideoCanvas(uid: _remoteUid),
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

class VideoChatController extends BaseController {

}
