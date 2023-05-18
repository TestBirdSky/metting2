import 'package:flutter/cupertino.dart';
import 'package:metting/base/BaseController.dart';
import 'package:metting/base/BaseUiPage.dart';
import 'package:metting/widget/null_widget.dart';

class MessageChatPage extends BaseUiPage<MessageChatController> {
  MessageChatPage({required super.title});

  @override
  Widget createBody(BuildContext context) {
    return NullWidget();
  }

  @override
  MessageChatController initController() => MessageChatController();
}

class MessageChatController extends BaseController {}
