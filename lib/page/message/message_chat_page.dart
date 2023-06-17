import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:im_flutter_sdk/im_flutter_sdk.dart';
import 'package:metting/base/BaseController.dart';
import 'package:metting/base/BaseUiPage.dart';
import 'package:metting/database/get_storage_manager.dart';
import 'package:metting/network/bean/user_data_res.dart';
import 'package:metting/tool/emc_helper.dart';
import 'package:metting/tool/log.dart';
import 'package:metting/widget/image_m.dart';

import '../../core/common_configure.dart';
import '../../dialog/dialog_create_voice_video_chat.dart';
import '../../network/http_helper.dart';
import '../../tool/view_tools.dart';
import '../call/call_bean.dart';

class MessageChatPage extends BaseUiPage<MessageChatController> {
  MessageChatPage({required super.title, required this.uid});

  final TextEditingController _controller = TextEditingController();

  late String uid;
  final ScrollController _scrollController = ScrollController();

  @override
  void onInit() {
    _scrollController.addListener(() {
      if (!controller.noMoreDate) {
        if (!controller.isLoading &&
            _scrollController.position.pixels >=
                _scrollController.position.maxScrollExtent * 4 / 5) {
          controller.loadMessage();
        }
      }
    });
  }

  @override
  Widget createBody(BuildContext context) {
    return Stack(
      children: [
        Column(
          children: [Expanded(child: contentW()), _bottomWidget()],
        ),
        Padding(
          padding: EdgeInsets.only(right: 16.w),
          child: Align(
            alignment: Alignment.centerRight,
            child: GestureDetector(
              onTap: () {
                showDialogCreateVideoOrVoiceChatWithUser(
                    "${controller.mUserData?.voiceCall}",
                    "${controller.mUserData?.videoCall}",
                    CallBean(
                        userAvator: controller.mUserData?.avatar ?? "",
                        userName: controller.mUserData?.cname ?? "",
                        uid: controller.mUserData?.uid ?? 0));
              },
              child: Image.asset(
                getImagePath('mine_phone'),
                width: 52.w,
                height: 52.w,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget contentW() {
    return GetBuilder<MessageChatController>(
        id: 'content',
        builder: (context) {
          return ListView(
            reverse: true,
            shrinkWrap: true,
            padding: EdgeInsets.only(top: 20),
            controller: _scrollController,
            children: _getItem(),
          );
        });
  }

  List<Widget> _getItem() {
    final list = <Widget>[];
    for (var element in controller.listMessage) {
      list.add(_messageClass(element));
    }
    return list;
  }

  Widget _messageClass(EMMessage msg) {
    Widget widget = Text('');
    switch (msg.body.type) {
      case MessageType.TXT:
        {
          EMTextMessageBody body = msg.body as EMTextMessageBody;
          final text = Text(
            body.content,
            style: TextStyle(fontSize: 15.sp, color: Colors.white),
          );
          if (msg.from == uid) {
            widget = _itemTextLeft(text);
          } else {
            widget = _itemRight(text);
          }
        }
        break;
      case MessageType.CUSTOM:
        {
          EMCustomMessageBody body = msg.body as EMCustomMessageBody;
          switch (body.event) {
            case CustomEvent.VIDEO:
              if (msg.from == uid) {
                widget = _itemTextLeft(_videoItem());
              } else {
                widget = _itemRight(_videoItem());
              }
              break;
            case CustomEvent.AUDIO:
              if (msg.from == uid) {
                widget = _itemTextLeft(_audioItem());
              } else {
                widget = _itemRight(_audioItem());
              }
              break;
          }
        }
        break;
    }
    return widget;
  }

  Widget _audioItem() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          '语音通话',
          style: TextStyle(fontSize: 15.sp, color: Colors.white),
        ),
        SizedBox(
          width: 10.w,
        ),
        Icon(
          Icons.phone_missed,
          color: Colors.white,
          size: 24.h,
        ),
      ],
    );
  }

  Widget _videoItem() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          '视频通话',
          style: TextStyle(fontSize: 15.sp, color: Colors.white),
        ),
        SizedBox(
          width: 10.w,
        ),
        Icon(
          Icons.phone_missed,
          color: Colors.white,
          size: 24.h,
        ),
      ],
    );
  }

  Widget _itemTextLeft(Widget content) {
    return Container(
      padding: EdgeInsets.only(left: 12.w, bottom: 10.h),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 46.h,
            width: 46.h,
            child: circleNetworkWidget(
                "${controller.mUserData?.avatar}", 46.h, 46.h),
          ),
          SizedBox(
            width: 6.w,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Row(
                children: [
                  ConstrainedBox(
                    constraints:
                        BoxConstraints(maxWidth: contentWidth, minHeight: 40.h),
                    child: Container(
                      margin: EdgeInsets.only(top: 6.h),
                      padding:
                          EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
                      decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.all(Radius.circular(5.w))),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [content],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  final contentWidth = (ScreenUtil().screenWidth - 120.w);

  Widget _itemRight(Widget content) {
    return Container(
      padding: EdgeInsets.only(right: 12.w, bottom: 10.h),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Row(
                textDirection: TextDirection.rtl,
                children: [
                  ConstrainedBox(
                    constraints:
                        BoxConstraints(maxWidth: contentWidth, minHeight: 40.h),
                    child: Container(
                      margin: EdgeInsets.only(top: 6.h),
                      padding:
                          EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
                      decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.all(Radius.circular(5.w))),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [content],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(
            width: 6.w,
          ),
          SizedBox(
            height: 46.h,
            width: 46.h,
            child: circleNetworkWidget(
                "${controller.mineInfo?.avatar}", 46.h, 46.h),
          )
        ],
      ),
    );
  }

  Widget _bottomWidget() {
    return Container(
      height: 76.h,
      padding: EdgeInsets.symmetric(horizontal: 12.w),
      color: Colors.black,
      child: Row(
        children: [
          Expanded(
              child: Container(
            height: 46.h,
            padding: EdgeInsets.symmetric(horizontal: 10.w),
            decoration: BoxDecoration(
                color: C.PAGE_THEME_BG,
                borderRadius: BorderRadius.all(Radius.circular(8.w))),
            child: TextField(
              textAlignVertical: TextAlignVertical.top,
              style: TextStyle(
                fontSize: 18.sp,
                color: C.whiteFFFFFF,
              ),
              decoration: const InputDecoration(
                  filled: false,
                  contentPadding: EdgeInsets.all(0),
                  counterText: '',
                  //此处控制最大字符是否显示
                  alignLabelWithHint: true,
                  enabledBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Color(0x00FEC693), width: 0)),
                  focusedBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Color(0x00FEC693), width: 0))),
              onChanged: (value) {},
              controller: _controller,
            ),
          )),
          SizedBox(
            width: 10.w,
          ),
          Container(
            height: 46.h,
            width: 68.w,
            decoration: BoxDecoration(
                color: const Color(0xFFFEC693),
                borderRadius: BorderRadius.all(Radius.circular(12.w))),
            child: TextButton(
                onPressed: () {
                  final text = _controller.text;
                  controller.sendTextMessage(text);
                  _controller.clear();
                },
                child: Text(
                  '发 送',
                  style: TextStyle(color: Colors.white, fontSize: 16.sp),
                )),
          )
        ],
      ),
    );
  }

  @override
  MessageChatController initController() => MessageChatController(uid);

  @override
  Widget? titleWidget() {
    return GetBuilder<MessageChatController>(
        id: "title",
        builder: (c) {
          return Text(
            controller.mUserData?.cname ?? title,
            style: TextStyle(color: C.whiteFFFFFF, fontSize: 18.sp),
          );
        });
  }

  @override
  List<Widget>? action() {
    return super.action();
  }
}

class MessageChatController extends BaseController {
  MessageChatController(this.uid);

  List<EMMessage> listMessage = [];
  String uid;
  String minUid = getMineUID().toString();
  EMConversation? emConversation;
  UserDataRes? mUserData;

  UserDataRes? mineInfo = GStorage.getMineUserBasic();

  bool noMoreDate = true;
  bool isLoading = false;

  @override
  void onInit() {
    super.onInit();
    createOrGetConversation();
    mUserData = GStorage.getUserBasic(uid);
    _getUserInfo();
  }

  void sendTextMessage(String msg) async {
    final mesage = await EmcHelper.sendTxtMessage(uid, msg);
    listMessage.insert(0, mesage);
    update(['content']);
    // sendMsg(msg, uid);
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
  }
}
