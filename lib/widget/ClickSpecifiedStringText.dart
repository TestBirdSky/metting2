import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

//可以点击某个自定的字符串的控件
class ClickSpecifiedStringText extends StatelessWidget {
  //字符串开始不能点击
  final List<String> originalStr; //不可点击字符串
  final List<String> clickStr; //可点击字符串 按照顺序
  final List<TapGestureRecognizer> onTaps; //回调
  TextStyle? textStyle;
  TextStyle? clickTextStyle;
  TextAlign textAlign;
  EdgeInsetsGeometry? padding; //控件的padding属性
  EdgeInsetsGeometry? margin; //控件的margin属性
  double? fontSize=12.sp; //控件的margin属性

  ClickSpecifiedStringText({
    required this.originalStr,
    required this.clickStr,
    required this.onTaps,
    this.textStyle,
    this.clickTextStyle,
    this.textAlign = TextAlign.center,
    this.padding,
    this.margin,
    this.fontSize,
  });

  @override
  Widget build(BuildContext context) {
    List<String> list = _stringHandler(originalStr, clickStr);

    return Container(
      padding: padding,
      margin: margin,
      child: Column(
        children: <Widget>[
          RichText(
            textAlign: textAlign,
            text: TextSpan(children: getChild(list)),
            strutStyle: const StrutStyle(height: 1.5), //行高
          )
        ],
      ),
    );
  }

  List<String> _stringHandler(List<String> originalStr, List<String> splitStr) {
    List<String> list = [];
    for (int i = 0; i < originalStr.length; i++) {
      list.add(originalStr[i]);
      if (i < splitStr.length) {
        list.add(splitStr[i]);
      }
    }
    return list;
  }

  List<InlineSpan> getChild(List<String> list) {
    List<InlineSpan> lists = [];
    int length = list.length;
    int indexOnTaps = 0;
    for (int i = 0; i < length; i++) {
      if (i % 2 == 0) {
        lists.add(TextSpan(
            text: list[i],
            style: textStyle ??
                TextStyle(
                    fontSize: fontSize,
                    color: Color(0xff8C8C8C))));
      } else {
        //点击区域
        lists.add(
          TextSpan(
              text: list[i],
              style: clickTextStyle ??
                  TextStyle(
                    fontSize: fontSize,
                    color: Color(0xffFEC693),
                  ),
              recognizer: onTaps[indexOnTaps++]),
        );
      }
    }
    return lists;
  }
}
