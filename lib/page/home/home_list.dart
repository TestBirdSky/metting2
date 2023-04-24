import 'package:flutter/cupertino.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:metting/page/home/home.dart';
import 'package:metting/tool/log.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../../base/base_refresh_page.dart';
import '../../core/common_configure.dart';
import '../../network/bean/front_response.dart';
import '../../widget/image_m.dart';

class HomeList extends GetView<HomeC> {
  RefreshController refreshController =
      RefreshController(initialRefresh: false);

  void _onLoading() {
    logger.i("onLoading");
    controller.load(refreshController);
  }

  //
  void _onRefresh() {
    controller.refreshList(refreshController);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        color: C.PAGE_THEME_BG,
        padding: EdgeInsets.only(left: 12.w, right: 12.w, top: 50.h),
        child: RefreshConfiguration(
            // Viewport不满一屏时,禁用上拉加载更多功能,应该配置更灵活一些，比如说一页条数大于等于总条数的时候设置或者总条数等于0
            hideFooterWhenNotFull: true,
            child: SmartRefresher(
                enablePullDown: true,
                enablePullUp: true,
                header: MyClassicHeader(),
                footer: MyClassicFooter(),
                // 配置默认底部指示器
                controller: refreshController,
                onRefresh: _onRefresh,
                onLoading: _onLoading,
                child: ListView(children: _list()))));
  }

  List<Widget> _list() {
    List<Widget> list = [];
    for (FrontResponse e in controller.list) {
      final info = _itemInfo(e);
      final content = e.type == 2 ? _itemVoice() : _itemText(e.content ?? "");
      if (controller.isBoy(e)) {
        list.add(_pageViewRight(content, info));
      } else {
        list.add(_pageViewLeft(info, content));
      }
    }

    list.add(SizedBox(
      height: 60.h,
    ));
    return list;
  }

  final itemHeight = 78.h;

  Widget _pageViewRight(Widget left, Widget right) {
    return Container(
      height: itemHeight,
      margin: EdgeInsets.symmetric(vertical: 6.h),
      child: PageView(
        controller: PageController(initialPage: 0, viewportFraction: 0.95),
        children: [left, right],
      ),
    );
  }

  Widget _pageViewLeft(Widget left, Widget right) {
    return Container(
      height: itemHeight,
      margin: EdgeInsets.symmetric(vertical: 6.h),
      child: PageView(
        controller: PageController(initialPage: 1, viewportFraction: 0.95),
        children: [left, right],
      ),
    );
  }

  Widget _itemVoice() {
    return Container(
      height: itemHeight,
      padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 12.h),
      decoration: BoxDecoration(
          color: Color(0xff13181E),
          borderRadius: BorderRadius.all(Radius.circular(5.w))),
    );
  }

  Widget _itemText(String text) {
    return Container(
      height: itemHeight,
      padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 12.h),
      decoration: BoxDecoration(
          color: Color(0xff13181E),
          borderRadius: BorderRadius.all(Radius.circular(5.w))),
      child: Text(
        text,
        style: TextStyle(color: Color(0xffBBBABA), fontSize: 12.sp),
      ),
    );
  }

  Widget _itemInfo(FrontResponse bean) {
    return Container(
      height: itemHeight,
      decoration: BoxDecoration(
          color: Color(0xffFDFCDD),
          borderRadius: BorderRadius.all(Radius.circular(5.w))),
      child: Row(children: [
        cardNetworkImage(bean.avatar ?? "", 96.w, 96.w),
        Column(
          children: [
            Row(
              children: [
                Text(
                  '${bean.cname}',
                  style: TextStyle(color: Color(0xff333333), fontSize: 12.sp),
                )
              ],
            )
          ],
        )
      ]),
    );
  }
}
