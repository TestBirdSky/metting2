import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:metting/tool/view_tools.dart';

Widget cardNetworkImage(String url, double widget, double height,
    {ShapeBorder? shape,
    EdgeInsetsGeometry? margin,
    double? radius,
    Widget? errorWidget }) {
  return Card(
    margin: margin ?? EdgeInsets.all(4.w),
    shape: shape ??
        RoundedRectangleBorder(
            borderRadius: BorderRadiusDirectional.circular(radius ?? 4.w)),
    clipBehavior: Clip.antiAlias,
    color: Colors.grey,
    child: SizedBox(
        width: widget,
        height: height,
        child: CachedNetworkImage(
          fit: BoxFit.cover,
          imageUrl: url,
          errorWidget: (context, url, error) => errorWidget??
              Image.asset(
                'assets/images/image_load_failed.png',
              ),
        )),
  );
}

Widget circleNetworkWidget(String url, double widget, double height,
    {Widget? errorWidget}) {
  return  ClipOval(
          child: CachedNetworkImage(
        fit: BoxFit.cover,
        imageUrl: url,
        errorWidget: (context, url, error) =>
            errorWidget ??
            Image.asset(
              getImagePath('ic_default_icon2'),
            ),
      ));
}


Widget circleNetworkWidget2(String url, double widget, double height,
    {Widget? errorWidget}) {
  return  ClipOval(
      child: CachedNetworkImage(
        fit: BoxFit.cover,
        imageUrl: url,
        errorWidget: (context, url, error) =>
        errorWidget ??
            Image.asset(
              getImagePath('ic_default_icon1'),
            ),
      ));
}
