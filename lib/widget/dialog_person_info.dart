import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:metting/database/get_storage_manager.dart';
import 'package:metting/page/message/message_chat_page.dart';
import 'package:metting/widget/loading.dart';
import 'package:metting/widget/my_toast.dart';
import 'package:metting/widget/null_widget.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../base/base_refresh_page.dart';
import '../network/bean/tread_list.dart';
import '../network/bean/user_data_res.dart';
import '../network/http_helper.dart';
import '../tool/view_tools.dart';
import 'image_m.dart';

class PersonInfoDialog {
  List<TreadBean> treadBeanList = [];
  final mRefreshController = RefreshController();
  late StateSetter _dialogState;

  void showInfoDialogWithUit(num? uid) async {
    if (uid == null) return;
    LoadingUtils.showLoading();
    final data = await getUserData(uid);
    if (data.isOk() && data.data != null) {
      showInfoDialog(data.data!);
    } else {
      MyToast.show(data.msg);
    }
    LoadingUtils.dismiss();
  }

  void showInfoDialog(UserDataRes info) {
    _refreshTread();
    Get.dialog(
      Container(
        margin: EdgeInsets.symmetric(vertical: 76.h, horizontal: 20.w),
        decoration: BoxDecoration(
          color: const Color(0xff13181E),
          borderRadius: BorderRadius.all(Radius.circular(12.w)),
        ),
        child: Stack(
          children: [
            _refreshLayout(info),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.w),
              child: Align(
                  alignment: Alignment.centerRight,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      GestureDetector(
                        onTap: () {},
                        child: Image.asset(
                          getImagePath('mine_phone'),
                          width: 52.w,
                          height: 52.w,
                        ),
                      ),
                      SizedBox(
                        height: 20.h,
                      ),
                      GestureDetector(
                        onTap: () {
                          Get.to(MessageChatPage(
                            title: info.cname ?? "",
                            uid: "${getMineUID() == 164034 ? 164035 : 164034}",
                          ));
                        },
                        child: Image.asset(
                          getImagePath('ic_message'),
                          width: 52.w,
                          height: 52.w,
                        ),
                      ),
                    ],
                  )),
            ),
          ],
        ),
      ),
      useSafeArea: false,
    );
  }

  Widget _refreshLayout(UserDataRes info) {
    return StatefulBuilder(builder: (context, state) {
      List<Widget> listWidget = [_infoWidget(info)];
      listWidget.addAll(_list());
      _dialogState = state;
      return RefreshConfiguration(
        hideFooterWhenNotFull: true,
        child: SmartRefresher(
          enablePullDown: false,
          enablePullUp: true,
          // header: const MyClassicHeader(),
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

  void _onLoad() async {
    final base = await getTreadList(_page);
    if (base.isOk()) {
      final list = base.data?.data;
      if (list != null) {
        treadBeanList.addAll(list);
        mRefreshController.refreshCompleted();
        _dialogState(() {});
      } else {
        _page++;
        mRefreshController.loadNoData();
      }
    } else {
      mRefreshController.refreshFailed();
    }
  }

  int _page = 1;

  void _refreshTread() async {
    _page = 1;
    final base = await getTreadList(_page);
    if (base.isOk()) {
      final list = base.data?.data;
      treadBeanList.clear();
      if (list != null) {
        treadBeanList.addAll(list);
      }
      mRefreshController.refreshCompleted();
      _dialogState(() {});
      _page++;
    } else {
      mRefreshController.refreshFailed();
    }
  }

  List<Widget> _list() {
    final list = <Widget>[];
    for (TreadBean treadBean in treadBeanList) {
      if (treadBean.type == 2) {
        list.add(_itemVoice());
      } else {
        list.add(_itemText(treadBean));
      }
    }
    if (list.isEmpty) list.add(Container(height: 300.h, child: NullWidget()));
    return list;
  }

  Widget _itemVoice() {
    return Container(
        height: 68.h,
        padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 12.h),
        decoration: BoxDecoration(
            color: Color(0xff13181E),
            borderRadius: BorderRadius.all(Radius.circular(5.w))),
        child: Row(
          children: [
            SizedBox(
              height: 78.h,
              child: Image.asset(getImagePath('ic_voice_icon')),
            ),
            SizedBox(width: 30.w),
            Image.asset(
              getImagePath('ic_microphone'),
              width: 33.w,
              height: 33.w,
            )
          ],
        ));
  }

  Widget _itemText(TreadBean treadBean) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10.h),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 12.h),
        decoration: BoxDecoration(
            color: Color(0xff13181E),
            borderRadius: BorderRadius.all(Radius.circular(5.w))),
        child: Text(
          treadBean.content ?? "",
          style: TextStyle(color: Color(0xffBBBABA), fontSize: 12.sp),
        ),
      ),
    );
  }

  Widget _infoWidget(UserDataRes info) {
    return SizedBox(
      height: 360.h,
      child: Stack(
        children: [
          SizedBox(
              height: 360.h,
              child: cardNetworkImage(info.avatar ?? "", double.infinity, 360.h,
                  margin: const EdgeInsets.all(0),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadiusDirectional.only(
                          topStart: Radius.circular(12.w),
                          topEnd: Radius.circular(12.w))))),
          Align(
            alignment: Alignment.bottomLeft,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                    width: 203.w,
                    // height: 203.h,
                    // margin: EdgeInsets.only(top: 157.h),
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
            ),
          )
        ],
      ),
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
}
