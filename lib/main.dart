import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'core/Messages.dart';
import 'core/common_configure.dart';
import 'core/route_config.dart';

void main() async {
  SystemChrome.setPreferredOrientations(
    [
      DeviceOrientation.portraitUp, // 竖屏 Portrait 模式
      DeviceOrientation.portraitDown,
    ],
  );
  await GetStorage.init('firstInitStorage');
  runApp(ScreenUtilInit(
      designSize: const Size(428, 926),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return GetMaterialApp(
          localizationsDelegates: const [
            // 下拉刷新控件
            RefreshLocalizations.delegate,
          ],
          builder: EasyLoading.init(builder: FToastBuilder()),
          navigatorKey: navigatorKey,
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            appBarTheme: const AppBarTheme(brightness: Brightness.dark),
            // light为黑色 dark为白色
            primaryColor: C.mainColor,
            visualDensity: VisualDensity.adaptivePlatformDensity,
          ),
          translations: Messages(),
          // 你的翻译
          locale: const Locale('zh', 'CN'),
          // 将会按照此处指定的语言翻译
          fallbackLocale: const Locale('zh', 'CN'),

          /// 初始化路由
          getPages: getRouterPage,
        );
      }));
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
}
