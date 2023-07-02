import 'package:flutter/cupertino.dart';
import 'package:im_flutter_sdk/im_flutter_sdk.dart';

import '../../base/BaseController.dart';
import '../../database/get_storage_manager.dart';
import '../../network/bean/user_data_res.dart';
import '../../network/http_helper.dart';
import '../../tool/emc_helper.dart';
import '../../tool/log.dart';
import '../../tool/record_helper.dart';

class MessageChatController extends BaseController {
  MessageChatController(this.uid);

  RecordAudioHelper? _recordAudioHelper;
  List<EMMessage> listMessage = [];
  String uid;
  String minUid = getMineUID().toString();
  EMConversation? emConversation;
  UserDataRes? mUserData;

  UserDataRes? mineInfo = GStorage.getMineUserBasic();

  bool noMoreDate = true;
  bool isLoading = false;
  bool isRecordingVoice = false;
  bool isSelectedCancel = false;

  @override
  void onInit() {
    super.onInit();
    createOrGetConversation();
    mUserData = GStorage.getUserBasic(uid);
    _getUserInfo();
    _addMessageStatusEvent();
  }

  void sendTextMessage(String msg) async {
    if (msg.isEmpty) return;
    final mesage = await EmcHelper.sendTxtMessage(uid, msg);
    logger.i("sendTextMessage->${mesage.msgId}");
    listMessage.insert(0, mesage);
    update(['content']);
  }

  void resendMessage(EMMessage msg) async {
    msg = await EMClient.getInstance.chatManager.resendMessage(msg);
    update(['content']);
  }

  void delMessage(EMMessage msg) async {
    await EMClient.getInstance.chatManager.deleteRemoteMessagesWithIds(
        conversationId: emConversation?.id ?? uid,
        type: EMConversationType.Chat,
        msgIds: [msg.msgId]);
    listMessage.remove(msg);
    update(['content']);
  }

  void _getUserInfo() async {
    mUserData = (await getUserData(int.parse(uid))).data;
    if (mUserData != null) {
      GStorage.saveUserBasic(mUserData!);
    }
    update(['title']);
    update(['content']);
  }

  void createOrGetConversation() async {
    logger.i("message createOrGetConversation$uid");
    emConversation =
        await EmcHelper.getConversationMessage(int.parse(uid), getMineUID());
    logger.i("message$emConversation  -->${emConversation?.id} ");
    getMessage();
    emConversation?.markAllMessagesAsRead();
    EMClient.getInstance.chatManager.addEventHandler(
      uid,
      EMChatEventHandler(
        onMessagesReceived: (list) => {
          logger.i("onMessagesReceived${list.length}-->${list.first.from}-->"),
          if (list.isNotEmpty)
            {
              list.forEach((element) {
                if (element.from != "admin") {
                  logger.i("onMessagesReceived${list[0].body}");
                  // bool isNeed = EmcHelper.handleCallMessage(element);
                  if (!listMessage.contains(element)) {
                    listMessage.insert(0, element);
                  }
                }
              }),
              update(['content']),
            }
        },
      ),
    );
  }

  void getMessage() async {
    final list = await emConversation?.loadMessages(
            startMsgId: '', direction: EMSearchDirection.Up) ??
        [];
    if (list.isNotEmpty) {
      if (list.length >= 2) {
        list.sort((a, b) => b.serverTime.compareTo(a.serverTime));
      }
      listMessage.addAll(list);
      update(['content']);
    }
    noMoreDate = false;
    if (list.length < 20) {
      noMoreDate = true;
    }
  }

  void loadMessage() async {
    isLoading = true;
    final msgId = listMessage.last.msgId;
    final list = await emConversation?.loadMessages(
            startMsgId: msgId, direction: EMSearchDirection.Up) ??
        [];
    if (list.isNotEmpty) {
      if (list.length >= 2) {
        list.sort((a, b) => b.serverTime.compareTo(a.serverTime));
      }
      listMessage.addAll(list);
      update(['content']);
    }
    isLoading = false;
    noMoreDate = false;
    if (list.length < 20) {
      noMoreDate = true;
    }
  }

  @override
  void onClose() {
    super.onClose();
    logger.i("onClose$this");
    emConversation?.markAllMessagesAsRead();
    EMClient.getInstance.chatManager.removeEventHandler(uid);
    EMClient.getInstance.chatManager.clearMessageEvent();
  }

  void _addMessageStatusEvent() {
    EMClient.getInstance.chatManager.addMessageEvent(
      uid,
      ChatMessageEvent(
        // 收到成功回调之后，可以对发送的消息进行更新处理，或者其他操作。
        onSuccess: (msgId, msg) {
          logger.i("_addMessageStatusEvent msgId$msgId -msg-$msg");
          _updateMessageStatus(msgId, msg);
        },
        // 收到回调之后，可以将发送的消息状态进行更新，或者进行其他操作。
        onError: (msgId, msg, error) {
          // msgId 发送时的消息ID;
          // msg 发送失败的消息;
          // error 失败原因;
          logger.e("_addMessageStatusEvent msgId$msgId -msg-$msg");
          _updateMessageStatus(msgId, msg);
        },
        // 对于附件类型的消息，如图片，语音，文件，视频类型，上传或下载文件时会收到相应的进度值，表示附件的上传或者下载进度。
        onProgress: (msgId, progress) {
          // msgId 发送时的消息ID;
          // progress 进度;
        },
      ),
    );
  }

  void _updateMessageStatus(String msgId, EMMessage msg) {
    for (int i = 0; i < listMessage.length; i++) {
      final element = listMessage[i];
      if (element.msgId == msgId) {
        listMessage.removeAt(i);
        listMessage.insert(i, msg);
        break;
      }
    }
    update(['content']);
  }

  void startRecoding() {
    _recordAudioHelper ??= RecordAudioHelper();
    _recordAudioHelper?.startRecorder();
    isRecordingVoice = true;
    update(['recordVoice']);
  }

  void cancelRecoding() {
    _recordAudioHelper?.cancelRecording();
    isRecordingVoice = false;
    update(['recordVoice']);
  }

  void stopRecodingAndStartSend() async {
    isRecordingVoice = false;
    update(['recordVoice']);
    final filePath = await _recordAudioHelper?.stopRecording();
    if (filePath != null) {
      _sendVoiceMessage(filePath, _recordAudioHelper?.recorderTime ?? 0);
    }
  }

  String? curPlayMsgId;

  void playAudio(String msgId, EMVoiceMessageBody body) {
    if (curPlayMsgId == msgId) return;
    curPlayMsgId = msgId;
    _recordAudioHelper ??= RecordAudioHelper();
    _recordAudioHelper?.playVoice(body.localPath, () {
      logger.i(' playVoice  finish');
      curPlayMsgId = null;
      update(['content']);
    });
    update(['content']);
  }

  void _sendVoiceMessage(String filePath, int duration) async {
    final mesage =
        await EmcHelper.sendVoiceMessage(uid, filePath, duration: duration);
    logger.i("sendTextMessage->${mesage.msgId} --$mesage}");
    listMessage.insert(0, mesage);
    update(['content']);
  }

  void updateCancleStatus(bool isCancel){
    if(isCancel!=isSelectedCancel){
      isSelectedCancel=isCancel;
      update(['recordVoice']);
    }

  }
}
