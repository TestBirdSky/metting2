import 'package:metting/widget/loading.dart';

import '../network/http_helper.dart';
import '../widget/bottom_popup.dart';

void showDialogCreateVideoOrVoiceChatWithUser(
    String voicePrice, String videoPrice, num uid) {
  showBottomVideoOrVoiceChoice(
    () async {
      LoadingUtils.showLoading();
      final data = await createVideoWithUser(uid);
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

void showDialogCreateVideoOrVoiceChatWithListener(
    String voicePrice, String videoPrice, num uid) {
  showBottomVideoOrVoiceChoice(
    () async {
      LoadingUtils.showLoading();
    },
    () async {},
    action1Str: "视频通话($videoPrice金币/分钟)",
    action2Str: "语音通话($voicePrice金币/分钟)",
  );
}
