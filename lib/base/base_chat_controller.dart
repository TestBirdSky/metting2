import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter/material.dart';
import 'package:metting/base/BaseController.dart';
import 'package:metting/tool/log.dart';

import '../tool/agora_helper.dart';

abstract class BaseChatController extends BaseController {
  late RtcEngine engine;

  late RtcEngineEventHandler _rtcEngineEventHandler;

  void initAgoraFinish();

  @override
  void onInit() {
    super.onInit();
    logger.i("onInit--->");
    _initAgora();
  }

  Future<void> _initAgora() async {
    engine = createAgoraRtcEngine();
    await engine.initialize(const RtcEngineContext(
      appId: appId,
      channelProfile: ChannelProfileType.channelProfileCommunication,
    ));
    _rtcEngineEventHandler = RtcEngineEventHandler(
        onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
      debugPrint("local user ${connection.localUid} joined");
      onMineJoinChannelSuccess(connection, elapsed);
    }, onUserJoined: (RtcConnection connection, int remoteUid, int elapsed) {
      debugPrint("remote user $remoteUid joined");
      onUserJoinChannelSuccess(connection, remoteUid);
    }, onUserOffline: (RtcConnection connection, int remoteUid,
            UserOfflineReasonType reason) {
      debugPrint("remote user $remoteUid left channel");
      onUserOffline(connection, remoteUid);
    }, onError: (ErrorCodeType err, String msg) {
      logger.e('ErrorCodeType $err   --$msg');
    });
    engine.registerEventHandler(_rtcEngineEventHandler);
    initAgoraFinish();
  }

  void onMineJoinChannelSuccess(RtcConnection connection, int elapsed) {}

  void onUserJoinChannelSuccess(RtcConnection connection, int remoteUid) {}

  void onUserOffline(RtcConnection connection, int remoteUid) {}

  @override
  void dispose() {
    logger.i("dispose--->");
    super.dispose();
  }

  @override
  void onClose() {
    logger.i("onClose--->");
    engine.disableVideo();
    engine.disableAudio();
    engine.leaveChannel();
    engine.unregisterEventHandler(_rtcEngineEventHandler);
    super.onClose();
  }
}
