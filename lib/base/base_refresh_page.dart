import 'package:flutter/material.dart';
import 'package:metting/base/BaseUiPage.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

abstract class BaseRefreshPage<T> extends BaseUiPage<T> {
  BaseRefreshPage({required super.title});

  RefreshController refreshController();

  @override
  Widget createBody(BuildContext context) {
    return RefreshConfiguration(
      // Viewport不满一屏时,禁用上拉加载更多功能,应该配置更灵活一些，比如说一页条数大于等于总条数的时候设置或者总条数等于0
      hideFooterWhenNotFull: true,
      child: SmartRefresher(
        enablePullDown: true,
        enablePullUp: true,
        header: const MyClassicHeader(),
        footer: const MyClassicFooter(),
        // 配置默认底部指示器
        controller: refreshController(),
        onRefresh: onRefresh,
        onLoading: onLoading,
        child: refreshLayout(),
      ),
    );
  }

  Widget refreshLayout();

  void onLoading() {}

  void onRefresh() {}
}

///刷新头
class MyClassicHeader extends StatelessWidget {
  const MyClassicHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const ClassicHeader(
      refreshingText: '数据加载中...',
      releaseText: '释放刷新数据',
      idleText: '下拉刷新',
      completeText: '刷新完成',
      failedText: '获取数据失败',
    );
  }
}

///加载脚
class MyClassicFooter extends StatelessWidget {
  const MyClassicFooter({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return const ClassicFooter(
        idleText: '上拉加载',
        loadingText: '加载中...',
        canLoadingText: '上拉加载更多',
        noDataText: '');
  }
}
