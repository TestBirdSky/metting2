import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:metting/page/home/home.dart';
import 'package:metting/tool/log.dart';
import 'package:metting/tool/view_tools.dart';
import 'package:metting/widget/bottom_popup.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../../base/base_refresh_page.dart';
import '../../core/common_configure.dart';
import '../../network/bean/front_response.dart';
import '../../widget/dialog_person_info.dart';
import '../../widget/image_m.dart';

class HomeList extends GetView<HomeC> {
  RefreshController refreshController = RefreshController(initialRefresh: true);

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
        padding: EdgeInsets.only(top: 0.h),
        child: GetBuilder<HomeC>(
            id: "list",
            builder: (c) {
              return RefreshConfiguration(
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
                      child: ListView(children: _list())));
            }));
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
    return Stack(
      children: [
        Container(
          height: itemHeight,
          decoration: BoxDecoration(
              color: Color(0xffFDFCDD),
              borderRadius: BorderRadius.all(Radius.circular(5.w))),
          child: Row(children: [
            GestureDetector(
              child: cardNetworkImage(bean.avatar ?? "", itemHeight, itemHeight,
                  margin: const EdgeInsets.all(0)),
              onTap: () {
                PersonInfoDialog().showInfoDialogWithUit(bean.uid);
              },
            ),
            Container(
              padding: EdgeInsets.symmetric(vertical: 4.h, horizontal: 8.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        '${bean.cname}',
                        style: TextStyle(
                            color: Color(0xff333333), fontSize: 12.sp),
                      ),
                      SizedBox(
                        width: 10.w,
                      ),
                      Text(
                        '${bean.age}岁',
                        style: TextStyle(
                            color: Color(0xff333333), fontSize: 10.sp),
                      ),
                      Image.asset(
                        getImagePath(
                            bean.sex == 1 ? 'ic_sex_man' : 'ic_sex_woman'),
                        width: 10.w,
                        height: 10.w,
                      )
                    ],
                  ),
                  SizedBox(
                    height: 8.h,
                  ),
                  Align(
                      alignment: Alignment.centerLeft,
                      child: _widgetDialect(bean.lang ?? [])),
                  const Expanded(child: SizedBox()),
                  Align(
                    alignment: Alignment.bottomLeft,
                    child: Row(
                      children: [
                        Image.asset(
                          getImagePath('ic_location'),
                          width: 12.w,
                          height: 19.w,
                        ),
                        SizedBox(
                          width: 7.w,
                        ),
                        Text('${bean.province}${bean.region}')
                      ],
                    ),
                  )
                ],
              ),
            )
          ]),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Align(
            alignment: Alignment.bottomRight,
            child: GestureDetector(
              child: Image.asset(
                getImagePath('mine_phone'),
                width: 31.w,
                height: 31.w,
              ),
              onTap: () {
                showBottomVideoOrVoiceChoice(
                  () {},
                  () {},
                  action1Str: "视频通话(${bean.videoCall}金币/分钟)",
                  action2Str: "语音通话(${bean.voiceCall}金币/分钟)",
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _widgetDialect(List<String> dialectList) {
    if (dialectList.isEmpty) return const SizedBox();
    final list = <Widget>[];
    for (int i = 0; i < 4 && i < dialectList.length; i++) {
      final element = dialectList[i];
      list.add(Container(
        decoration: BoxDecoration(
            color: Color(0xFFFEC693),
            borderRadius: BorderRadius.all(Radius.circular(2.w))),
        padding: EdgeInsets.symmetric(horizontal: 4.w),
        child: Text(element,
            style: TextStyle(
                fontSize: 10.sp,
                color: Colors.black,
                decoration: TextDecoration.none)),
      ));
    }
    return Wrap(
      spacing: 4.w,
      children: list,
    );
  }
}
