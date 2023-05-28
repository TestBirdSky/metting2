import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:im_flutter_sdk/im_flutter_sdk.dart';
import 'package:metting/base/BaseController.dart';
import 'package:metting/base/BaseUiPage.dart';
import 'package:metting/database/get_storage_manager.dart';
import 'package:metting/tool/emc_helper.dart';

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
    list.add(Text('data'));
    return list;
  }

  Widget _itemLeft() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [],
    );
  }

  Widget _itemRight() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [],
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
                  controller.sendTextMessage("msg${DateTime.now().second}");
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
    Text(
      title,
      style: TextStyle(color: C.whiteFFFFFF, fontSize: 18.sp),
    );
    return super.titleWidget();
  }
}

class MessageChatController extends BaseController {
  MessageChatController(this.uid);

  late String uid;

  String userId = "164034";
  String userId2 = "164035";
  EMConversation? emConversation;

  @override
  void onInit() {
    super.onInit();
    createOrGetConversation();
    _getUserInfo();
  }

  void sendTextMessage(String msg) async {
    await sendMsg(msg, uid);
    EmcHelper.sendTxtMessage(uid, msg);
  }

  void _getUserInfo() async {}

  void createOrGetConversation() async {
    emConversation =
        await EmcHelper.getConversationMessage(int.parse(uid), getMineUID());

  }
}
