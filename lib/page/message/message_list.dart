import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:metting/base/BaseController.dart';
import 'package:metting/page/message/message.dart';
import 'package:metting/page/message/conversations_bean.dart';
import 'package:metting/page/message/message_chat_page.dart';
import 'package:metting/tool/emc_helper.dart';
import 'package:metting/tool/log.dart';
import 'package:metting/widget/loading.dart';
import 'package:metting/widget/my_toast.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../base/BaseStatelessPage.dart';
import '../../base/base_refresh_page.dart';
import '../../widget/dialog_alert.dart';
import '../../widget/image_m.dart';
import '../../widget/slidable_widget.dart';
import 'message_list_controller.dart';

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

  Widget _item(ConversationBean bean) {
    return GestureDetector(
      onTap: () {
        Get.to(() => MessageChatPage(
              title: bean.name ?? "",
              uid: bean.id,
            ))?.then((value) => controller.refreshConversationData(bean));
      },
      child: slidableWithDelete(
          Container(
            height: 66.h,
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 6.h),
            child: Stack(children: [
              Row(
                children: [
                  cardNetworkImage(bean.avator ?? "", 50.h, 54.h),
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
                              style: TextStyle(
                                  color: Colors.white, fontSize: 14.sp),
                            ),
                            SizedBox(
                              height: 6.h,
                            ),
                            Text(
                              bean.getShowMsg(),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  color: Colors.white, fontSize: 12.sp),
                            ),
                            const Expanded(
                              child: Text(''),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Column(
                    children: [
                      Expanded(flex: 2, child: Text('')),
                      Text(
                        bean.getShowTime(),
                        style: TextStyle(color: Colors.white, fontSize: 12.sp),
                      ),
                      Expanded(flex: 3, child: Text('')),
                      bean.unReadCount == 0
                          ? SizedBox(
                              width: 20.h,
                              height: 20.h,
                            )
                          : ClipOval(
                              child: Container(
                                width: 20.h,
                                height: 20.h,
                                color: Colors.red,
                                child: Align(
                                  alignment: Alignment.center,
                                  child: Text(
                                    bean.getUnReadCount(),
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 11.sp),
                                  ),
                                ),
                              ),
                            ),
                      Expanded(flex: 2, child: Text('')),
                    ],
                  )
                ],
              ),
            ]),
          ), (context) {
        commonAlertD(mContext, "是否删除您与${bean.name}的聊天？", "删除",
            title: "删除聊天", negativeStr: "取消", positiveCall: () {
          controller.delCon(bean, true);
        });
      }),
    );
  }

  void onRefresh() {
    controller.refreshData(mRefreshController);
  }

  void onLoad() {
    controller.loadData(mRefreshController);
  }
}
