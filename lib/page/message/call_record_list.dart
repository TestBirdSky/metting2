import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../base/BaseController.dart';
import '../../base/BaseStatelessPage.dart';
import '../../base/base_refresh_page.dart';
import '../../network/bean/call_chat_history_list.dart';
import '../../network/http_helper.dart';
import '../../widget/image_m.dart';
import '../../widget/slidable_widget.dart';

class CallRecordListPageg extends BaseStatelessPage<CallRecordListController> {
  RefreshController mRefreshController =
      RefreshController(initialRefresh: false);

  @override
  Widget createBody(BuildContext context) {
    return GetBuilder<CallRecordListController>(
        id: 'list',
        builder: (c) {
          return RefreshConfiguration(
            // Viewport不满一屏时,禁用上拉加载更多功能,应该配置更灵活一些，比如说一页条数大于等于总条数的时候设置或者总条数等于0
            hideFooterWhenNotFull: true,
            child: SmartRefresher(
              enablePullDown: false,
              enablePullUp: true,
              header: const MyClassicHeader(),
              footer: const MyClassicFooter(),
              // 配置默认底部指示器
              controller: mRefreshController,
              onRefresh: onRefresh,
              onLoading: onLoad,
              child: ListView(
                shrinkWrap: false,
                children: listWidget(),
              ),
            ),
          );
        });
  }

  @override
  CallRecordListController initController() => CallRecordListController();

  List<Widget> listWidget() {
    List<Widget> child = [];
    for (var element in controller.historyList) {
      child.add(_item(element));
    }
    return child;
  }

  Widget _item(HistoryBean bean) {
    return slidableWithDelete(
        GestureDetector(
          onTap: () {},
          child: Container(
            height: 66.h,
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 6.h),
            child: Row(
              children: [
                cardNetworkImage(bean.avatar ?? "", 50.h, 50.h),
                Expanded(
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Expanded(
                          child: Text(''),
                        ),
                        Text(
                          bean.cname ?? "",
                          maxLines: 1,
                          style:
                              TextStyle(color: Colors.white, fontSize: 14.sp),
                        ),
                        SizedBox(
                          height: 4.h,
                        ),
                        Text(
                          '聊天${bean.chatMinutes}',
                          maxLines: 1,
                          style:
                              TextStyle(color: Colors.white, fontSize: 12.sp),
                        ),
                        const Expanded(
                          child: Text(''),
                        ),
                      ],
                    ),
                  ),
                ),
                Text(
                  bean.time ?? "",
                  style: TextStyle(color: Colors.white, fontSize: 14.sp),
                ),
              ],
            ),
          ),
        ),
        (context) {});
  }

  void onRefresh() {
    controller.getCallRecord(mRefreshController);
  }

  void onLoad() {
    controller.loadMoreCallRecord(mRefreshController);
  }
}

class CallRecordListController extends BaseController {
  List<HistoryBean> historyList = [];

  int page = 1;

  @override
  void onInit() {
    super.onInit();
    getCallRecord(null);
  }

  void getCallRecord(RefreshController? refreshController) async {
    page = 1;
    final base = await getCallHistory(page);
    if (base.isOk()) {
      final list = base.data?.data;
      historyList.clear();
      if (list != null) {
        historyList.addAll(list);
      }
      refreshController?.refreshCompleted();
      update(['list']);
      page++;
    } else {
      refreshController?.refreshFailed();
    }
  }

  void loadMoreCallRecord(RefreshController refreshController) async {
    final base = await getCallHistory(page);
    if (base.isOk()) {
      final list = base.data?.data;
      if (list != null) {
        page++;
        historyList.addAll(list);
        refreshController.refreshCompleted();
        update(['list']);
      } else {
        refreshController.loadNoData();
      }
    } else {
      refreshController.refreshFailed();
    }
  }
}
