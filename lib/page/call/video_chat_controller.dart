import 'dart:async';
import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:get/get.dart';
import 'package:metting/page/call/call_bean.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:scroll_date_picker/scroll_date_picker.dart';

import '../../base/base_chat_controller.dart';
import '../../network/http_helper.dart';
import '../../tool/emc_helper.dart';
import '../../tool/log.dart';
import '../../widget/my_toast.dart';

class VideoChatController extends BaseChatController {
  VideoChatController(this.callBean);

  late CallBean callBean;
  bool isOpenVideo = true;
  bool isOpenMirc = true;
  bool localUserJoined = false;
  int? remoteUid;
  bool isAllowJoin = false;
  Timer? mTimer;
  Timer? mWaitTimer;
  String mConnectedTime = "";
  bool isCenterMine = false;

  void changeVideoStatus() {
    isOpenVideo = !isOpenVideo;
    engine.enableLocalVideo(isOpenVideo);
    update(['mineVideo']);
  }

  void changeMircStatus() {
    isOpenMirc = !isOpenMirc;
    engine.muteLocalAudioStream(!isOpenMirc);
  }

  void toggleCenterVideo() {
    isCenterMine = !isCenterMine;
    update(['videoToggle']);
  }

  @override
  void onInit() {
    super.onInit();
    logger.i('message --->$callBean');
    _timeoutWait();
  }

  @override
  void initAgoraFinish() async {
    await [Permission.microphone, Permission.camera].request();
    if (!callBean.isReceive) {
      join();
    }
    logger.i('initAgoraFinish${callBean.token}--${callBean.channelId}');
  }

  void disAllow() {
    EmcHelper.sendDisAgreeChatMessage("${callBean.uid}");
  }

  void disconnected() {
    if (!callBean.isReceive && remoteUid == null) {
      EmcHelper.sendCancelChatMessage("${callBean.uid}");
    }
  }

  void allow() {
    join();
    isAllowJoin = true;
    update(['videoJoin']);
  }

  void join() async {
    await engine.enableVideo();
    await engine.enableAudio();
    await engine.startPreview();
    engine.joinChannel(
      token: callBean.token,
      channelId: callBean.channelId,
      options: const ChannelMediaOptions(
          clientRoleType: ClientRoleType.clientRoleBroadcaster),
      uid: 0,
    );
  }

  @override
  void onMineJoinChannelSuccess(RtcConnection connection, int elapsed) {
    super.onMineJoinChannelSuccess(connection, elapsed);
    localUserJoined = true;
    update(['mineVideo']);
  }

  @override
  void onUserJoinChannelSuccess(RtcConnection connection, int uid) {
    super.onUserJoinChannelSuccess(connection, uid);
    remoteUid = uid;
    update(['remoteVideo']);
    mWaitTimer?.cancel();
    _startTimer();
  }

  @override
  void onUserOffline(RtcConnection connection, int uid) {
    super.onUserOffline(connection, uid);
    remoteUid = null;
    Get.back();
  }

  @override
  void onClose() {
    super.onClose();
    mTimer?.cancel();
    mWaitTimer?.cancel();
  }

  void _startTimer() {
    int time = 0;
    bool isNeedUpdate = !callBean.isReceive;
    mTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      time++;
      if (isNeedUpdate && time % 60 == 0) {
        _checkMoney();
      }
      _updateCount(time);
    });
  }

  void _checkMoney() async {
    final dat = await updateChatStatusOneMin(int.parse(callBean.channelId));
    if (!dat.isOk()) {
      logger.i('金币不足');
      Get.back();
    }
  }

  void _updateCount(int count) {
    int min = count ~/ 60;
    int second = count % 60;
    if (min < 10) {
      mConnectedTime = "0$min : ${second < 10 ? "0$second" : second}";
    } else {
      mConnectedTime = "$min : ${second < 10 ? "0$second" : second}";
    }
    update(['connectedTime']);
  }

  void _timeoutWait() {
    if (!callBean.isReceive) {
      mWaitTimer = Timer(Duration(seconds: 30), () {
        MyToast.show('对方暂未接听!');
        Get.back();
      });
    }
  }
}
