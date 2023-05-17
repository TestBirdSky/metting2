import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:metting/base/BaseController.dart';
import 'package:metting/base/BaseUiPage.dart';
import 'package:metting/widget/null_widget.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../base/base_refresh_page.dart';
import '../../core/common_configure.dart';
import '../../network/bean/withdrawal_history_res.dart';
import '../../network/http_helper.dart';

class WithdrawalRecordPage extends BaseUiPage<WithdrawalRecordController> {
  WithdrawalRecordPage() : super(title: "提现记录");
  RefreshController mRefreshController =
      RefreshController(initialRefresh: false);

  @override
  Widget createBody(BuildContext context) {
    return Stack(
      children: [
        Container(
          margin: EdgeInsets.symmetric(horizontal: 16.w),
          child: GetBuilder<WithdrawalRecordController>(
              id: 'list',
              builder: (c) {
                return c.recordList.isEmpty
                    ? NullWidget()
                    : RefreshConfiguration(
                        hideFooterWhenNotFull: true,
                        child: SmartRefresher(
                          enablePullDown: false,
                          enablePullUp: true,
                          footer: const MyClassicFooter(),
                          // 配置默认底部指示器
                          controller: mRefreshController,
                          onLoading: onLoad,
                          child: ListView(
                            shrinkWrap: true,
                            children: _list(),
                          ),
                        ),
                      );
              }),
        ),
      ],
    );
  }

  List<Widget> _list() {
    List<Widget> list = [_info()];
    for (var element in controller.recordList) {
      list.add(_item(element));
    }
    return list;
  }

  Widget _info() {
    return Container(
      height: 70.h,
      margin: EdgeInsets.symmetric(vertical: 10.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '提现总额',
            style: TextStyle(color: Colors.white, fontSize: 17.sp),
          ),
          SizedBox(
            height: 4.h,
          ),
          Text(
            "${controller.total}",
            style: TextStyle(color: C.FEC693, fontSize: 33.sp),
          ),
        ],
      ),
    );
  }

  Widget _item(WithdrawalBean bean) {
    return Container(
      height: 68.h,
      padding: EdgeInsets.symmetric(horizontal: 12.w),
      margin: EdgeInsets.only(top: 12.h),
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: C.FEC693, width: 1.w),
          borderRadius: BorderRadius.all(Radius.circular(8.w))),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '${bean.number}金币',
                  style: TextStyle(color: Color(0xff909090), fontSize: 16.sp),
                ),
                SizedBox(
                  height: 4.h,
                ),
                Text(
                  '${bean.time}',
                  style: TextStyle(color: Color(0xff909090), fontSize: 12.sp),
                ),
              ],
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${bean.money}RMB',
                style: TextStyle(color: C.FEC693, fontSize: 18.sp),
              ),
              SizedBox(
                height: 4.h,
              ),
              Text(
                '${bean.status}',
                style: TextStyle(color: Color(0xff666666), fontSize: 12.sp),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void onLoad() {
    controller._load(mRefreshController);
  }

  @override
  WithdrawalRecordController initController() => WithdrawalRecordController();
}

class WithdrawalRecordController extends BaseController {
  int page = 1;
  List<WithdrawalBean> recordList = [];
  int total = 0;

  @override
  void onInit() {
    super.onInit();
    _onRefresh();
  }

  void _onRefresh() async {
    final data = await getWithdrawalHistory(page);
    if (data.isOk()) {
      final d = data.data?.data;
      if (d != null) {
        total = d.sum?.toInt() ?? 0;
        recordList.addAll(d.list ?? []);
        update(['list']);
      }
    } else {}
  }

  void _load(RefreshController refreshController) async {
    final base = await getWithdrawalHistory(page);
    if (base.isOk()) {
      final d = base.data?.data;
      if (d != null) {
        page++;
        recordList.addAll(d.list ?? []);
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
