import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/basic.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:metting/base/BaseController.dart';
import 'package:metting/base/BaseUiPage.dart';
import 'package:metting/network/bean/topic_list_res.dart';
import 'package:metting/network/http_helper.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../base/base_refresh_page.dart';
import '../../core/common_configure.dart';
import '../../database/get_storage_manager.dart';
import '../../dialog/dialog_square.dart';
import '../../network/bean/square.dart';
import '../../tool/str_utls.dart';
import '../../tool/view_tools.dart';
import '../../widget/bottom_popup.dart';
import '../../widget/image_m.dart';

class SquarePage extends BaseUiPage<SquareController> {
  SquarePage() : super(title: "灵魂广场");
  RefreshController mRefreshController =
      RefreshController(initialRefresh: true);
  CreateSquare? _createSquare;

  @override
  Widget createBody(BuildContext context) {
    return Stack(
      children: [
        GetBuilder<SquareController>(
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
                  child: refreshLayout(),
                ),
              );
            }),
        Align(
          alignment: Alignment.bottomRight,
          child: Padding(
            padding: EdgeInsets.only(bottom: 200.h, right: 9.w),
            child: GestureDetector(
              onTap: () {
                _createSquare ??= CreateSquare();
                _createSquare
                    ?.showDialog()
                    .then((value) => value == true ? onRefresh() : null);
              },
              child: Image.asset(
                getImagePath('mine_edit'),
                width: 56.w,
                height: 56.w,
              ),
            ),
          ),
        ),
      ],
    );
  }

  void onRefresh() {
    controller._refresh(mRefreshController);
  }

  void onLoad() {
    controller.load(mRefreshController);
  }

  Widget refreshLayout() {
    return MasonryGridView.count(
      crossAxisCount: 2,
      mainAxisSpacing: 9.h,
      itemCount: controller.listSquare.length,
      crossAxisSpacing: 12.w,
      itemBuilder: (context, index) {
        final item = _ItemView(
          bean: controller.listSquare[index],
        );
        if (index == controller.listSquare.length - 1) {
          return Padding(
            padding: EdgeInsets.only(bottom: 60.h),
            child: item,
          );
        } else {
          return item;
        }
      },
    );
  }

  @override
  SquareController initController() => SquareController();
}

class SquareController extends BaseController {
  List<SquareBean> listSquare = [];
  int page = 1;

  @override
  void onInit() {
    _getTopicList();
  }

  void _getTopicList() async {
    final bean = await getTopicList();
    if (bean.isOk()) {
      saveTopicListTStorage(bean.data);
    }
  }

  void _refresh(RefreshController refreshController) async {
    page = 1;
    final base = await getSquareList(page);
    if (base.isOk()) {
      final list = base.data?.data;
      listSquare.clear();
      if (list != null) {
        listSquare.addAll(list);
      }
      refreshController.refreshCompleted();
      update(['list']);
      page++;
    } else {
      refreshController.refreshFailed();
    }
  }

  void load(RefreshController refreshController) async {
    final base = await getSquareList(page);
    if (base.isOk()) {
      final list = base.data?.data;
      if (list != null) {
        listSquare.addAll(list);
        refreshController.refreshCompleted();
        update(['list']);
        page++;
      } else {
        refreshController.loadNoData();
      }
    } else {
      refreshController.refreshFailed();
    }
  }
}

class _ItemView extends GetView<SquareController> {
  _ItemView({required this.bean});

  late SquareBean bean;

  @override
  String? get tag => 'SquareController';

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
          _listChatTopic(),
          SizedBox(
            height: 6.h,
          ),
          _info()
        ],
      ),
    );
  }

  Widget _listChatTopic() {
    String t = "";
    List<String> list = bean.topic ?? [];
    for (var element in list) {
      t += element;
    }
    if (list.isEmpty) return const SizedBox();
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
    final dialectList = bean.lang ?? [];
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
              child: circleNetworkWidget(bean.avatar ?? "", 45.w, 45.w),
            ),
            SizedBox(
              width: 5.w,
            ),
            Expanded(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  bean.cname ?? "",
                  maxLines: 1,
                  style: TextStyle(color: Color(0xff6A6A6A), fontSize: 10.sp),
                ),
                Text(
                  '${bean.age}-${getSexString(bean.sex)}',
                  style: TextStyle(color: Color(0xffAAA9A9), fontSize: 10.sp),
                )
              ],
            )),
            SizedBox(
              width: 5.w,
            ),
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
