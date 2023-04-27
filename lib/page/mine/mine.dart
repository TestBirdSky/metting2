import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:metting/base/BaseController.dart';
import 'package:metting/base/BaseUiPage.dart';
import 'package:metting/database/get_storage_manager.dart';
import 'package:metting/network/bean/user_data_res.dart';
import 'package:metting/page/mine/mine_info.dart';
import 'package:metting/widget/dialog_person_info.dart';
import 'package:metting/widget/image_m.dart';

import '../../network/http_helper.dart';
import '../../tool/view_tools.dart';
import 'mine_story.dart';

class MinePage extends BaseUiPage<MineC> {
  MinePage() : super(title: "我的");

  @override
  Widget createBody(BuildContext context) {
    return Stack(
      children: [
        ConstrainedBox(
          constraints: const BoxConstraints.expand(),
          child: Image.asset(
            getImagePath("ic_mine_bg"),
            fit: BoxFit.cover,
          ),
        ),
        SingleChildScrollView(
            child: Column(
          children: [
            _widgetPersonIcon(),
            _selectPageBtn(),
            _childPage(),
            SizedBox(
              height: 90.h,
            )
          ],
        )),
      ],
    );
  }

  Widget _widgetPersonIcon() {
    return Container(
      height: 248.w,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Image.asset(
            getImagePath(
              'ic_red_circle',
            ),
            fit: BoxFit.fill,
            width: 248.w,
            height: 248.w,
          ),
          Padding(
            padding: EdgeInsets.all(0.h),
            child: ClipOval(
              child: Container(
                width: 115.w,
                height: 115.w,
                padding: EdgeInsets.all(1.w),
                child: GetBuilder<MineC>(
                    id: 'head',
                    builder: (c) {
                      return GestureDetector(
                        onTap: showInfoDialog,
                        child:
                            circleNetworkWidget(c.headerImgUrl, 115.w, 115.w),
                      );
                    }),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              InkWell(
                onTap: () {},
                child: Image.asset(
                  getImagePath('mine_edit'),
                  width: 46.w,
                  height: 46.w,
                ),
              ),
              SizedBox(
                width: 187.w,
              ),
              InkWell(
                onTap: () {},
                child: Image.asset(
                  getImagePath('mine_phone'),
                  width: 46.w,
                  height: 46.w,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _selectPageBtn() {
    return Container(
      height: 70.h,
      margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
          color: Color(0xFFF7BB76),
          border: Border.all(color: Color(0xFFF13181E), width: 2.w),
          borderRadius: BorderRadius.all(Radius.circular(30.w))),
      child: GetBuilder<MineC>(
        id: "pageSelect",
        builder: (c) {
          if (c.isSelectedMyInfo) {
            return Row(
              children: [
                Expanded(
                  flex: 1,
                  child: _selectedStyle('我的信息'),
                ),
                Expanded(
                    flex: 1,
                    child: InkWell(
                      child: _unselected("我的故事"),
                      onTap: () {
                        c.isSelectedMyInfo = false;
                        c.update(["pageSelect"]);
                      },
                    )),
              ],
            );
          } else {
            return Row(
              children: [
                Expanded(
                    flex: 1,
                    child: InkWell(
                      child: _unselected("我的信息"),
                      onTap: () {
                        c.isSelectedMyInfo = true;
                        c.update(["pageSelect"]);
                      },
                    )),
                Expanded(
                  flex: 1,
                  child: _selectedStyle('我的故事'),
                ),
              ],
            );
          }
        },
      ),
    );
  }

  Widget _selectedStyle(String name) {
    return Container(
        height: 60.h,
        alignment: Alignment.center,
        decoration: BoxDecoration(
            color: Color(0xFF13181E),
            border: Border.all(color: Color(0xffFDFCDD), width: 1.w),
            borderRadius: BorderRadius.all(Radius.circular(30.w))),
        child: Text(
          name,
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.white, fontSize: 21.sp),
        ));
  }

  Widget _unselected(String name) {
    return Text(
      name,
      textAlign: TextAlign.center,
      style: TextStyle(color: Color(0xFF2B2B2B), fontSize: 21.sp),
    );
  }

  Widget _childPage() {
    return GetBuilder<MineC>(
        id: "pageSelect",
        builder: (c) {
          if (c.isSelectedMyInfo) {
            return MineInfo();
          } else {
            return MineStory();
          }
        });
  }

  @override
  Widget? backWidget() {
    return null;
  }

  @override
  MineC initController() => MineC();
}

class MineC extends BaseController {
  var headerImgUrl = "";
  var isSelectedMyInfo = true;
  UserDataRes? mineInfo;

  @override
  void onInit() {
    super.onInit();
    _getInfo();
  }

  @override
  void onReady() {
    super.onReady();
    mineInfo = getUserBasic(getMineUID());
    _updateInfo();
  }

  void _getInfo() async {
    final data = await getUserData(getMineUID());
    if (data.isOk()) {
      mineInfo = data.data;
      if (mineInfo != null) {
        saveUserBasic(mineInfo!);
      }
      _updateInfo();
    }
  }

  void _updateInfo() {
    headerImgUrl = mineInfo?.avatar ?? "";
    update(['head']);
  }

  void _setMine(){

  }
}
