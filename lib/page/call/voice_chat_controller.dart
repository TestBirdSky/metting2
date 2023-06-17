import 'dart:async';

import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:get/get.dart';
import 'package:metting/page/call/call_bean.dart';

import '../../base/base_chat_controller.dart';
import '../../network/http_helper.dart';
import '../../tool/emc_helper.dart';
import '../../tool/log.dart';
import '../../widget/my_toast.dart';

class VoiceChatController extends BaseChatController {
  VoiceChatController(this.callBean);

  late CallBean callBean;
  bool localUserJoined = false;
  int? remoteUid;
  bool isAllowJoin = false;
  Timer? mTimer;
  Timer? mWaitTimer;
  String mConnectedTime = "";
  var isOpenHF = false;
  var isOpenMirc = true;
  String getTitle() {
    return !callBean.isReceive && remoteUid == null ? "正在呼叫..." : "";
  }

  void changeHFStatus() {
    isOpenHF = !isOpenHF;
    engine.setEnableSpeakerphone(isOpenHF);
  }

  void changeMircStatus() {
    isOpenMirc = !isOpenMirc;
    engine.muteLocalAudioStream(!isOpenMirc);
  }

  @override
  void onInit() {
    super.onInit();
    _timeoutWait();
  }

  @override
  void initAgoraFinish() {
    if (!callBean.isReceive) {
      joinChannel();
    }
  }

  void joinChannel() {
    engine.enableAudio();
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
    update(['page']);
  }

  @override
  void onUserJoinChannelSuccess(RtcConnection connection, int uid) {
    super.onUserJoinChannelSuccess(connection, uid);
    remoteUid = uid;
    update(['page']);
    mWaitTimer?.cancel();
    _startTimer();
  }

  @override
  void onUserOffline(RtcConnection connection, int uid) {
    super.onUserOffline(connection, uid);
    remoteUid = null;
    update(['remoteVideo']);
    Get.back();
  }

  void _startTimer() {
    int time = 0;
    bool isNeedUpdate = !callBean.isReceive;
    mTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (isNeedUpdate && time % 60 == 0) {
        _checkMoney();
      }
      time++;
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

  @override
  void onClose() {
    super.onClose();
    mWaitTimer?.cancel();
    mTimer?.cancel();
  }

  void _timeoutWait() {
    if (!callBean.isReceive) {
      mWaitTimer = Timer(Duration(seconds: 30), () {
        MyToast.show('对方暂未接听!');
        Get.back();
      });
    }
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
    joinChannel();
    isAllowJoin = true;
    update(['join']);
  }
}
