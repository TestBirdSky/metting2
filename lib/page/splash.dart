import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:metting/network/http_helper.dart';
import 'package:metting/page/login/login.dart';
import '../base/BaseController.dart';
import '../base/BaseStatelessPage.dart';
import '../core/common_configure.dart';
import '../tool/view_tools.dart';

class SplashPage extends BaseStatelessPage<SplashController> {
  @override
  Widget createBody(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            width: double.infinity,
            height: double.infinity,
            color: C.pageBgColor,
          ),
          ConstrainedBox(
            constraints: const BoxConstraints.expand(),
            child: Image.asset(
              getImagePath("ic_splash"),
              fit: Platform.isIOS ? BoxFit.cover : BoxFit.none,
            ),
          ),
        ],
      ),
    );
  }

  @override
  SplashController initController() => SplashController();

}

class SplashController extends BaseController {

  @override
  void onInit() {
    super.onInit();
    _autoLogin();
  }

  void _autoLogin() async {
    await GetStorage.init();
    getChatLang();
    await Future.delayed(const Duration(milliseconds: 3000));
    Get.off(()=>LoginPage());
  }
}