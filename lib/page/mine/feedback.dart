import 'package:flutter/cupertino.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:metting/base/BaseController.dart';

import '../../base/BaseUiPage.dart';

class FeedbackPage extends BaseUiPage<FeedbackC> {
  FeedbackPage() : super(title: "意见反馈");

  @override
  Widget createBody(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [

        ],
      ),
    );
  }

  @override
  FeedbackC initController() => FeedbackC();
}

class FeedbackC extends BaseController {}
