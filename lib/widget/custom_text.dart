import 'package:flutter/material.dart';

class CustomText extends StatelessWidget {
  String text;
  TextStyle textStyle;
  EdgeInsetsGeometry margin; //控件的margin属性 外边距
  EdgeInsetsGeometry padding; //控件的padding属性 外边距
  Alignment textAlign;
  Color bgColor;

  CustomText(
      {required this.text,
      this.textStyle = const TextStyle(fontSize: 15.0, color: Colors.black),
      this.textAlign = Alignment.topLeft,
      this.margin = const EdgeInsets.all(0),
      this.padding = const EdgeInsets.all(0),
      this.bgColor = const Color(0x00000000)});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: bgColor,
      alignment: textAlign,
      margin: margin,
      padding: padding,
      child: Text(text, style: textStyle),
    );
  }
}
