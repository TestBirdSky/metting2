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
import 'package:metting/widget/my_toast.dart';

import '../../network/http_helper.dart';
import '../../tool/view_tools.dart';
import '../../widget/loading.dart';
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
                        onTap: () {
                          showInfoDialog(controller.mineInfo!);
                        },
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
          color: const Color(0xFFF7BB76),
          border: Border.all(color: Color(0xFFF13181E), width: 2.w),
          borderRadius: BorderRadius.all(Radius.circular(36.w))),
      child: GetBuilder<MineC>(
        id: "title",
        builder: (c) {
          if (selectId == 0) {
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
                        selectId = 1;
                        _pageSelected();
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
                        selectId = 0;
                        _pageSelected();
                      },
                    )),
                Expanded(
                  flex: 1,
                  child: _selectedStyle('我的动态'),
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
            color: const Color(0xFF13181E),
            border: Border.all(color: const Color(0xffFDFCDD), width: 1.w),
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

  final pageController = PageController(initialPage: 0);
  var selectId = 0;

  Widget _childPage() {
    return SizedBox(
      height: 550.h,
      child: PageView(
        controller: pageController,
        onPageChanged: (index) {
          selectId = index;
          controller.update(['title']);
        },
        children: [
          GetBuilder<MineC>(
              id: "mine_info",
              builder: (c) {
                return MineInfo(controller);
              }),
          MineStory()
        ],
      ),
    );
  }

  void _pageSelected() {
    pageController.animateTo(MediaQuery.of(mContext).size.width * selectId,
        duration: const Duration(milliseconds: 100), curve: Curves.linear);
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
  var isShowWomanInfo = true;
  var isShowManInfo = true;
  UserDataRes? mineInfo;
  var voicePrice = 50;
  var videoPrice = 60;

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
      _updatePrice();
    }
  }

  void _updateInfo() {
    headerImgUrl = mineInfo?.avatar ?? "";
    update(['head']);
  }

  void _updatePrice() {
    voicePrice = mineInfo?.voiceCall?.toInt() ?? 50;
    videoPrice = mineInfo?.videoCall?.toInt() ?? 60;
    update(['price']);
  }

  void setWoman(bool isOpen) async {
    LoadingUtils.showSaveLoading();
    final data = await setShowWomanInfo(isOpen);
    if (data.isOk()) {
      isShowWomanInfo = isOpen;
    } else {
      isShowWomanInfo = !isOpen;
    }
    update(["mine_info"]);
    LoadingUtils.dismiss();
  }

  void setMan(bool isOpen) async {
    LoadingUtils.showSaveLoading();
    final data = await setShowManInfo(isOpen);
    if (data.isOk()) {
      isShowManInfo = isOpen;
    } else {
      isShowManInfo = !isOpen;
    }
    update(["mine_info"]);
    LoadingUtils.dismiss();
  }

  void setVoice(int price) async {
    LoadingUtils.showSaveLoading();
    final data = await setVoiceCall(price);
    if (data.isOk()) {
      voicePrice = price;
      update(["price"]);
    } else {
      MyToast.show(data.msg);
    }
    LoadingUtils.dismiss();
  }

  void setVideo(int price) async {
    LoadingUtils.showSaveLoading();
    final data = await setVideoCall(price);
    if (data.isOk()) {
      videoPrice = price;
      update(["price"]);
    } else {
      MyToast.show(data.msg);
    }
    LoadingUtils.dismiss();
  }
}
