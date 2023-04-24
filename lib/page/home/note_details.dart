
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:metting/base/BaseController.dart';
import 'package:metting/base/base_refresh_page.dart';
import 'package:pull_to_refresh/src/smart_refresher.dart';

class NoteDetailsPage extends BaseRefreshPage<NoteDetailsC> {
  NoteDetailsPage({required super.title});

  @override
  NoteDetailsC initController() => NoteDetailsC();

  @override
  RefreshController refreshController() => RefreshController();

  @override
  Widget refreshLayout() {
    return ListView(
      shrinkWrap: true,
      children: _list(),
    );
  }

  List<Widget> _list() {
    var list = <Widget>[];
    for (int index = 0; index < 20; index++) {
      list.add(_item());
    }
    return list;
  }

  Widget _item() {
    return IntrinsicHeight(
      child: Container(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              children: [
                Text("time"),
                Container(
                  width: 3.w,
                  height: 10.h,
                  color: Colors.amberAccent,
                ),
                Text("20-1"),
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
              child: Text('te'),
            )
          ],
        ),
      ),
    );
  }

  @override
  List<Widget>? action() {
    return [
      Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: GestureDetector(
          onTap: () {
            // showCreateNoteDialog(mContext);
          },
          child: Icon(
            Icons.add,
            color: Colors.white,
          ),
        ),
      )
    ];
  }
}

class NoteDetailsC extends BaseController {}
