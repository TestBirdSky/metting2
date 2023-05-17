import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:metting/widget/image_m.dart';
import 'package:metting/widget/my_toast.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../base/BaseController.dart';
import '../../base/BaseUiPage.dart';
import '../../base/base_refresh_page.dart';
import '../../core/common_configure.dart';
import '../../database/get_storage_manager.dart';
import '../../network/http_helper.dart';
import '../../widget/slidable_widget.dart';

class MessagePage extends BaseUiPage<MessagePageC> {
  MessagePage() : super(title: "消息");
  RefreshController mRefreshController = RefreshController();

  @override
  Widget? backWidget() {
    return null;
  }

  @override
  Widget createBody(BuildContext context) {
    return GetBuilder<MessagePageC>(
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

  void onRefresh() {

  }

  void onLoad() {

  }

  final pageController = PageController(initialPage: 0);



  List<Widget> listWidget() {
    List<Widget> child = [_item(), _item(), _item()];
    return child;
  }

  Widget _item() {
    return slidableWithDelete(
        GestureDetector(
          onTap: () {},
          child: Container(
            height: 66.h,
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 6.h),
            child: Row(
              children: [
                cardNetworkImage("url", 50.h, 50.h),
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
                          'name',
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

  @override
  MessagePageC initController() => MessagePageC();

  @override
  List<Widget>? action() {
    return [
      GetBuilder<MessagePageC>(
          id: "switch",
          builder: (c) {
            return Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: CupertinoSwitch(
                  activeColor: C.FEC693,
                  value: c.isOpenMessageNotification,
                  onChanged: (onChanged) async {
                    controller.setSwitch(onChanged);
                  }),
            );
          })
    ];
  }
}

class MessagePageC extends BaseController {
  int pageNum = 0;

  bool isOpenMessageNotification = GStorage.getIsOpenMessageNotification();

  void setSwitch(bool isOpen) async {
    isOpenMessageNotification = isOpen;
    update(['switch']);
    final data = await setMessageNotificationStatus(isOpen);
    if (data.isOk()) {
      GStorage.saveMessageNotificationStatus(isOpen);
    } else {
      MyToast.show(data.msg);
      isOpenMessageNotification = !isOpen;
      update(['switch']);
    }
  }
}
