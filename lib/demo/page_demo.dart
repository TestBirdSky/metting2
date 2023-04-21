import 'package:flutter/widgets.dart';

import '../base/BaseController.dart';
import '../base/BaseStatelessPage.dart';

class PageDemo extends BaseStatelessPage<PageDemoC>{
  @override
  Widget createBody(BuildContext context) {
    // TODO: implement customBuild
    throw UnimplementedError();
  }

  @override
  PageDemoC initController() => PageDemoC();
}

class PageDemoC extends BaseController{

}