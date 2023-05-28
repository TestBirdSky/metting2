import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:im_flutter_sdk/im_flutter_sdk.dart';
import 'package:metting/network/http_helper.dart';
import 'package:metting/page/home/home.dart';
import 'package:metting/page/login/login.dart';
import 'package:metting/tool/log.dart';
import '../base/BaseController.dart';
import '../base/BaseStatelessPage.dart';
import '../core/common_configure.dart';
import '../tool/view_tools.dart';
import 'mian/main.dart';

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
    await _initEMSDK();
    getChatLang();
  }

  Future<void> _initEMSDK() async {
    logger.i('SplashController _initEMSDK');
    EMOptions options = EMOptions(
      appKey: "1100230401164364#demo",
      autoLogin: true,
    );
    await EMClient.getInstance.init(options);
    // 通知sdk ui已经准备好，执行后才会收到`EMChatRoomEventHandler`, `EMContactEventHandler`, `EMGroupEventHandler` 回调。
    await EMClient.getInstance.startCallback();
    _eMAutoLogin();
  }

  void _eMAutoLogin() async {
    logger.i('message _eMAutoLogin');
    final data = await autoLogin();
    if (data.isOk()) {
      Get.off(()=> MainPage());
    } else {
      Get.off(() => LoginPage());
    }
  }
}
