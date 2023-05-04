import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:metting/base/BaseController.dart';
import 'package:metting/base/BaseUiPage.dart';
import 'package:metting/base/base_refresh_page.dart';
import 'package:metting/core/common_configure.dart';
import 'package:metting/network/http_helper.dart';
import 'package:metting/page/home/note_details.dart';
import 'package:pull_to_refresh/src/smart_refresher.dart';

import '../../database/get_storage_manager.dart';
import '../../network/bean/all_user_notes.dart';
import '../../widget/image_m.dart';

class NoteBookPage extends BaseUiPage<NoteBookC> {
  NoteBookPage() : super(title: "日记");

  @override
  initController() => NoteBookC();

  RefreshController mRefreshController =
      RefreshController(initialRefresh: true);

  void onRefresh() {
    controller.onRefresh(mRefreshController);
  }

  void onLoad() {
    controller.load(mRefreshController);
  }

  Widget _refreshLayout() {
    return MasonryGridView.count(
      crossAxisCount: 2,
      mainAxisSpacing: 0.h,
      itemCount: controller.list.length,
      crossAxisSpacing: 0.w,
      itemBuilder: (context, index) {
        return _itemView(index);
      },
    );
  }

  Widget _itemView(int index) {
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
    final bean = controller.list[index];
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
                      return circleNetworkWidget(bean.avatar ?? "", 36.w, 36.w);
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
          child: _note(bean),
        )
      ],
    );
  }

  Widget _itemRight(int index) {
    final bean = controller.list[index];
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
                child: circleNetworkWidget(bean.avatar ?? "", 36.w, 36.w),
              ),
            ),
          ]),
        ),
        Padding(
          padding: EdgeInsets.only(left: 16.w, right: 36.w),
          child: _note(bean),
        )
      ],
    );
  }

  Widget _note(UserNotesBean bean) {
    return GestureDetector(
      onTap: () {
        Get.to(
            NoteDetailsPage(
              isMe: bean.uid == getMineUID(),
            ),
            arguments: {'uid': bean.uid});
      },
      child: Container(
        height: 114.h,
        margin: EdgeInsets.only(top: 38.w),
        child:
            Align(alignment: Alignment.centerLeft, child: _noteText(bean)),
      ),
    );
  }

  Widget _noteText(UserNotesBean bean){
    final list=<Widget>[];
    bean.list?.forEach((element) { 
      list.add(Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
        Text('${element.time}',style: TextStyle(color: Colors.white,fontSize: 12.sp),),
        Text('${element.content}',style: TextStyle(color: Colors.white,fontSize: 9.sp),),
      ],));
    });
    return ListView(children: list,);
  }
  
  @override
  Widget createBody(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12.w,vertical: 10.h),
      child: GetBuilder<NoteBookC>(
          id: 'list',
          builder: (c) {
            return RefreshConfiguration(
              // Viewport不满一屏时,禁用上拉加载更多功能,应该配置更灵活一些，比如说一页条数大于等于总条数的时候设置或者总条数等于0
              hideFooterWhenNotFull: true,
              child: SmartRefresher(
                enablePullDown: true,
                enablePullUp: true,
                header: const MyClassicHeader(),
                footer: const MyClassicFooter(),
                // 配置默认底部指示器
                controller: mRefreshController,
                onRefresh: onRefresh,
                onLoading: onLoad,
                child: _refreshLayout(),
              ),
            );
          }),
    );
  }
}

class NoteBookC extends BaseController {
  List<UserNotesBean> list = [];

  int page = 1;

  void onRefresh(RefreshController refreshController) async {
    page = 1;
    final base = await getMemoryList(page);
    if (base.isOk()) {
      final liData = base.data?.data;
      list.clear();
      if (liData != null) {
        list.addAll(liData);
      }
      refreshController.refreshCompleted();
      update(['list']);
      page++;
    } else {
      refreshController.refreshFailed();
    }
  }

  void load(RefreshController refreshController) async {
    final base = await getMemoryList(page);
    if (base.isOk()) {
      final liData = base.data?.data;
      if (liData != null) {
        page++;
        list.addAll(liData);
        refreshController.refreshCompleted();
        update(['list']);
      } else {
        refreshController.loadNoData();
      }
    } else {
      refreshController.refreshFailed();
    }
  }
}
