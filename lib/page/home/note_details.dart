import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:metting/base/BaseController.dart';
import 'package:metting/base/base_refresh_page.dart';
import 'package:metting/network/bean/user_data_res.dart';
import 'package:metting/network/http_helper.dart';
import 'package:pull_to_refresh/src/smart_refresher.dart';

import '../../base/BaseUiPage.dart';
import '../../core/common_configure.dart';
import '../../network/bean/note_details.dart';
import '../../tool/view_tools.dart';
import '../../widget/bottom_popup.dart';
import '../../widget/image_m.dart';
import 'create_note_dialog.dart';

class NoteDetailsPage extends BaseUiPage<NoteDetailsC> {
  late bool isMe;

  NoteDetailsPage({this.isMe = false}) : super(title: "");

  @override
  NoteDetailsC initController() => NoteDetailsC();

  RefreshController mRefreshController =
      RefreshController(initialRefresh: true);

  @override
  Widget createBody(BuildContext context) {
    return Stack(
      children: [
        GetBuilder<NoteDetailsC>(
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
        Align(alignment: Alignment.bottomCenter, child: _infoWidget()),
      ],
    );
  }

  List<Widget> _list() {
    var list = <Widget>[
      SizedBox(
        height: 30.h,
      ),
    ];
    for (int index = 0; index < controller.listNote.length; index++) {
      list.add(_item(controller.listNote[index]));
    }
    if (list.length > 1) {
      list.add(SizedBox(
        height: 50.h,
      ));
    }
    return list;
  }

  Widget _item(NoteDetailsBean bean) {
    return IntrinsicHeight(
      child: Container(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 20.w,
            ),
            Column(
              children: [
                Container(
                  width: 54.w,
                  padding: EdgeInsets.symmetric(vertical: 2.h),
                  decoration: BoxDecoration(
                      color: Color(0xffCCCCCC),
                      borderRadius: BorderRadius.all(Radius.circular(2.w))),
                  child: Align(
                    alignment: Alignment.center,
                    child: Text(
                      "${bean.date}",
                      style: TextStyle(color: Colors.white, fontSize: 11.sp),
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Container(
                    width: 1.5.w,
                    color: Color(0xffCCCCCC),
                  ),
                ),
                Container(
                  width: 9.w,
                  height: 9.h,
                  margin: EdgeInsets.symmetric(vertical: 2.h),
                  child: ClipOval(
                    child: Container(
                      color: Color(0xffCCCCCC),
                    ),
                  ),
                ),
                Text("${bean.time}",
                    style:
                        TextStyle(color: Color(0xff999999), fontSize: 11.sp)),
                Expanded(
                  flex: 3,
                  child: Container(
                    width: 1.5.w,
                    color: Color(0xffCCCCCC),
                  ),
                )
              ],
            ),
            Expanded(
              child: Container(
                margin: EdgeInsets.fromLTRB(20.w, 30.h, 20.w, 14.h),
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                decoration: BoxDecoration(
                    color: Color(0xffCCCCCC),
                    borderRadius: BorderRadius.all(Radius.circular(2.w))),
                child: Text("${bean.content}"),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _infoWidget() {
    return Container(
      width: 320.w,
      child: GetBuilder<NoteDetailsC>(
          id: 'info',
          builder: (c) {
            return isMe ? SizedBox() : _info();
          }),
    );
  }

  @override
  List<Widget>? action() {
    return isMe
        ? [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: GestureDetector(
                onTap: () {
                  showCreateNoteDialog(mContext).then((value) => {
                        if (value != null) {onRefresh()}
                      });
                },
                child: const Icon(
                  Icons.add,
                  color: Colors.white,
                ),
              ),
            )
          ]
        : null;
  }

  @override
  Widget? titleWidget() {
    return GetBuilder<NoteDetailsC>(
        id: 'info',
        builder: (c) {
          return Text(
            c.getTitle(),
            style: TextStyle(color: C.whiteFFFFFF, fontSize: 18.sp),
          );
        });
  }

  void onRefresh() {
    controller._refresh(mRefreshController);
  }

  void onLoad() {
    controller._load(mRefreshController);
  }

  Widget _info() {
    final userInfo = controller.userDataRes;
    return userInfo == null
        ? SizedBox()
        : Container(
            height: 56.w,
            margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 20.w),
                  height: 42.h,
                  color: Color(0xfffdfcdd),
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      padding: EdgeInsets.all(1.w),
                      decoration: BoxDecoration(
                          color: C.FEC693, shape: BoxShape.circle),
                      width: 56.w,
                      height: 56.w,
                      child: circleNetworkWidget(
                          userInfo.avatar ?? "", 45.w, 45.w),
                    ),
                    SizedBox(
                      width: 12.w,
                    ),
                    Expanded(
                        child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          userInfo.cname ?? "",
                          maxLines: 1,
                          style: TextStyle(
                              color: Color(0xff6B6A6A), fontSize: 12.sp),
                        ),
                        SizedBox(
                          height: 2.h,
                        ),
                        Text(
                          '${userInfo.age}-${userInfo.sexStr}',
                          style: TextStyle(
                              color: Color(0xff6B6A6A), fontSize: 10.sp),
                        )
                      ],
                    )),
                    SizedBox(
                      width: 5.w,
                    ),
                    InkWell(
                      child: Image.asset(
                        getImagePath('mine_phone'),
                        height: 42.h,
                        width: 42.h,
                      ),
                      onTap: () {
                        showBottomVideoOrVoiceChoice(_voice, _video);
                      },
                    )
                  ],
                )
              ],
            ),
          );
  }

  void _voice() {}

  void _video() {}
}

class NoteDetailsC extends BaseController {
  int uid = 0;
  UserDataRes? userDataRes;
  List<NoteDetailsBean> listNote = [];
  int page = 1;

  // List<>
  @override
  void onInit() {
    uid = Get.arguments['uid'];
    super.onInit();
    _getUserInfo();
  }

  void _getUserInfo() async {
    final data = await getUserData(uid);
    if (data.isOk()) {
      userDataRes = data.data;
      update(['info']);
    }
  }

  String getTitle() {
    return userDataRes?.cname != null ? '${userDataRes?.cname}的日记' : "日记";
  }

  void _refresh(RefreshController refreshController) async {
    page = 1;
    final base = await getNoteDetails(uid, page);
    if (base.isOk()) {
      final list = base.data?.data;
      listNote.clear();
      if (list != null) {
        listNote.addAll(list);
      }
      refreshController.refreshCompleted();
      update(['list']);
      page++;
    } else {
      refreshController.refreshFailed();
    }
  }

  void _load(RefreshController refreshController) async {
    final base = await getNoteDetails(uid, page);
    if (base.isOk()) {
      final list = base.data?.data;
      if (list != null) {
        listNote.addAll(list);
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
