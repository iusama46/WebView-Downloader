import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'package:devWeb/main.dart';
import 'package:nb_utils/nb_utils.dart';

import '../main.dart';

class BottomNavigationComponent extends StatefulWidget {
  static String tag = '/BottomNavigationComponent';
  final Function(int)? onTap;


  BottomNavigationComponent({this.onTap});

  @override
  BottomNavigationComponentState createState() =>
      BottomNavigationComponentState();
}

class BottomNavigationComponentState extends State<BottomNavigationComponent> {
  //late List<model1.MenuStyle> mBottomMenuList;

  @override
  void initState() {
    super.initState();
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      backgroundColor: Theme.of(context).cardTheme.color,
      type: BottomNavigationBarType.fixed,
      showUnselectedLabels: true,
      showSelectedLabels: true,
      currentIndex: appStore.currentIndex,
      unselectedItemColor: textSecondaryColorGlobal,
      unselectedLabelStyle: secondaryTextStyle(),
      selectedLabelStyle: secondaryTextStyle(color: textPrimaryColorGlobal),
      selectedItemColor: appStore.primaryColors,
      items: [
        BottomNavigationBarItem(
          icon: Icon(LineIcons.home,
              size: 20, color: Theme.of(context).textTheme.subtitle1!.color),
          activeIcon:
              Icon(LineIcons.home, size: 20, color: appStore.primaryColors),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(LineIcons.alternateStore,
              size: 20, color: Theme.of(context).textTheme.subtitle1!.color),
          activeIcon: Icon(LineIcons.alternateStore,
              size: 20, color: appStore.primaryColors),
          label: 'Shop',
        ),
        BottomNavigationBarItem(
          icon: Icon(LineIcons.heart,
              size: 20, color: Theme.of(context).textTheme.subtitle1!.color),
          activeIcon:
              Icon(LineIcons.heart, size: 20, color: appStore.primaryColors),
          label: 'Wishlist',
        ),
        BottomNavigationBarItem(
          icon: Icon(LineIcons.userAlt,
              size: 20, color: Theme.of(context).textTheme.subtitle1!.color),
          activeIcon:
              Icon(LineIcons.userAlt, size: 20, color: appStore.primaryColors),
          label: 'My Account',
        )
      ],
      onTap: widget.onTap

    );
  }
}
