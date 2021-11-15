import 'package:flutter/material.dart';
import 'package:devWeb/main.dart';
import 'package:devWeb/model/MainResponse.dart' as model1;

import 'package:devWeb/utils/AppWidget.dart';
import 'package:nb_utils/nb_utils.dart';

class SubMenuComponent extends StatefulWidget {
  static String tag = '/TestScreen';

  final model1.MenuStyle? mMenuList;
  final int? i;

  const SubMenuComponent({Key? key, this.mMenuList, this.i}) : super(key: key);

  @override
  SubMenuComponentState createState() => SubMenuComponentState();
}

class SubMenuComponentState extends State<SubMenuComponent> {
  List<model1.MenuStyle> subList = [];
  bool? isParentSelect=false;
  bool? isChilderenSelect=false;

  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    //
    if (widget.mMenuList!.children != null) {
      subList.addAll(widget.mMenuList!.children!);
    }
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  Widget mTestWidget(List<model1.MenuStyle>? mMenuList){
    return ListView.builder(
      itemCount: mMenuList!.length,
      shrinkWrap: true,
      scrollDirection: Axis.vertical,
      padding: EdgeInsets.all(0),
      physics: NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        return ExpansionTile(
          onExpansionChanged: (value){
            isChilderenSelect=value;
          },
          title: Text(
            mMenuList[index].title!,
            style: primaryTextStyle(),
          ),
          trailing: Icon(isChilderenSelect==false?Icons.keyboard_arrow_right:Icons.keyboard_arrow_down_rounded, color: Theme.of(context).iconTheme.color!.withOpacity(0.5)),
          tilePadding: EdgeInsets.all(0),
          childrenPadding: EdgeInsets.all(0),
          leading: appStore.isDarkModeOn == true ? cachedImage(mMenuList[index].image, width: 22, height: 22, color: Theme.of(context).iconTheme.color) : cachedImage(mMenuList[index].image, width: 22, height: 22),
          children: [
            ListView.builder(
              shrinkWrap: true,
              padding: EdgeInsets.only(left: 16),
              scrollDirection: Axis.vertical,
              itemCount: mMenuList[index].children!.length,
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (context, i) {
                model1.MenuStyle data = mMenuList[index].children![i];
                return SettingItemWidget(
                  title: data.title!,
                  padding: EdgeInsets.only(top: 6, bottom: 6),
                  titleTextStyle: primaryTextStyle(),
                  leading: appStore.isDarkModeOn == true ? cachedImage(data.image, width: 22, height: 22, color: Theme.of(context).iconTheme.color) : cachedImage(data.image, width: 22, height: 22),
                  onTap: () {
                    if (data.children!.isNotEmpty || data.children == null) {
                      SubMenuComponent(mMenuList: data.children![index]);
                    } else {

                    }
                  },
                );
              },
            )
          ],
        );
      },
    );
  }
  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: Text(
        widget.mMenuList!.title!,
        style: primaryTextStyle(),
      ).onTap(() {
        if (widget.mMenuList!.children!.isEmpty) {

        }
      }),
      onExpansionChanged: (value){
        setState(() {
          isParentSelect=value;
        });
      },
      trailing: Icon(isParentSelect==false?Icons.keyboard_arrow_right:Icons.keyboard_arrow_down_rounded, color: Theme.of(context).iconTheme.color!.withOpacity(0.5)),
      tilePadding: EdgeInsets.all(0),
      childrenPadding: EdgeInsets.all(0),
      leading: appStore.isDarkModeOn == true
          ? cachedImage(widget.mMenuList!.image, width: 22, height: 22, color: Theme.of(context).iconTheme.color!.withOpacity(0.5))
          : cachedImage(widget.mMenuList!.image, width: 22, height: 22),
      children: <Widget>[
        mTestWidget(widget.mMenuList!.children),
      ],
    );
  }
}
