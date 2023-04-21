import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:metting/base/BaseController.dart';
import 'package:metting/base/base_refresh_page.dart';
import 'package:metting/core/common_configure.dart';
import 'package:metting/page/home/note_details.dart';
import 'package:pull_to_refresh/src/smart_refresher.dart';

import '../../widget/image_m.dart';

class NoteBookPage extends BaseRefreshPage<NoteBookC> {
  NoteBookPage() : super(title: "日记");

  @override
  initController() => NoteBookC();

  @override
  RefreshController refreshController() =>
      RefreshController(initialRefresh: false);

  @override
  Widget refreshLayout() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
      child: MasonryGridView.count(
        crossAxisCount: 2,
        mainAxisSpacing: 0.h,
        itemCount: 30,
        crossAxisSpacing: 0.w,
        itemBuilder: (context, index) {
          return _ItemView(index);
        },
      ),
    );
  }

  Widget _ItemView(int index) {
    if (index == 1) {
      return SizedBox(
        height: 225.h,
        child: Stack(
          children: [
            Padding(
              padding: EdgeInsets.only(top: 75.h),
              child: _itemRight(index),
            )
          ],
        ),
      );
    } else if (index % 2 == 0) {
      //left
      return SizedBox(
        height: 150.h,
        child: _itemLeft(index),
      );
    } else {
      return SizedBox(
        height: 150.h,
        child: _itemRight(index),
      );
    }
  }

  Widget _itemLeft(int index) {
    double margin = 0;
    if (index == 0) margin = 18.w;
    return Stack(
      children: [
        Align(
            alignment: Alignment.centerRight,
            child: Container(
              margin: EdgeInsets.only(top: margin),
              color: C.FEC693,
              width: 8.w,
              height: 150.h,
            )),
        Container(
          height: 36.h,
          child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            ClipOval(
              child: Container(
                color: C.FEC693,
                width: 36.w,
                height: 36.w,
                padding: EdgeInsets.all(1.w),
                child: GetBuilder<NoteBookC>(
                    id: 'head',
                    builder: (c) {
                      return circleNetworkWidget('c.headerImgUrl', 36.w, 36.w);
                    }),
              ),
            ),
            Expanded(
                child: Container(
              height: 4.h,
              color: C.FEC693,
            ))
          ]),
        ),
        Padding(
          padding: EdgeInsets.only(left: 36.w, right: 16.w),
          child: _note(index),
        )
      ],
    );
  }

  Widget _itemRight(int index) {
    return Stack(
      children: [
        Container(
          height: 36.h,
          child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Expanded(
                child: Container(
              height: 4.h,
              color: C.FEC693,
            )),
            ClipOval(
              child: Container(
                color: C.FEC693,
                width: 36.w,
                height: 36.w,
                padding: EdgeInsets.all(1.w),
                child: GetBuilder<NoteBookC>(
                    id: 'head',
                    builder: (c) {
                      return circleNetworkWidget('c.headerImgUrl', 36.w, 36.w);
                    }),
              ),
            ),
          ]),
        ),
        Padding(
          padding: EdgeInsets.only(left: 16.w, right: 36.w),
          child: _note(index),
        )
      ],
    );
  }

  Widget _note(int index) {
    return GestureDetector(
      onTap: () {
        Get.to(NoteDetailsPage(title: "title"));
      },
      child: Container(
        height: 114.h,
        margin: EdgeInsets.only(top: 38.w),
        child: Column(
          children: [
            Text("data14444444444433333333"),
            Text("data14444444444433333333"),
            Text("data14444444444433333333"),
            Text("data14444444444433333333"),
            Text("data3332"),
            Text("data3"),
          ],
        ),
      ),
    );
  }
}

class NoteBookC extends BaseController {}
