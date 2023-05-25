import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:metting/base/BaseStatelessPage.dart';
import 'package:permission_handler/permission_handler.dart';

import '../tool/agora_helper.dart';

abstract class BaseChatPage<T> extends BaseStatelessPage<T> {
  late RtcEngine engine;

  @override
  void onInit() {
    super.onInit();
    _initAgora();
  }

// 初始化应用
  Future<void> _initAgora() async {
    // 获取权限
    await [Permission.microphone].request();
    // 创建 RtcEngine
    engine = await createAgoraRtcEngine();
    await engine.initialize(const RtcEngineContext(
      appId: appId,
      channelProfile: ChannelProfileType.channelProfileCommunication1v1,
    ));
    initAgoraFinish();
  }

   void initAgoraFinish();
}
