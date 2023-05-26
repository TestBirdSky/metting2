import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:metting/page/message/message_list.dart';
import 'package:metting/tool/log.dart';
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
import 'call_record_list.dart';

class MessagePage extends BaseUiPage<MessagePageC> {
  MessagePage() : super(title: "消息");

  @override
  Widget? backWidget() {
    return null;
  }

  @override
  Widget createBody(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _tabView(),
        Expanded(child: _childPage()),
      ],
    );
  }

  final pageController = PageController(initialPage: 0);

  Widget _tabView() {
    return GetBuilder<MessagePageC>(
        id: 'title',
        builder: (c) {
          return Container(
            height: 30.h,
            width: 140.w,
            margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            decoration: BoxDecoration(
                color: Colors.transparent,
                border: Border.all(color: Colors.grey, width: 1.w),
                borderRadius: BorderRadius.circular(18.w)),
            child: Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      _setSelectIndex(0);
                      _pageSelected();
                    },
                    child: Stack(
                      children: [
                        Container(
                          width: double.infinity,
                          height: double.infinity,
                          decoration: BoxDecoration(
                              color: selectId == 0
                                  ? Colors.black
                                  : Colors.transparent,
                              borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(18.w),
                                topLeft: Radius.circular(18.w),
                              )),
                        ),
                        Align(
                          alignment: Alignment.center,
                          child: Text(
                            '消息',
                            style:
                                TextStyle(color: Colors.white, fontSize: 12.sp),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                Container(
                  width: 1.w,
                  height: double.infinity,
                  color: Colors.grey,
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      _setSelectIndex(1);
                      _pageSelected();
                    },
                    child: Stack(
                      children: [
                        Container(
                          width: double.infinity,
                          height: double.infinity,
                          decoration: BoxDecoration(
                              color: selectId == 1
                                  ? Colors.black
                                  : Colors.transparent,
                              borderRadius: BorderRadius.only(
                                bottomRight: Radius.circular(18.w),
                                topRight: Radius.circular(18.w),
                              )),
                        ),
                        Align(
                          alignment: Alignment.center,
                          child: Text(
                            '通话记录',
                            style:
                                TextStyle(color: Colors.white, fontSize: 12.sp),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        });
  }

  int selectId = 0;

  Widget _childPage() {
    return SizedBox(
      child: PageView(
        controller: pageController,
        onPageChanged: (index) {
          _setSelectIndex(index);
        },
        children: [MessageListPage(), CallRecordListPageg()],
      ),
    );
  }

  void _setSelectIndex(int index) {
    if (selectId == index) return;
    selectId = index;
    controller.update(['title']);
  }

  void _pageSelected() {
    pageController.animateTo(MediaQuery.of(mContext).size.width * selectId,
        duration: const Duration(milliseconds: 300), curve: Curves.linear);
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
              child: SizedBox(
                width: 52.w,
                height: 32.h,
                child: CupertinoSwitch(
                    activeColor: C.FEC693,
                    value: c.isOpenMessageNotification,
                    onChanged: (onChanged) async {
                      controller.setSwitch(onChanged);
                    }),
              ),
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
