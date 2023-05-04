import 'dart:ffi';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:metting/base/BaseController.dart';
import 'package:metting/base/BaseUiPage.dart';
import 'package:metting/tool/log.dart';
import 'package:metting/tool/view_tools.dart';
import 'package:scroll_date_picker/scroll_date_picker.dart';

import '../../core/common_configure.dart';
import '../../database/get_storage_manager.dart';
import '../../network/bean/user_data_res.dart';
import '../../network/http_helper.dart';
import '../../widget/image_m.dart';
import '../../widget/my_toast.dart';

class EditInfoPage extends BaseUiPage<EditInfoC> {
  EditInfoPage() : super(title: "编辑信息");

  @override
  Widget createBody(BuildContext context) {
    return SingleChildScrollView(
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              _info(),
              _finishBtn(),
            ],
          ),
          Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: EdgeInsets.only(top: 40.h),
              child: ClipOval(
                child: Container(
                  width: 123.w,
                  height: 123.w,
                  color: Colors.white,
                  padding: EdgeInsets.all(2.w),
                  child: GetBuilder<EditInfoC>(
                      id: 'head',
                      builder: (c) {
                        return circleNetworkWidget2(
                            c.headerImgUrl, 123.w, 123.w);
                      }),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _info() {
    return Container(
      padding: EdgeInsets.all(16.w),
      margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 100.h),
      decoration: BoxDecoration(
          color: Color(0x5013181E),
          borderRadius: BorderRadius.all(Radius.circular(5.w))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 80.h,
          ),
          SizedBox(
            height: 50.h,
            child: GetBuilder<EditInfoC>(
                id: "page",
                builder: (c) {
                  return Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Text("性别:",
                          style: TextStyle(color: C.FEC693, fontSize: 18.sp)),
                      Padding(padding: EdgeInsets.symmetric(horizontal: 8.w)),
                      _sex(),
                    ],
                  );
                }),
          ),
          SizedBox(
            height: 50.h,
            child: Row(
              children: [
                Text("昵称:", style: TextStyle(color: C.FEC693, fontSize: 18.sp)),
                Expanded(
                    child: Padding(
                  child: textFieldNick(),
                  padding: EdgeInsets.symmetric(horizontal: 8.w),
                )),
                GestureDetector(
                  child: Image.asset(
                    getImagePath('ic_refresh'),
                  ),
                  onTap: () {
                    controller.refreshNickName();
                  },
                )
              ],
            ),
          ),
          SizedBox(
            height: 50.h,
            child: GetBuilder<EditInfoC>(
                id: "page",
                builder: (c) {
                  return Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Text("年龄:",
                          style: TextStyle(color: C.FEC693, fontSize: 18.sp)),
                      Padding(padding: EdgeInsets.symmetric(horizontal: 8.w)),
                      GestureDetector(
                        onTap: () {
                          _showDateChoice();
                        },
                        child: Text('${c.birthday}',
                            style: TextStyle(
                                color: C.whiteFFFFFF, fontSize: 24.sp)),
                      ),
                    ],
                  );
                }),
          ),
          Text("常用语言(多选)", style: TextStyle(color: C.FEC693, fontSize: 18.sp)),
          SizedBox(
            height: 12.h,
          ),
          _langange()
        ],
      ),
    );
  }

  final TextEditingController _controllerInput = TextEditingController();

  Widget textFieldNick() {
    return GetBuilder<EditInfoC>(
        id: 'page',
        builder: (c) {
          final name =
              c.nickName.isEmpty ? c.mineInfo?.cname ?? "" : c.nickName;
          _controllerInput.text = name;
          return TextField(
            style: TextStyle(
              fontSize: 20.sp,
              color: C.whiteFFFFFF,
            ),
            maxLength: 12,
            decoration: const InputDecoration(
              filled: false,
              contentPadding: EdgeInsets.symmetric(vertical: 4.0),
              counterText: '',
              //此处控制最大字符是否显示
              alignLabelWithHint: true,
              enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Color(0x00FEC693), width: 0)),
              focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Color(0x00FEC693), width: 0)),
            ),
            controller: _controllerInput,
          );
        });
  }

  Widget _sex() {
    if (controller.isMan()) {
      return Image.asset(
        getImagePath("sex_man"),
        width: 46.w,
        height: 34.h,
      );
    } else {
      return Image.asset(
        getImagePath("sex_woman"),
        width: 46.w,
        height: 34.h,
      );
    }
  }

  Widget _finishBtn() {
    return Padding(
      padding: EdgeInsets.all(20.w),
      child: TextButton(
          onPressed: () async {
            EasyLoading.show(status: "保存中...");
            await controller.finish(_controllerInput.text);
            EasyLoading.dismiss();
          },
          child: Text(
            '确定',
            style: TextStyle(color: Color(0xff292929), fontSize: 22.sp),
          ),
          style: ButtonStyle(
              enableFeedback: false,
              backgroundColor: MaterialStateProperty.all(Color(0xffFEC693)),
              shape: MaterialStateProperty.all(
                RoundedRectangleBorder(
                  side: BorderSide(
                    width: 0.5,
                    color: Color(0xffFEC693),
                  ),
                  borderRadius: BorderRadius.circular(5),
                ),
              ))),
    );
  }

  @override
  EditInfoC initController() => EditInfoC();

  void _showDateChoice() {
    showModalBottomSheet(
        context: mContext,
        builder: (BuildContext context) {
          var selected = controller.selected;
          return StatefulBuilder(builder: (context, state) {
            return Container(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                color: Colors.white,
                height: 300.h,
                child: Column(
                  children: [
                    Row(
                      children: [
                        GestureDetector(
                          child: Text(
                            '取消',
                            style:
                                TextStyle(color: Colors.black, fontSize: 16.sp),
                          ),
                          onTap: () {
                            Navigator.pop(context);
                          },
                        ),
                        Expanded(
                            child: Text('选择生日',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.black, fontSize: 20.sp))),
                        GestureDetector(
                          child: Text('确定',
                              style:
                                  TextStyle(color: C.FEC693, fontSize: 16.sp)),
                          onTap: () {
                            controller.setBirthday(selected);
                            Navigator.pop(context);
                          },
                        ),
                      ],
                    ),
                    Container(
                      height: 220.h,
                      child: ScrollDatePicker(
                          options: DatePickerOptions(
                            itemExtent: 40.h,
                          ),
                          selectedDate: selected,
                          locale: Locale('zh'),
                          onDateTimeChanged: (DateTime value) {
                            selected = value;
                            state(() {});
                          }),
                    ),
                  ],
                ));
          });
        });
  }

  Widget _langange() {
    return Container(
      child: GetBuilder<EditInfoC>(
        id: 'language',
        builder: (c) {
          final list = <Widget>[];
          controller.language.forEach((element) {
            list.add(_lT(element));
          });
          return Wrap(
            children: list,
            spacing: 12.w,
          );
        },
      ),
    );
  }

  Widget _lT(String str) {
    var isChecked = controller.selectLanguage.contains(str);
    var bgColor = Color(0xFF000000);
    if (isChecked) {
      bgColor = Color(0xFFFEC693);
    }
    return InkWell(
      onTap: () {
        if (isChecked) {
          controller.selectLanguage.remove(str);
        } else {
          controller.selectLanguage.add(str);
        }
        controller.update(['language']);
      },
      child: Container(
        height: 28.h,
        padding: EdgeInsets.symmetric(horizontal: 8.w),
        margin: EdgeInsets.only(bottom: 8.h),
        decoration: BoxDecoration(
            color: bgColor,
            border: Border.all(color: Color(0xFFFEC693), width: 1.w),
            borderRadius: BorderRadius.all(Radius.circular(5.w))),
        child: FractionallySizedBox(
          widthFactor: null,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                str,
                maxLines: 1,
                style: TextStyle(color: Colors.white, fontSize: 12.sp),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class EditInfoC extends BaseController {
  String headerImgUrl = "";
  String? localImgUrl;
  String birthday = "";
  String nickName = "";
  var language = <String>[];
  var selectLanguage = <String>[];
  var selected = DateTime(2000, 1, 1);
  UserDataRes? mineInfo = getMineUserBasic();

  Future<void> finish(String nickName) async {
    if (localImgUrl != null) {
      final avatar = await fileUploadUrl(localImgUrl!);
      if (!avatar.isOk()) {
        MyToast.show(avatar.msg);
        return;
      } else {
        final avatarUrl = avatar.data;
        if (avatarUrl != null) {
          headerImgUrl = avatarUrl;
        }
      }
    }

    final r = await updateUserInfo({
      'avatar': headerImgUrl,
      'cname': nickName,
      'birthday': _getBirthday(),
      'lang': selectLanguage,
    });
    if (r.isOk()) {
      Get.back();
    } else {
      MyToast.show(r.msg);
    }
  }

  bool isMan() {
    return mineInfo?.sex == 1;
  }

  void refreshNickName() async {
    final data = await getRandName();
    if (data.isOk()) {
      nickName = data.data ?? "";
      update(['page']);
    }
  }

  void setBirthday(DateTime day) {
    selected = day;
    birthday = "${selected.year}年${selected.month}月${selected.day}日";
    update(['page']);
  }

  String _getBirthday() {
    String month = "${selected.month}";
    if (selected.month < 10) {
      month = "0${selected.month}";
    }
    String day = "${selected.day}";
    if (selected.day < 10) {
      day = "0${selected.day}";
    }
    return "${selected.year}-$month-$day";
  }

  @override
  void onInit() {
    super.onInit();
    _getInfo();
    language = getChatLangFStroage().chatLang ?? [];
    _setSelectedBirthday();
  }

  void _setSelectedBirthday() {
    try {
      final list = mineInfo?.birthday?.split("-") ?? <String>[];
      selected =
          DateTime(int.parse(list[0]), int.parse(list[1]), int.parse(list[2]));
      birthday = _getBirthday();
    } catch (e) {
      logger.e("mineInfo${mineInfo?.birthday?.split("-")} $e");
    }
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
    mineInfo = getUserBasic(getMineUID());
    headerImgUrl = mineInfo?.avatar ?? "";
    selectLanguage = mineInfo?.lang ?? [];
    _setSelectedBirthday();
    update(['head', 'page', 'language']);
  }
}
