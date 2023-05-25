import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

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
      children: [

        _bottomBtn()
      ],
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
  var _isOpneMirc = true;

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
          _isOpneMirc = !_isOpneMirc;
          state(() {});
        },
        child: Column(
          children: [
            Image.asset(
              getImagePath(_isOpneMirc ? "ic_mir_on" : "ic_mir_off"),
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
}

class VoiceChatController extends BaseController {}
