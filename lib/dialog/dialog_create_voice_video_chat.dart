import 'package:get/get.dart';
import 'package:metting/page/call/call_bean.dart';
import 'package:metting/page/call/video_chat_page.dart';
import 'package:metting/page/call/voice_chat_page.dart';
import 'package:metting/tool/emc_helper.dart';
import 'package:metting/widget/loading.dart';
import 'package:permission_handler/permission_handler.dart';

import '../network/http_helper.dart';
import '../widget/bottom_popup.dart';

void showDialogCreateVideoOrVoiceChatWithUser(
    String voicePrice, String videoPrice, CallBean callBean) {
  showBottomVideoOrVoiceChoice(
    () async {
      final status = await Permission.microphone.request();
      final status2 = await Permission.camera.request();
      if (status.isGranted && status2.isGranted) {
        LoadingUtils.showLoading();
        final data = await createVideoWithUser(callBean.uid);
        if (data.isOk()) {
          callBean.channelId = data.data?.id ?? "";
          callBean.token = data.data?.token ?? "";
          await EmcHelper.sendVideoMessage(
              callBean.token, callBean.channelId, "${callBean.uid}");
          Get.to(VideoChatPage(callBean: callBean));
        } else {}
        LoadingUtils.dismiss();
      }
    },
    () async {
      final status = await Permission.microphone.request();
      if (status.isGranted) {
        LoadingUtils.showLoading();
        final data = await createVoiceWithUser(callBean.uid);
        if (data.isOk()) {
          callBean.channelId = data.data?.id ?? "";
          callBean.token = data.data?.token ?? "";
          await EmcHelper.sendAudioMessage(
              callBean.token, callBean.channelId, "${callBean.uid}");
          Get.to(VoiceChatPage(callBean: callBean));
        } else {}
        LoadingUtils.dismiss();
      }
    },
    action1Str: "视频通话($videoPrice金币/分钟)",
    action2Str: "语音通话($voicePrice金币/分钟)",
  );
}

void showDialogCreateVideoOrVoiceChatWithListener(
    String voicePrice, String videoPrice, CallBean callBean) {
  showBottomVideoOrVoiceChoice(
    () async {
      final status = await Permission.microphone.request();
      final status2 = await Permission.camera.request();
      if (status.isGranted && status2.isGranted) {
        LoadingUtils.showLoading();
        final data = await createVideoWithListener(callBean.uid);
        if (data.isOk()) {
          callBean.channelId = data.data?.id ?? "";
          await EmcHelper.sendVideoMessage(
              callBean.token, callBean.channelId, "${callBean.uid}");
          Get.to(VideoChatPage(callBean: callBean));
        } else {}
        LoadingUtils.dismiss();
      }
    },
    () async {
      final status = await Permission.microphone.request();
      if (status.isGranted) {
        LoadingUtils.showLoading();
        final data = await createVoiceWithUser(callBean.uid);
        if (data.isOk()) {
          callBean.channelId = data.data?.id ?? "";
          await EmcHelper.sendAudioMessage(
              callBean.token, callBean.channelId, "${callBean.uid}");
          Get.to(VoiceChatPage(callBean: callBean));
        } else {}
        LoadingUtils.dismiss();
      }
    },
    action1Str: "视频通话($videoPrice金币/分钟)",
    action2Str: "语音通话($voicePrice金币/分钟)",
  );
}
