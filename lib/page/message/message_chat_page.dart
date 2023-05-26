import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:metting/base/BaseController.dart';
import 'package:metting/base/BaseUiPage.dart';

class MessageChatPage extends BaseUiPage<MessageChatController> {
  MessageChatPage({required super.title});

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
      children: [

      ],
    );
  }

  Widget _itemRight(){
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [

      ],
    );
  }

  Widget _bottomWidget() {
    return Container(
      height: 80.h,
      child: Row(
        children: [],
      ),
    );
  }

  @override
  MessageChatController initController() => MessageChatController();
}

class MessageChatController extends BaseController {

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }
}
