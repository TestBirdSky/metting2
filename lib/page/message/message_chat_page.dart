import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:im_flutter_sdk/im_flutter_sdk.dart';
import 'package:metting/base/BaseController.dart';
import 'package:metting/base/BaseUiPage.dart';
import 'package:metting/database/get_storage_manager.dart';
import 'package:metting/network/bean/user_data_res.dart';
import 'package:metting/page/message/message_chat_controller.dart';
import 'package:metting/tool/emc_helper.dart';
import 'package:metting/tool/log.dart';
import 'package:metting/widget/image_m.dart';

import '../../core/common_configure.dart';
import '../../dialog/dialog_create_voice_video_chat.dart';
import '../../network/http_helper.dart';
import '../../tool/view_tools.dart';
import '../../widget/bottom_popup.dart';
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
        _recordWidget(),
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
        EMTextMessageBody body = msg.body as EMTextMessageBody;
        final text = Text(
          body.content,
          style: TextStyle(fontSize: 15.sp, color: Colors.white),
        );
        if (msg.from == uid) {
          widget = _itemTextLeft(text);
        } else {
          msg.status;
          widget = _itemRight(text, msg);
        }
        break;
      case MessageType.VOICE:
        EMVoiceMessageBody body = msg.body as EMVoiceMessageBody;
        if (msg.from == uid) {
          widget = _itemTextLeft(GestureDetector(
            onTap: () {
              controller.playAudio(msg.msgId, body);
            },
            child: Container(
              width: 76.w,
              color: Colors.transparent,
              child: Row(
                children: [
                  Image.asset(
                    getImagePath('audio_left'),
                    color: controller.curPlayMsgId == msg.msgId
                        ? Colors.grey
                        : Colors.white,
                    width: 18.w,
                    height: 18.h,
                  ),
                  SizedBox(
                    width: 10.w,
                  ),
                  Text(
                    "${body.duration}''",
                    style: TextStyle(fontSize: 15.sp, color: Colors.white),
                  ),
                ],
              ),
            ),
          ));
        } else {
          msg.status;
          widget = _itemRight(
              GestureDetector(
                onTap: () {
                  controller.playAudio(msg.msgId, body);
                },
                child: Container(
                  width: 76.w,
                  color: Colors.transparent,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        "${body.duration}''",
                        style: TextStyle(fontSize: 15.sp, color: Colors.white),
                      ),
                      SizedBox(
                        width: 10.w,
                      ),
                      Image.asset(
                        getImagePath('audio_right'),
                        color: controller.curPlayMsgId == msg.msgId
                            ? Colors.grey
                            : Colors.white,
                        width: 18.w,
                      ),
                    ],
                  ),
                ),
              ),
              msg);
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
                widget = _itemRight(_videoItem(), msg);
              }
              break;
            case CustomEvent.AUDIO:
              if (msg.from == uid) {
                widget = _itemTextLeft(_audioItem());
              } else {
                widget = _itemRight(_audioItem(), msg);
              }
              break;
          }
        }
        break;
    }
    return GestureDetector(
        child: widget,
        onLongPress: () {
          showDeleteMsgDialog(() {
            controller.delMessage(msg);
          });
        },
        onTap: () {
          logger.i('hideKeyboard');
          hideKeyboard(mContext);
        });
  }

  void hideKeyboard(BuildContext context) {
    FocusScopeNode currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null) {
      FocusManager.instance.primaryFocus!.unfocus();
    }
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
      color: Colors.transparent,
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

  Widget _itemRight(Widget content, EMMessage msg) {
    return Container(
      color: Colors.transparent,
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
                  _msgStatus(msg),
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

  Widget _msgStatus(EMMessage msg) {
    if (msg.status == MessageStatus.FAIL) {
      return GestureDetector(
        onTap: () {
          controller.resendMessage(msg);
        },
        child: Padding(
          padding: EdgeInsets.only(right: 6.w),
          child: Icon(
            Icons.error_outline,
            color: Colors.red,
            size: 24.w,
          ),
        ),
      );
    } else if (msg.status == MessageStatus.PROGRESS) {
      return Container(
          margin: EdgeInsets.only(right: 6.w),
          width: 18.w,
          height: 18.w,
          child: CircularProgressIndicator(
            color: Colors.grey,
            strokeWidth: 1.w,
          ));
    } else {
      return Text('');
    }
  }

  var isSendVoice = false;
  double start = 0.0;
  double offset = 0.0;
  bool isUpCancel = false;

  Widget _bottomWidget() {
    return Container(
      height: 76.h,
      padding: EdgeInsets.symmetric(horizontal: 12.w),
      color: Colors.black,
      child: StatefulBuilder(builder: (context, state) {
        return Row(
          children: [
            GestureDetector(
              onTap: () {
                isSendVoice = !isSendVoice;
                if (isSendVoice) {
                  hideKeyboard(mContext);
                }
                state(() {});
              },
              child: isSendVoice
                  ? Container(
                      margin: EdgeInsets.only(right: 8.0.w),
                      child: Icon(
                        Icons.keyboard_rounded,
                        color: Colors.white,
                        size: 34.w,
                      ),
                    )
                  : Container(
                      margin: EdgeInsets.only(right: 8.0.w),
                      child: Icon(
                        Icons.keyboard_voice_rounded,
                        color: Colors.white,
                        size: 34.w,
                      ),
                    ),
            ),
            Expanded(
                child: Container(
              height: 46.h,
              padding: EdgeInsets.symmetric(horizontal: 10.w),
              decoration: BoxDecoration(
                  color: C.PAGE_THEME_BG,
                  borderRadius: BorderRadius.all(Radius.circular(8.w))),
              child: isSendVoice
                  ? GestureDetector(
                      onVerticalDragStart: (details) {
                        logger.i("onVerticalDragStart");
                        isUpCancel = false;
                        start = details.globalPosition.dy;
                        controller.startRecoding();
                      },
                      onVerticalDragEnd: (details) {
                        logger.i("onVerticalDragEnd $isUpCancel");
                        if (isUpCancel) {
                          controller.cancelRecoding();
                        } else {
                          controller.stopRecodingAndStartSend();
                        }
                      },
                      onVerticalDragUpdate: (details) {
                        logger.i("onVerticalDragUpdate $start  $offset");
                        offset = details.globalPosition.dy;
                        isUpCancel = start - offset > 100.h ? true : false;
                        controller.updateCancleStatus(isUpCancel);
                      },
                      child: Container(
                        width: double.infinity,
                        height: double.infinity,
                        alignment: Alignment.center,
                        child: Text(
                          '按住 说话',
                          textAlign: TextAlign.center,
                          style:
                              TextStyle(color: Colors.white, fontSize: 22.sp),
                        ),
                      ),
                    )
                  : TextField(
                      textAlignVertical: TextAlignVertical.top,
                      autofocus: true,
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
                              borderSide: BorderSide(
                                  color: Color(0x00FEC693), width: 0)),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Color(0x00FEC693), width: 0))),
                      onChanged: (value) {},
                      controller: _controller,
                    ),
            )),
            SizedBox(
              width: isSendVoice ? 24.w : 10.w,
            ),
            isSendVoice
                ? Text('')
                : Container(
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
                          style:
                              TextStyle(color: Colors.white, fontSize: 16.sp),
                        )),
                  )
          ],
        );
      }),
    );
  }

  @override
  MessageChatController initController() => MessageChatController(uid);

  Widget _recordWidget() {
    return GetBuilder<MessageChatController>(
        id: 'recordVoice',
        builder: (c) {
          return c.isRecordingVoice
              ? Stack(
                  children: [
                    Container(
                      margin: EdgeInsets.only(bottom: 76.h),
                      width: double.infinity,
                      height: double.infinity,
                      color: Colors.black45,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: 16.w, vertical: 160.h),
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              c.isSelectedCancel ? "松开 取消" : '',
                              style: TextStyle(
                                  color: Colors.white, fontSize: 16.sp),
                            ),
                            SizedBox(
                              height: 10.h,
                            ),
                            ClipOval(
                              child: c.isSelectedCancel
                                  ? Container(
                                      width: 100.w,
                                      height: 100.w,
                                      color: Colors.white,
                                      child: Icon(
                                        Icons.clear,
                                        color: Colors.black,
                                        size: 40.w,
                                      ),
                                    )
                                  : Container(
                                      width: 80.w,
                                      height: 80.w,
                                      color: Colors.grey,
                                      child: Icon(Icons.clear,
                                          color: Colors.white, size: 36.w),
                                    ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Align(
                        alignment: Alignment.bottomCenter,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              c.isSelectedCancel ? '' : "松开 发送",
                              style: TextStyle(
                                  color: Colors.white, fontSize: 16.sp),
                            ),
                            SizedBox(
                              height: 10.h,
                            ),
                            Container(
                              width: double.infinity,
                              height: 106.h,
                              padding: EdgeInsets.only(top: 10.h),
                              alignment: Alignment.topCenter,
                              child: Text(
                                "录音中...",
                                style: TextStyle(
                                    color: Colors.black, fontSize: 22.sp),
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(56.w),
                                    topLeft: Radius.circular(56.w)),
                              ),
                            ),
                          ],
                        ))
                  ],
                )
              : Text('');
        });
  }

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
