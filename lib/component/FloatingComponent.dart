import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:devWeb/main.dart';
import 'package:devWeb/model/MainResponse.dart';

import 'package:devWeb/utils/AppWidget.dart';
import 'package:devWeb/utils/ExpantableFloating.dart';
import 'package:devWeb/utils/constant.dart';
import 'package:nb_utils/nb_utils.dart';

class FloatingComponent extends StatefulWidget {
  static String tag = '/FloatingComponent';

  @override
  FloatingComponentState createState() => FloatingComponentState();
}

class FloatingComponentState extends State<FloatingComponent> {
  late List<FloatingButton> mFloatingList;

  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    //
    Iterable mFloating = jsonDecode(getStringAsync(FLOATING_DATA));
    mFloatingList = mFloating.map((model) => FloatingButton.fromJson(model)).toList();
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  Widget mCircleWidget() {
    return ExpandableFab(
      distance: 112.0,
      children: [
        for (int i = 0; i < appStore.mFABList.length; i++)
          ActionButton(
            icon: mFloatingList[i].image,
            onPressed: () {

            },
          )
      ],
    );
  }

  Widget mMenuWidget(BuildContext context) {
    return SpeedDial(
      marginEnd: 18,
      marginBottom: 20,
      icon: Icons.add,
      activeIcon: Icons.close_sharp,
      child: cachedImage(getStringAsync(FLOATING_LOGO), color: white).paddingAll(16),
      buttonSize: 52.0,
      visible: true,
      closeManually: true,
      renderOverlay: true,
      curve: Curves.bounceIn,
      overlayOpacity: 0.5,
      backgroundColor: appStore.primaryColors,
      foregroundColor: white,
      shape: CircleBorder(),
      children: [

      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return getStringAsync(FLOATING_STYLE) == "regular" ? mMenuWidget(context) : mCircleWidget();
  }
}
