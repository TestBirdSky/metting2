import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:metting/base/BaseUiPage.dart';
import 'package:metting/base/base_refresh_page.dart';
import 'package:metting/core/common_configure.dart';
import 'package:metting/network/bean/listener.dart';
import 'package:metting/network/http_helper.dart';
import 'package:metting/tool/log.dart';
import 'package:metting/tool/view_tools.dart';
import 'package:pull_to_refresh/src/smart_refresher.dart';

import '../../base/BaseController.dart';
import '../../widget/bottom_popup.dart';
import '../../widget/image_m.dart';

class ListenerPage extends BaseUiPage<ListenerPageC> {
  ListenerPage() : super(title: "倾听者");

  @override
  Widget? backWidget() {
    return null;
  }

  @override
  ListenerPageC initController() => ListenerPageC();

  void _onLoading() {
    logger.i("onLoading");
    controller.load();
  }

  //
  void _onRefresh() {
    controller.refresh();
  }

  //
  // @override
  RefreshController refreshController() =>
      RefreshController(initialRefresh: false);

  @override
  Widget createBody(BuildContext context) {
    return Stack(
      children: [
        Container(
          color: C.PAGE_THEME_BG,
          padding: EdgeInsets.only(left: 12.w, right: 12.w, top: 50.h),
          child: RefreshConfiguration(
            // Viewport不满一屏时,禁用上拉加载更多功能,应该配置更灵活一些，比如说一页条数大于等于总条数的时候设置或者总条数等于0
            hideFooterWhenNotFull: true,
            child: SmartRefresher(
              enablePullDown: true,
              enablePullUp: true,
              header: const MyClassicHeader(),
              footer: const MyClassicFooter(),
              // 配置默认底部指示器
              controller: refreshController(),
              onRefresh: _onRefresh,
              onLoading: _onLoading,
              child: MasonryGridView.count(
                crossAxisCount: 2,
                mainAxisSpacing: 9.h,
                itemCount: controller.listenerList.length,
                crossAxisSpacing: 12.w,
                itemBuilder: (context, index) {
                  final item =
                      _ItemView(listenerRes: controller.listenerList[index]);
                  if (index == controller.listenerList.length - 1) {
                    return Padding(
                      padding: EdgeInsets.only(bottom: 60.h),
                      child: item,
                    );
                  } else {
                    return item;
                  }
                },
              ),
            ),
          ),
        ),
        Container(
          height: 50.h,
          padding: EdgeInsets.symmetric(horizontal: 9.w),
          alignment: Alignment.center,
          child: GetBuilder<ListenerPageC>(
              id: "top",
              builder: (c) {
                return ListView(
                  scrollDirection: Axis.horizontal,
                  children: _topMenu(),
                );
              }),
        ),
      ],
    );
  }

  List<Widget> _topMenu() {
    final list = <Widget>[];
    for (var element in controller.topItem) {
      list.add(_topMenuItem(element, Colors.amberAccent));
    }
    return list;
  }

  Widget _topMenuItem(String info, Color bgColor) {
    return Stack(
      children: [
        Align(
          alignment: Alignment.center,
          child: Container(
            height: 26.h,
            width: 82.w,
            margin: EdgeInsets.symmetric(horizontal: 3.w),
            decoration: BoxDecoration(
                color: bgColor,
                // border: Border.all(color: Color(0xFFFEC693), width: 1.w),
                borderRadius: BorderRadius.all(Radius.circular(5.w))),
            child: Stack(
              children: [
                Align(
                    alignment: Alignment.center,
                    child: Text(
                      info,
                      style: TextStyle(color: Colors.white, fontSize: 12.sp),
                      textAlign: TextAlign.center,
                    ))
              ],
            ),
          ),
        )
      ],
    );
  }
}

class ListenerPageC extends BaseController {
  List<String> topItem = [
    '婚姻',
    '爱情',
    '婚姻444444',
    '爱情',
    '婚姻',
    '爱情',
    '婚姻',
    '爱情',
  ];

  List<ListenerRes> listenerList = [];

  @override
  void onInit() {
    super.onInit();
  }

  int page = 0;

  void refresh() async {
    page = 0;
    final base = await getListener(page);
    if (base.isOk()) {
      final list = base.data?.data;
      if (list != null) {
        listenerList.addAll(list);
      }
      page++;
    }
  }



  void load() async {

  }
}

class _ItemView extends GetView<ListenerPageC> {
  _ItemView({required this.listenerRes});

  late ListenerRes listenerRes;

  @override
  String? get tag => 'ListenerPageC';

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8.w),
      decoration: BoxDecoration(
        color: Color(0x8013181E),
        borderRadius: BorderRadius.all(Radius.circular(5.w)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _widgetDialect(),
          _listCommentWrap(),
          _listChatTopic(),
          SizedBox(
            height: 6.h,
          ),
          _info()
        ],
      ),
    );
  }

  Widget _listCommentWrap() {
    String t = "";
    List<String> list = listenerRes.comment ?? [];
    for (var element in list) {
      t += element;
    }
    if (list.isNotEmpty) return const SizedBox();
    return Column(
      children: [
        SizedBox(
          height: 4.h,
        ),
        Text(
          '交流评语:',
          style: TextStyle(color: Color(0xffF7BB76), fontSize: 12.sp),
        ),
        SizedBox(
          height: 2.h,
        ),
        Text(
          t,
          style: TextStyle(color: Colors.white, fontSize: 10.sp),
        )
      ],
    );
  }

  Widget _listChatTopic() {
    String t = "";
    List<String> list = listenerRes.chatContent ?? [];
    for (var element in list) {
      t += element;
    }
    if (list.isNotEmpty) return const SizedBox();
    return Column(
      children: [
        SizedBox(
          height: 4.h,
        ),
        SizedBox(
          height: 4.h,
        ),
        Text(
          '聊天话题:',
          style: TextStyle(color: Color(0xffF7BB76), fontSize: 12.sp),
        ),
        SizedBox(
          height: 2.h,
        ),
        Text(
          t,
          style: TextStyle(color: Colors.white, fontSize: 10.sp),
        )
      ],
    );
  }

  Widget _widgetDialect() {
    final list = <Widget>[];
    final dialectList = listenerRes.lang ?? [];
    for (var element in dialectList) {
      list.add(Container(
        decoration: BoxDecoration(
            color: Color(0xFFFEC693),
            borderRadius: BorderRadius.all(Radius.circular(2.w))),
        margin: EdgeInsets.only(right: 6.w, bottom: 4.h),
        padding: EdgeInsets.symmetric(horizontal: 4.w),
        child: Text(element,
            style: TextStyle(fontSize: 10.sp, color: Colors.black)),
      ));
    }
    return Wrap(
      spacing: 4.w,
      children: list,
    );
  }

  Widget _info() {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          width: 146.w,
          height: 35.h,
          color: Color(0xfffdfcdd),
        ),
        Row(
          children: [
            Container(
              padding: EdgeInsets.all(1.w),
              decoration:
                  BoxDecoration(color: C.FEC693, shape: BoxShape.circle),
              width: 45.w,
              height: 45.w,
              child: circleNetworkWidget(listenerRes.avatar ?? "", 45.w, 45.w),
            ),
            Expanded(
                child: Column(
              children: [Text('ttt')],
            )),
            InkWell(
              child: Image.asset(
                getImagePath('mine_phone'),
                height: 35.h,
                width: 35.h,
              ),
              onTap: () {
                showBottomChoice(_voice, _video);
              },
            )
          ],
        )
      ],
    );
  }

  void _voice() {}

  void _video() {}
}
