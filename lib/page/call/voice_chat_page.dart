import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:metting/widget/image_m.dart';

import '../../base/BaseController.dart';
import '../../base/base_chat_page.dart';
import '../../tool/agora_helper.dart';
import '../../tool/view_tools.dart';
import 'call_bean.dart';

class VoiceChatPage extends BaseChatPage<VoiceChatController> {
  VoiceChatPage({
    required this.callBean,
  });

  late CallBean callBean;

  @override
  Widget createBody(BuildContext context) {
    return Stack(
      children: [_widgetPersonIcon(), _topInfo(), _bottomBtn()],
    );
  }

  @override
  void initAgoraFinish() async {
    _registerEventHandler();
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
          // _localUser(true);
        },
        onUserJoined: (RtcConnection connection, int remoteUid, int elapsed) {
          debugPrint("remote user $remoteUid joined");
          // _updateRemoteUid(remoteUid);
          // setState(() {
          //   _remoteUid = remoteUid;
          // });
        },
        onUserOffline: (RtcConnection connection, int remoteUid,
            UserOfflineReasonType reason) {
          debugPrint("remote user $remoteUid left channel");
          // _updateRemoteUid(null);
        },
      ),
    );
  }

  @override
  VoiceChatController initController() => VoiceChatController();

  Widget _bottomBtn() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        height: 200.h,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _hfButton(),
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

  var _isOpenHF = false;
  var _isOpenMirc = true;

  Widget _hfButton() {
    return StatefulBuilder(builder: (context, state) {
      return GestureDetector(
        onTap: () {
          _isOpenHF = !_isOpenHF;
          state(() {});
        },
        child: Column(
          children: [
            Image.asset(
              getImagePath(_isOpenHF ? "ic_hf_open" : "ic_hf_close"),
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
    engine.leaveChannel();
    Get.back();
  }

  Widget _widgetPersonIcon() {
    return Align(
      alignment: Alignment.topCenter,
      child: Container(
        height: 248.w,
        width: 248.w,
        margin: EdgeInsets.only(top: 120.h),
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
                  child: GestureDetector(
                    onTap: () {
                      // PersonInfoDialog().showInfoDialog(controller.mineInfo!);
                    },
                    child:
                        circleNetworkWidget(callBean.userAvator, 108.w, 108.w),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _topInfo() {
    return GetBuilder<VoiceChatController>(
        id: 'title',
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

class VoiceChatController extends BaseController {
  String getTitle() {
    return "正在呼叫...";
  }
}
