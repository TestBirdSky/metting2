import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';


void commonAlertD(
  BuildContext mContext,
  String context,
  String positiveStr, {
  String? negativeStr,
  String? title,
  VoidCallback? positiveCall,
  VoidCallback? negativeCall,
}) {
  final listBtn = <Widget>[];
  Widget positiveBtn = TextButton(
    child: Text(
      positiveStr,
      // style: TextStyle(color: C.FEC693),
    ),
    onPressed: () {
      Navigator.pop(mContext);
      positiveCall?.call();
    },
  );
  listBtn.add(positiveBtn);
  if (negativeStr != null) {
    listBtn.add(TextButton(
      child: Text(
        negativeStr,
        // style: TextStyle(color: C.Dialog_Negative_C),
      ),
      onPressed: () {
        Navigator.pop(mContext);
        negativeCall?.call();
      },
    ));
  }
  //设置对话框
  CupertinoAlertDialog alert = CupertinoAlertDialog(
    title: title == null ? null : Text(title),
    content: Text(context),
    actions: listBtn,
  );
  //显示对话框
  showDialog(
    context: mContext,
    builder: (BuildContext context) {
      return alert;
    },
  );
}
