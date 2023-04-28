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

import '../../core/common_configure.dart';
import '../../network/bean/note_details.dart';
import 'create_note_dialog.dart';

class NoteDetailsPage extends BaseRefreshPage<NoteDetailsC> {
  late bool isMe;

  NoteDetailsPage({this.isMe = false}) : super(title: "");

  @override
  NoteDetailsC initController() => NoteDetailsC();

  @override
  RefreshController refreshController() =>
      RefreshController(initialRefresh: true);

  @override
  Widget refreshLayout() {
    return GetBuilder<NoteDetailsC>(
        id: 'list',
        builder: (c) {
          return ListView(
            shrinkWrap: true,
            children: _list(),
          );
        });
  }

  List<Widget> _list() {
    var list = <Widget>[];
    for (int index = 0; index < controller.listNote.length; index++) {
      list.add(_item(controller.listNote[index]));
    }
    return list;
  }

  Widget _item(NoteDetailsBean bean) {
    return IntrinsicHeight(
      child: Container(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              children: [
                Text("${bean.date}"),
                Container(
                  width: 3.w,
                  height: 10.h,
                  color: Colors.amberAccent,
                ),
                Text("${bean.time}"),
                Expanded(
                  child: Container(
                    width: 3.w,
                    color: Colors.amberAccent,
                  ),
                )
              ],
            ),
            Container(
              margin: EdgeInsets.all(10),
              color: Colors.white10,
              child: Text("${bean.content}"),
            )
          ],
        ),
      ),
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
                  showCreateNoteDialog(mContext);
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
        id: 'title',
        builder: (c) {
          return Text(
            c.getTitle(),
            style: TextStyle(color: C.whiteFFFFFF, fontSize: 18.sp),
          );
        });
  }

  @override
  void onRefresh() {
    controller._refresh(refreshC);
  }

  @override
  void onLoading() {
    controller._load(refreshC);
  }
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
      update(['title']);
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
