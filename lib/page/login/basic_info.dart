import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:metting/base/BaseController.dart';
import 'package:metting/base/BaseStatelessPage.dart';
import 'package:metting/page/mian/main.dart';
import 'package:metting/tool/log.dart';
import 'package:metting/widget/my_toast.dart';
import 'package:scroll_date_picker/scroll_date_picker.dart';

import '../../core/common_configure.dart';
import '../../database/get_storage_manager.dart';
import '../../network/http_helper.dart';
import '../../tool/gallery.dart';
import '../../tool/view_tools.dart';
import '../../widget/bottom_popup.dart';

class BasicInfoPage extends BaseStatelessPage<BaseInfoC> {
  final TextEditingController _controllerInput = TextEditingController();

  @override
  Widget createBody(BuildContext context) {
    return Stack(
      children: [
        ConstrainedBox(
          constraints: const BoxConstraints.expand(),
          child: Image.asset(
            getImagePath("ic_register_bg"),
            fit: BoxFit.cover,
          ),
        ),
        SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () {
                  _showChoicePicture();
                },
                child: _icon(),
              ),
              _info(),
              SizedBox(
                height: 90.h,
              ),
              _finishBtn(),
            ],
          ),
        )
      ],
    );
  }

  Widget _icon() {
    return Padding(
      padding: EdgeInsets.only(top: 81.h),
      child: Container(
        width: 107.h,
        height: 107.h,
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Padding(
              padding: EdgeInsets.only(bottom: 8.h),
              child: Container(
                width: 90.w,
                height: 90.h,
                child: GetBuilder<BaseInfoC>(
                    id: 'head',
                    builder: (c) {
                      if (c.headerImgUrlLocal != null) {
                        return Image.file(
                          File("${c.headerImgUrlLocal}"),
                          fit: BoxFit.cover,
                        );
                      } else {
                        return Image.asset(
                            getImagePath('ic_default_icon1'));
                      }
                    }),
              ),
            ),
            Image.asset(
              getImagePath(
                'person_bg',
              ),
              width: 106.w,
              height: 106.h,
            ),
          ],
        ),
      ),
    );
  }

  Widget _info() {
    return Container(
      padding: EdgeInsets.all(16.w),
      margin: EdgeInsets.symmetric(horizontal: 20.w),
      decoration: BoxDecoration(
          color: Color(0x5013181E),
          borderRadius: BorderRadius.all(Radius.circular(5.w))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 50.h,
            child: Row(
              children: [
                Text("昵称:", style: TextStyle(color: C.FEC693, fontSize: 24.sp)),
                Expanded(
                  child: Container(
                    child: GetBuilder<BaseInfoC>(
                        id: 'name',
                        builder: (builder) {
                          return Padding(
                            padding: EdgeInsets.symmetric(horizontal: 8.w),
                            child: textFieldNick(),
                          );
                        }),
                  ),
                ),
                InkWell(
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
            child: GetBuilder<BaseInfoC>(
                id: "sex",
                builder: (c) {
                  String man = 'sex_man_un';
                  String woman = 'sex_woman_un';
                  if (controller.sex == 1) {
                    man = 'sex_man';
                  } else if (controller.sex == 2) {
                    woman = 'sex_woman';
                  }
                  return Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Text("性别:",
                          style: TextStyle(color: C.FEC693, fontSize: 24.sp)),
                      Padding(padding: EdgeInsets.symmetric(horizontal: 8.w)),
                      InkWell(
                        onTap: () {
                          controller.sex = 1;
                          controller.update(['sex']);
                        },
                        child: Image.asset(
                          getImagePath(man),
                          width: 69.w,
                          height: 45.h,
                        ),
                      ),
                      Padding(padding: EdgeInsets.symmetric(horizontal: 8.w)),
                      InkWell(
                        onTap: () {
                          controller.sex = 2;
                          controller.update(['sex']);
                        },
                        child: Image.asset(
                          getImagePath(woman),
                          width: 69.w,
                          height: 45.h,
                        ),
                      ),
                    ],
                  );
                }),
          ),
          SizedBox(
            height: 50.h,
            child: GetBuilder<BaseInfoC>(
                id: "bir",
                builder: (c) {
                  return Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Text("生日:",
                          style: TextStyle(color: C.FEC693, fontSize: 24.sp)),
                      Padding(padding: EdgeInsets.symmetric(horizontal: 8.w)),
                      GestureDetector(
                        onTap: () {
                          _showDateChoice();
                        },
                        child: Text('${c.age}',
                            style: TextStyle(
                                color: C.whiteFFFFFF, fontSize: 24.sp)),
                      ),
                    ],
                  );
                }),
          ),
          Text("常用语言(多选)", style: TextStyle(color: C.FEC693, fontSize: 24.sp)),
          SizedBox(
            height: 12.h,
          ),
          _langange(),
        ],
      ),
    );
  }

  Widget _langange() {
    return Container(
      child: GetBuilder<BaseInfoC>(
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

  Widget textFieldNick() {
    _controllerInput.text = controller.nickName;
    _controllerInput.selection = TextSelection.fromPosition(
        TextPosition(offset: _controllerInput.text.length));
    return TextField(
      style: TextStyle(
        fontSize: 20.sp,
        color: C.whiteFFFFFF,
      ),
      maxLength: 16,
      decoration: const InputDecoration(
        filled: false,
        contentPadding: EdgeInsets.symmetric(vertical: 4.0),
        counterText: '',
        //此处控制最大字符是否显示
        alignLabelWithHint: true,
        // hintText: '请输入昵称',
        // hintStyle: TextStyle(
        //   fontSize: 18.sp,
        //   color: C.whiteFFFFFF,
        // ),
        enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Color(0x00FEC693), width: 0)),
        focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Color(0x00FEC693), width: 0)),
      ),
      controller: _controllerInput,
    );
  }

  Widget _finishBtn() {
    return Padding(
      padding: EdgeInsets.all(20.w),
      child: TextButton(
          onPressed: () async {
            controller.nickName = _controllerInput.text;
            EasyLoading.show(status: "保存中...");
            await controller.finishClick();
            EasyLoading.dismiss();
          },
          style: ButtonStyle(
              enableFeedback: false,
              backgroundColor: MaterialStateProperty.all(Color(0xffFEC693)),
              shape: MaterialStateProperty.all(
                RoundedRectangleBorder(
                  side: const BorderSide(
                    width: 0.5,
                    color: Color(0xffFEC693),
                  ),
                  borderRadius: BorderRadius.circular(5),
                ),
              )),
          child: Text(
            '完成',
            style: TextStyle(color: Color(0xff292929), fontSize: 22.sp),
          )),
    );
  }

  @override
  initController() => BaseInfoC();

  void _showChoicePicture() {
    showBottomImageSource(mContext, () async {
      final file = await takePhoto();
      if (file != null) controller.updateImgUrl(file.path);
    }, () async {
      final file = await getImageFromGallery();
      if (file != null) controller.updateImgUrl(file.path);
    });
  }

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
}

class BaseInfoC extends BaseController {
  //本地选择的图片路径
  String? headerImgUrlLocal;
  var selectLanguage = <String>[];
  var sex = 0;
  var nickName = "";
  var selected = DateTime(2000, 1, 1);
  var age = "2000年01月01日";
  var language = [];

  @override
  void onInit() {
    super.onInit();
    language.addAll(getChatLangFStroage().chatLang ?? []);
    refreshNickName();
  }

  void setBirthday(DateTime day) {
    selected = day;
    age = "${selected.year}年${selected.month}月${selected.day}日";
    update(['bir']);
  }

  void updateImgUrl(String path) {
    headerImgUrlLocal = path;
    update(['head']);
  }

  void refreshNickName() async {
    final data = await getRandName();
    logger.i('refreshNickName $data --> ${data.data}');
    if (data.isOk()) {
      nickName = data.data ?? "";
      logger.i('refreshNickName $nickName');
      update(['name']);
    }
  }

  Future<void> finishClick() async {
    if (headerImgUrlLocal == null) {
      MyToast.show("请设置您的头像");
      return;
    }
    if (sex == 0) {
      MyToast.show("请选择您的性别");
      return;
    }
    final avatar = await fileUploadUrl(headerImgUrlLocal!);
    if (!avatar.isOk()) {
      MyToast.show(avatar.msg);
      return;
    }
    final r = await updateUserInfo({
      'sex': sex,
      'avatar': avatar.data,
      'cname': nickName,
      'birthday': _getBirthday(),
      'lang': selectLanguage,
    });
    if (r.isOk()) {
      Get.off(() => MainPage());
    } else {
      MyToast.show(r.msg);
    }
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
}
