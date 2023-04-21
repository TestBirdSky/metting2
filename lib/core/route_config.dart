import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../main.dart';
import '../page/splash.dart';

/**
 * 各个导航界面初始化
 */
var isAutoLoginSuccess = false;

var getRouterPage = [
  GetPage(name: splashPName, page: () => SplashPage()),
  // GetPage(name: homePName, page: () => const HomePage()),
  // GetPage(name: loginPName, page: () => LoginPage()),
  // GetPage(name: webViewPName, page: () => WebViewPage()),
  // GetPage(name: MinePName, page: () => MinePage()),
  // GetPage(name: photoViewPName, page: () => PhotoViewPage()),
  // GetPage(name: photoViewScalePName, page: () => PhotoViewScalePage()),
  // GetPage(name: addBasicInfoPName, page: () => AddBasicInfoPage()),
];

//导航个页面name 调用Get.toName('/login') 即可进行页面跳转
const splashPName = '/';
var homePName = '/home';
var loginPName ='/login';
const webViewPName = '/webView';
const MinePName = '/mine';
const photoViewPName = '/photoViewP';
const photoViewScalePName = '/photoViewScaleP';
const addBasicInfoPName = '/addBasicInfo';
GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

BuildContext? getApplication() {
  return navigatorKey.currentState?.overlay?.context;
}
