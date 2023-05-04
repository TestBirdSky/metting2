import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../base/base_refresh_page.dart';
import '../network/bean/user_data_res.dart';
import '../tool/view_tools.dart';

void showInfoDialog(UserDataRes info) {
  Get.dialog(Container(
    margin: EdgeInsets.symmetric(vertical: 64.h, horizontal: 20.w),
    decoration: BoxDecoration(
      color: const Color(0xff13181E),
      borderRadius: BorderRadius.all(Radius.circular(12.w)),
    ),
    child: Stack(
      children: [
        SizedBox(
            height: 360.h,
            child: CachedNetworkImage(
              fit: BoxFit.cover,
              imageUrl: info.avatar ?? "",
            )),
        // _listView(info),
        _refreshLayout(info),
        Align(
          alignment: Alignment.centerRight,
          child: GestureDetector(
            onTap: () {},
            child: Image.asset(
              getImagePath('mine_phone'),
              width: 52.w,
              height: 52.w,
            ),
          ),
        ),
      ],
    ),
  ));
}

Widget _refreshLayout(UserDataRes info) {
  final mRefreshController = RefreshController();
  final list = [];
  return StatefulBuilder(builder: (context, state) {
    List<Widget> listWidget = [_infoWidget(info)];
    return RefreshConfiguration(
      // Viewport不满一屏时,禁用上拉加载更多功能,应该配置更灵活一些，比如说一页条数大于等于总条数的时候设置或者总条数等于0
      hideFooterWhenNotFull: true,
      child: SmartRefresher(
        enablePullUp: true,
        header: const MyClassicHeader(),
        footer: const MyClassicFooter(),
        // 配置默认底部指示器
        controller: mRefreshController,
        onLoading: () {
          _onLoad();
        },
        child: ListView(
          shrinkWrap: true,
          children: listWidget,
        ),
      ),
    );
  });
}

// List<Widget> _getList() {}
void _onLoad() {}

Widget _infoWidget(UserDataRes info) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Container(
          width: 203.w,
          height: 203.h,
          margin: EdgeInsets.only(top: 157.h),
          padding: EdgeInsets.all(8.w),
          decoration: BoxDecoration(
            color: Color(0x8013181E),
            borderRadius: BorderRadius.all(Radius.circular(5.w)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _listCommentWrap(info.comment ?? []),
              _listChatTopic(info.chatContent ?? []),
              SizedBox(
                height: 6.h,
              ),
              _widgetDialect(info.lang ?? []),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    info.cname ?? "",
                    style: TextStyle(
                        color: Color(0xffB5B4B4),
                        fontSize: 16.sp,
                        decoration: TextDecoration.none),
                  ),
                  SizedBox(
                    width: 10.w,
                  ),
                  Text(
                    '${info.age}-${info.sexStr}',
                    style: TextStyle(
                        color: Color(0xffB5B4B4),
                        fontSize: 12.sp,
                        decoration: TextDecoration.none),
                  ),
                ],
              ),
              Row(
                children: [
                  Icon(
                    Icons.location_on,
                    size: 22.w,
                    color: Colors.white,
                  ),
                  SizedBox(
                    width: 10.w,
                  ),
                  Text('${info.region}',
                      style: TextStyle(
                          color: Color(0xffB5B4B4),
                          fontSize: 12.sp,
                          decoration: TextDecoration.none))
                ],
              )
            ],
          )),
    ],
  );
}

Widget _listCommentWrap(List<String> comment) {
  if (comment.isEmpty) return const SizedBox();
  String t = "";
  for (var element in comment) {
    t += element;
  }
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

Widget _listChatTopic(List<String> chatList) {
  if (chatList.isEmpty) return const SizedBox();
  String t = "";
  for (var element in chatList) {
    t += element;
  }
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

Widget _widgetDialect(List<String> dialectList) {
  if (dialectList.isEmpty) return const SizedBox();
  final list = <Widget>[];
  for (var element in dialectList) {
    list.add(Container(
      decoration: BoxDecoration(
          color: Color(0xFFFEC693),
          // border: Border.all(color: Colors.white, width: 1.w),
          borderRadius: BorderRadius.all(Radius.circular(2.w))),
      margin: EdgeInsets.only(right: 6.w, bottom: 4.h),
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
