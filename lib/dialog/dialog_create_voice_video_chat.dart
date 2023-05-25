import 'package:get/get.dart';
import 'package:metting/page/call/call_bean.dart';
import 'package:metting/page/call/video_chat_page.dart';
import 'package:metting/tool/log.dart';
import 'package:metting/widget/loading.dart';

import '../network/http_helper.dart';
import '../widget/bottom_popup.dart';

void showDialogCreateVideoOrVoiceChatWithUser(
    String voicePrice, String videoPrice, CallBean callBean) {
  showBottomVideoOrVoiceChoice(
    () async {
      LoadingUtils.showLoading();
      final data = await createVideoWithUser(callBean.uid);
      if (data.isOk()) {
        Get.to(VideoChatPage(callBean: callBean));
      } else {}
      LoadingUtils.dismiss();
    },
    () async {
      LoadingUtils.showLoading();
      final data = await createVoiceWithUser(callBean.uid);
      if (data.isOk()) {
      } else {}
      LoadingUtils.dismiss();
    },
    action1Str: "视频通话($videoPrice金币/分钟)",
    action2Str: "语音通话($voicePrice金币/分钟)",
  );
}

void showDialogCreateVideoOrVoiceChatWithListener(
    String voicePrice, String videoPrice, num uid) {
  showBottomVideoOrVoiceChoice(
    () async {
      LoadingUtils.showLoading();
      final data = await createVideoWithListener(uid);
      if (data.isOk()) {
      } else {}
      LoadingUtils.dismiss();
    },
    () async {
      LoadingUtils.showLoading();
      final data = await createVoiceWithUser(uid);
      if (data.isOk()) {
      } else {}
      LoadingUtils.dismiss();
    },
    action1Str: "视频通话($videoPrice金币/分钟)",
    action2Str: "语音通话($voicePrice金币/分钟)",
  );
}
