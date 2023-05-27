import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:metting/base/BaseController.dart';
import 'package:metting/page/message/message.dart';
import 'package:metting/page/message/message_bean.dart';
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
    return GetBuilder<MessagePageC>(
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
  MessageListController initController() => MessageListController();

  List<Widget> listWidget() {
    List<Widget> child = [];
    child.add(Padding(
      padding: EdgeInsets.only(bottom: 40.h),
      child: Text(''),
    ));
    return child;
  }

  Widget _item(MessageBean bean) {
    return slidableWithDelete(
        GestureDetector(
          onTap: () {},
          child: Container(
            height: 66.h,
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 6.h),
            child: Row(
              children: [
                cardNetworkImage(bean.avator??"", 50.h, 50.h),
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
                            '聊天消息',
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
                  '1分钟',
                  style: TextStyle(color: Colors.white, fontSize: 14.sp),
                ),
              ],
            ),
          ),
        ),
        (context) {});
  }

  void onRefresh() {}

  void onLoad() {}
}

class MessageListController extends BaseController {
  List<MessageBean> messageBean = [];

}
