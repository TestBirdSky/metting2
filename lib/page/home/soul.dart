import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:metting/base/BaseController.dart';
import 'package:metting/base/base_refresh_page.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class SoulPage extends BaseRefreshPage<SoulC> {
  SoulPage() : super(title: '灵魂广场');

  @override
  SoulC initController() => SoulC();

  @override
  Widget refreshLayout() {
    return MasonryGridView.count(
      crossAxisCount: 2,
      mainAxisSpacing: 9.h,
      itemCount: 12,
      crossAxisSpacing: 11.w,
      itemBuilder: (context, index) {
        return _ItemView();
      },
    );
  }

  @override
  RefreshController refreshController() =>
      RefreshController(initialRefresh: false);
}

class SoulC extends BaseController {}

class _ItemView extends GetView<SoulC> {
  @override
  String? get tag => "SoulC";

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Color(0x8013181E),
        borderRadius: BorderRadius.all(Radius.circular(5.w)),
      ),
      child: Column(
        children: [

        ],
      ),
    );
  }
}
