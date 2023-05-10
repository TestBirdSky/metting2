import 'package:flutter/widgets.dart';
import 'package:metting/tool/view_tools.dart';

class NullWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Align(
          alignment: Alignment.center,
          child: Image.asset(getImagePath('mine_vip')),
        )
      ],
    );
  }
}
