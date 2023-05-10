import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:metting/widget/my_toast.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../base/BaseController.dart';
import '../../base/BaseUiPage.dart';
import '../../base/base_refresh_page.dart';
import '../../core/common_configure.dart';
import '../../database/get_storage_manager.dart';
import '../../network/http_helper.dart';

class MessagePage extends BaseUiPage<MessagePageC> {
  MessagePage() : super(title: "消息");
  RefreshController mRefreshController = RefreshController();

  @override
  Widget? backWidget() {
    return null;
  }

  @override
  Widget createBody(BuildContext context) {
    return GetBuilder(
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

  void onRefresh() {}

  void onLoad() {}

  List<Widget> listWidget() {
    List<Widget> child = [];
    return child;
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
