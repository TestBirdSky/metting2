import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:im_flutter_sdk/im_flutter_sdk.dart';
import 'package:metting/base/BaseController.dart';
import 'package:metting/base/BaseUiPage.dart';
import 'package:metting/database/get_storage_manager.dart';
import 'package:metting/network/bean/user_data_res.dart';
import 'package:metting/tool/emc_helper.dart';
import 'package:metting/widget/image_m.dart';

import '../../core/common_configure.dart';
import '../../network/http_helper.dart';

class MessageChatPage extends BaseUiPage<MessageChatController> {
  MessageChatPage({required super.title, required this.uid});

  final TextEditingController _controller = TextEditingController();

  late String uid;
  final ScrollController _scrollController = ScrollController();

  @override
  Widget createBody(BuildContext context) {
    return Stack(
      children: [
        Column(
          children: [Expanded(child: contentW()), _bottomWidget()],
        )
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
    Widget widget;
    switch (msg.body.type) {
      case MessageType.TXT:
        {
          EMTextMessageBody body = msg.body as EMTextMessageBody;
          if (msg.from == uid) {
            widget = _itemRight(body.content);
          } else {
            widget = _itemRight(body.content);
          }
        }
        break;
      default:
        {
          widget = Text('');
        }
    }
    return widget;
  }

  Widget _itemTextLeft(String content) {
    return Container(
      padding: EdgeInsets.only(right: 12.w, bottom: 10.h),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Row(
                // textDirection: TextDirection.ltr,
                children: [
                  ConstrainedBox(
                    constraints: BoxConstraints(
                        maxWidth: contentWidth, minHeight: 40.h),
                    child: Container(
                      margin: EdgeInsets.only(top: 6.h),
                      padding: EdgeInsets.symmetric(
                          horizontal: 8.w, vertical: 8.h),
                      decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius:
                          BorderRadius.all(Radius.circular(5.w))),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            content,
                            style: TextStyle(
                                fontSize: 15.sp, color: Colors.white),
                          ),
                        ],
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
                "${controller.mUserData?.avatar}", 46.h, 46.h),
          )
        ],
      ),
    );
  }

  final contentWidth = (ScreenUtil().screenWidth - 60.w);

  Widget _itemRight(String content) {
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
                    constraints: BoxConstraints(
                        maxWidth: contentWidth, minHeight: 40.h),
                    child: Container(
                      margin: EdgeInsets.only(top: 6.h),
                      padding: EdgeInsets.symmetric(
                          horizontal: 8.w, vertical: 8.h),
                      decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius:
                              BorderRadius.all(Radius.circular(5.w))),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            content,
                            style: TextStyle(
                                fontSize: 15.sp, color: Colors.white),
                          ),
                        ],
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
                "${controller.mUserData?.avatar}", 46.h, 46.h),
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
}

class MessageChatController extends BaseController {
  MessageChatController(this.uid);

  List<EMMessage> listMessage = [];
  late String uid;
  String minUid = getMineUID().toString();

  String userId = "164034";
  String userId2 = "164035";
  EMConversation? emConversation;
  UserDataRes? mUserData;

  @override
  void onInit() {
    super.onInit();
    createOrGetConversation();
    _getUserInfo();
  }

  void sendTextMessage(String msg) async {
    final mesage = await EmcHelper.sendTxtMessage(uid, msg);
    listMessage.insert(0, mesage);
    update(['content']);
    sendMsg(msg, uid);
  }

  void _getUserInfo() async {
    mUserData = (await getUserData(int.parse(uid))).data;
    update(['title']);
  }

  void createOrGetConversation() async {
    emConversation =
        await EmcHelper.getConversationMessage(int.parse(uid), getMineUID());
    getMessage();
  }

  void getMessage() async {
    final list = await emConversation?.loadMessages(startMsgId: '') ?? [];
    if (list.isNotEmpty) {
      listMessage.addAll(list);
      update(['content']);
    }
  }

  void loadMessage() async {}
}
