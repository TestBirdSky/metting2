import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:metting/base/BaseUiPage.dart';
import 'package:metting/network/bean/front_response.dart';
import 'package:metting/network/http_helper.dart';
import 'package:metting/page/home/notebook.dart';
import 'package:metting/page/home/soul.dart';
import 'package:metting/page/home/square.dart';
import 'package:metting/tool/log.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../base/BaseController.dart';
import '../../core/common_configure.dart';
import '../../tool/view_tools.dart';
import 'home_list.dart';

class HomePage extends BaseUiPage<HomeC> {
  HomePage() : super(title: "首页");

  @override
  Widget createBody(BuildContext context) {
    logger.i("Home$title");
    return Stack(
      children: [
        Container(
          color: C.PAGE_THEME_BG,
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 6.w),
          child: _topItem(),
        ),
        Padding(
          padding: EdgeInsets.only(
            top: 72.h,
          ),
          child: HomeList(),
        ),
        Align(
          alignment: Alignment.bottomRight,
          child: Padding(
            padding: EdgeInsets.only(bottom: 200.h, right: 9.w),
            child: InkWell(
              onTap: () {
                addTextTrends("content");
              },
              child: Image.asset(
                getImagePath('mine_edit'),
                width: 66.w,
                height: 66.w,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _topItem() {
    return Column(
      children: [
        SizedBox(
          height: 6.h,
        ),
        Container(
          height: 70.h,
          child: Row(
            children: [
              Expanded(
                  child: GestureDetector(
                onTap: () {
                  Get.to(()=>SquarePage());
                },
                child: _btn("灵魂广场", "白天归顺于生活，晚上屈服于灵魂", "home_1btn"),
              )),
              SizedBox(
                width: 6.w,
              ),
              Expanded(
                  child: GestureDetector(
                onTap: () {
                  Get.to(NoteBookPage());
                },
                child: _btn("记忆留存", "留下片刻的记忆却会用一生的时间来回想", "home_4btn"),
              )),
              // Expanded(
              //     child: GestureDetector(
              //   onTap: () {},
              //   child: _btn("附近故事", "把你的故事告诉我后我们就是朋友啦", "home_2btn"),
              // )),
            ],
          ),
        ),
        // SizedBox(height: 4.h),
        // Container(
        //   height: 70.h,
        //   child: Row(
        //     children: [
        //       Expanded(
        //           child: GestureDetector(
        //         onTap: () {},
        //         child: _btn("许愿墙", "不能变为现实的心愿,却也不乏为一个美丽的梦想", "home_3btn"),
        //       )),
        //       // SizedBox(
        //       //   width: 6.w,
        //       // ),
        //       Expanded(
        //           child: GestureDetector(
        //         onTap: () {
        //           Get.to(NoteBookPage());
        //         },
        //         child: _btn("记忆留存", "留下片刻的记忆却会用一生的时间来回想", "home_4btn"),
        //       )),
        //     ],
        //   ),
        // ),
      ],
    );
  }

  Widget _btn(String text1, String text2, String imagePath) {
    return Stack(
      children: [
        Image.asset(
          getImagePath(imagePath),
          fit: BoxFit.cover,
        ),
        Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  text1,
                  style: TextStyle(fontSize: 13.sp, color: Colors.white),
                ),
                SizedBox(
                  height: 4.h,
                ),
                Text(
                  text2,
                  style: TextStyle(fontSize: 10.sp, color: Colors.white),
                ),
                SizedBox(
                  height: 4.h,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  @override
  HomeC initController() => HomeC();

  @override
  Widget? backWidget() {
    return null;
  }
}

class HomeC extends BaseController {
  final List<FrontResponse> list = [];

  bool isBoy(FrontResponse bean) {
    return bean.sex == 1;
  }

  int page = 1;

  Future<void> refreshList(RefreshController c) async {
    page = 1;
    final base = await getFrontPage(page);
    if (base.isOk()) {
      final resList = base.data?.data;
      if (resList != null) {
        list.addAll(resList);
        page++;
        c.refreshCompleted();
        update(['list']);
      } else {
        c.resetNoData();
      }
    } else {
      c.refreshFailed();
    }
  }

  void load(RefreshController c) async {
    final base = await getFrontPage(page);
    if (base.isOk()) {
      final list = base.data?.data;
      if (list != null) {
        list.addAll(list);
        page++;
        c.refreshCompleted();
        update(['list']);
      } else {
        c.loadNoData();
      }
    } else {
      c.refreshFailed();
    }
  }
}
