import 'package:flutter/material.dart';

import '../../base/BaseController.dart';
import '../../base/BaseUiPage.dart';

class MessagePage extends BaseUiPage<MessagePageC> {
  MessagePage() : super(title: "消息");

  @override
  Widget? backWidget() {
    return null;
  }

  @override
  Widget createBody(BuildContext context) {
    return Center(
      child: Text("Home$title"),
    );
  }

  @override
  MessagePageC initController() => MessagePageC();

}

class MessagePageC extends BaseController {}
