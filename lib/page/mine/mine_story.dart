import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:metting/base/BaseController.dart';
import 'package:metting/base/BaseStatelessPage.dart';
import 'package:metting/widget/loading.dart';
import 'package:metting/widget/my_toast.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../base/base_refresh_page.dart';
import '../../network/bean/tread_list.dart';
import '../../network/http_helper.dart';

class MineStory extends BaseStatelessPage<MineStoryC> {
  RefreshController mRefreshController =
      RefreshController(initialRefresh: false);

  @override
  Widget createBody(BuildContext context) {
    return Stack(
      children: [
        Container(
          margin: EdgeInsets.symmetric(horizontal: 16.w),
          child: GetBuilder<MineStoryC>(
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
                    child: ListView(
                      shrinkWrap: true,
                      children: _list(),
                    ),
                  ),
                );
              }),
        ),
      ],
    );
  }

  List<Widget> _list() {
    final list = <Widget>[];
    list.add(titleWidget());
    for (TreadBean treadBean in controller.treadList) {
      if (treadBean.type == 2) {
        list.add(_itemVoice());
      } else {
        list.add(_itemText(treadBean));
      }
    }
    return list;
  }

  Widget titleWidget() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10.h),
      child: Text(
        "我的动态",
        textAlign: TextAlign.start,
        style: TextStyle(color: Colors.white, fontSize: 20.sp),
      ),
    );
  }

  @override
  Color pageBackgroundColor() {
    return Colors.transparent;
  }

  @override
  MineStoryC initController() => MineStoryC();

  void onRefresh() {
    controller._refresh(mRefreshController);
  }

  void onLoad() {
    controller._load(mRefreshController);
  }

  final itemHeight = 78.h;

  Widget _itemVoice() {
    return Container(
      height: itemHeight,
      padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 12.h),
      decoration: BoxDecoration(
          color: Color(0xff13181E),
          borderRadius: BorderRadius.all(Radius.circular(5.w))),
    );
  }

  Widget _itemText(TreadBean treadBean) {
    return _slidableWithDelete(
        Container(
          height: itemHeight,
          padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 12.h),
          decoration: BoxDecoration(
              color: Color(0xff13181E),
              borderRadius: BorderRadius.all(Radius.circular(5.w))),
          child: Text(
            treadBean.content ?? "",
            style: TextStyle(color: Color(0xffBBBABA), fontSize: 12.sp),
          ),
        ), (context) {
      controller.delTread(treadBean);
    });
  }

  Widget _slidableWithDelete(Widget child, SlidableActionCallback? onPressed) {
    return Slidable(
        endActionPane: ActionPane(
          motion: const ScrollMotion(),
          children: [
            SlidableAction(
              onPressed: onPressed,
              backgroundColor: Color(0xFFFE4A49),
              foregroundColor: Colors.white,
              label: '删除',
            ),
          ],
        ),
        child: child);
  }
}

class MineStoryC extends BaseController {
  List<TreadBean> treadList = [];
  int page = 1;

  void delTread(TreadBean treadBean) async {
    LoadingUtils.showLoading(msg: '删除中...');
    final data = await delTrends((treadBean.id ?? -1));
    if (data.isOk()) {
      treadList.remove(treadBean);
      update(['list']);
    } else {
      MyToast.show(data.msg);
    }
    LoadingUtils.dismiss();
  }

  void _refresh(RefreshController refreshController) async {
    page = 1;
    final base = await getTreadList(page);
    if (base.isOk()) {
      final list = base.data?.data;
      treadList.clear();
      if (list != null) {
        treadList.addAll(list);
      }
      refreshController.refreshCompleted();
      update(['list']);
      page++;
    } else {
      refreshController.refreshFailed();
    }
  }

  void _load(RefreshController refreshController) async {
    final base = await getTreadList(page);
    if (base.isOk()) {
      final list = base.data?.data;
      if (list != null) {
        treadList.addAll(list);
        refreshController.refreshCompleted();
        update(['list']);
      } else {
        page++;
        refreshController.loadNoData();
      }
    } else {
      refreshController.refreshFailed();
    }
  }
}
