import 'package:flutter/cupertino.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:metting/page/home/home.dart';

class HomeList extends GetView<HomeC> {
  @override
  Widget build(BuildContext context) {
    return ListView(children: _list());
  }

  List<Widget> _list() {
    List<Widget> list = [];
    for (int i = 0; i < 20; i++) {
      if (controller.isBoy(i)) {
        list.add(_pageViewRight(_itemText('text$i'), _itemInfo()));
      } else {
        list.add(_pageViewLeft(_itemInfo(), _itemText('text$i')));
      }
    }
    list.add(SizedBox(
      height: 60.h,
    ));
    return list;
  }

  final itemHeight = 78.h;

  Widget _pageViewRight(Widget left, Widget right) {
    return Container(
      height: itemHeight,
      margin: EdgeInsets.symmetric(vertical: 6.h),
      child: PageView(
        controller: PageController(initialPage: 0, viewportFraction: 0.95),
        children: [left, right],
      ),
    );
  }

  Widget _pageViewLeft(Widget left, Widget right) {
    return Container(
      height: itemHeight,
      margin: EdgeInsets.symmetric(vertical: 6.h),
      child: PageView(
        controller: PageController(initialPage: 1, viewportFraction: 0.95),
        children: [left, right],
      ),
    );
  }

  Widget _itemText(String text) {
    return Container(
      height: itemHeight,
      padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 12.h),
      decoration: BoxDecoration(
          color: Color(0xff13181E),
          borderRadius: BorderRadius.all(Radius.circular(5.w))),
      child: Text(
        text,
        style: TextStyle(color: Color(0xffBBBABA), fontSize: 12.sp),
      ),
    );
  }

  Widget _itemInfo() {
    return Container(
      height: itemHeight,
      decoration: BoxDecoration(
          color: Color(0xffFDFCDD),
          borderRadius: BorderRadius.all(Radius.circular(5.w))),
      child: Row(
          // cardNetworkImage()
          ),
    );
  }
}
