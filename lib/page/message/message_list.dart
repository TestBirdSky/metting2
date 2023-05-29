import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:metting/base/BaseController.dart';
import 'package:metting/page/message/message.dart';
import 'package:metting/page/message/message_bean.dart';
import 'package:metting/page/message/message_chat_page.dart';
import 'package:metting/tool/emc_helper.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../base/BaseStatelessPage.dart';
import '../../base/base_refresh_page.dart';
import '../../widget/image_m.dart';
import '../../widget/slidable_widget.dart';

class MessageListPage extends BaseStatelessPage<MessageListController> {
  RefreshController mRefreshController =
      RefreshController(initialRefresh: false);

  @override
  Widget createBody(BuildContext context) {
    return GetBuilder<MessageListController>(
        id: 'list',
        builder: (c) {
          return RefreshConfiguration(
            // Viewport不满一屏时,禁用上拉加载更多功能,应该配置更灵活一些，比如说一页条数大于等于总条数的时候设置或者总条数等于0
            hideFooterWhenNotFull: true,
            child: SmartRefresher(
              enablePullDown: true,
              enablePullUp: true,
              header: const NUllTipsClassicHeader(),
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
  MessageListController initController() => MessageListController();

  List<Widget> listWidget() {
    List<Widget> child = [];
    for (var element in controller.messageBean) {
      child.add(_item(element));
    }
    child.add(Padding(
      padding: EdgeInsets.only(bottom: 40.h),
      child: Text(''),
    ));
    return child;
  }

  Widget _item(MessageBean bean) {
    return GestureDetector(
      onTap: () {
        Get.to(MessageChatPage(
          title: bean.name ?? "",
          uid: bean.uid,
        ));
      },
      child: slidableWithDelete(
          Container(
            height: 66.h,
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 6.h),
            child: Row(
              children: [
                cardNetworkImage(bean.avator ?? "", 50.h, 50.h),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.w),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Expanded(
                            child: Text(''),
                          ),
                          Text(
                            '${bean.name}',
                            maxLines: 1,
                            style:
                                TextStyle(color: Colors.white, fontSize: 14.sp),
                          ),
                          SizedBox(
                            height: 4.h,
                          ),
                          Text(
                            bean.getShowMsg(),
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
                ),
                Text(
                  bean.getShowTime(),
                  style: TextStyle(color: Colors.white, fontSize: 14.sp),
                ),
              ],
            ),
          ),
          (context) {}),
    );
  }

  void onRefresh() {
    controller.refreshData(mRefreshController);
  }

  void onLoad() {
    controller.loadData(mRefreshController);
  }
}

class MessageListController extends BaseController {
  List<MessageBean> messageBean = [];
  int pageNum = 1;

  @override
  void onInit() {
    super.onInit();
    refreshData(null);
  }

  void refreshData(RefreshController? refreshController) async {
    pageNum = 1;
    final list = await EmcHelper.getAllConversationsMessage(pageNum: pageNum);
    messageBean.clear();
    if (list.isNotEmpty) {
      messageBean.addAll(list);
      update(['list']);
    }
    refreshController?.refreshCompleted();
  }

  void loadData(RefreshController refreshController) async {
    pageNum++;
    final list = await EmcHelper.getAllConversationsMessage(pageNum: pageNum);
    if (list.isNotEmpty) {
      messageBean.addAll(list);
      update(['list']);
    }
    if (list.length < 30) {
      refreshController.loadNoData();
    } else {
      refreshController.loadComplete();
    }
  }
}
