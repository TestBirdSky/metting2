import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

Widget slidableWithDelete(Widget child, SlidableActionCallback? onPressed) {
  return Slidable(
      endActionPane: ActionPane(
        extentRatio: 0.2,
        motion: const ScrollMotion(),
        children: [
          SlidableAction(
            onPressed: onPressed,
            backgroundColor: Color(0xFFFE4A49),
            foregroundColor: Colors.white,
            label: '删除',
          ),
        ],
      ),
      child: child);
}
